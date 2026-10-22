import ballerina/io;
import ballerinax/reckon.one;

configurable string accessToken = ?;
configurable string subscriptionKey = ?;
configurable string bookId = ?;
configurable int pageSize = 50;

type SupplierTotal record {|
    string name;
    decimal outstanding;
|};

// Reckon One requires the subscription key on every call.
final map<string> keyHeader = {"Ocp-Apim-Subscription-Key": subscriptionKey};

public function main() returns error? {
    if pageSize <= 0 || pageSize > int:SIGNED32_MAX_VALUE {
        return error(string `pageSize must be between 1 and ${int:SIGNED32_MAX_VALUE}, but was ${pageSize}`);
    }
    one:Client reckon = check new ({auth: {token: accessToken}});
    int:Signed32 perPage = <int:Signed32>pageSize;

    // Step 1: Page through every bill and total the outstanding balance per supplier id.
    map<SupplierTotal> totalsBySupplier = {};
    int billsWithoutSupplier = 0;
    decimal outstandingWithoutSupplier = 0d;
    int:Signed32 page = 1;
    while true {
        one:Bills bills = check reckon->listBills(bookId, headers = keyHeader, queries = {page, perPage});
        one:Bill[] pageItems = bills?.list ?: [];
        foreach one:Bill bill in pageItems {
            decimal? balance = bill?.balance;
            if balance is () {
                return error(string `Bill ${bill?.billNumber ?: bill?.id ?: "(unknown)"} has no balance`);
            }
            string? supplierId = bill?.supplier?.id;
            if supplierId is () {
                billsWithoutSupplier += 1;
                outstandingWithoutSupplier += balance;
                continue;
            }
            SupplierTotal total = totalsBySupplier[supplierId] ?: {name: bill?.supplier?.name ?: supplierId, outstanding: 0d};
            total.outstanding += balance;
            totalsBySupplier[supplierId] = total;
        }
        if pageItems.length() < perPage {
            break;
        }
        page = <int:Signed32>(page + 1);
    }

    // Step 2: Count the suppliers in the book for context.
    int supplierCount = 0;
    page = 1;
    while true {
        one:Suppliers suppliers = check reckon->listSuppliers(bookId, headers = keyHeader, queries = {page, perPage});
        one:Supplier[] pageItems = suppliers?.list ?: [];
        supplierCount += pageItems.length();
        if pageItems.length() < perPage {
            break;
        }
        page = <int:Signed32>(page + 1);
    }

    io:println("Suppliers in book: ", supplierCount);
    foreach SupplierTotal total in totalsBySupplier {
        io:println(total.name, ": ", total.outstanding);
    }
    if billsWithoutSupplier > 0 {
        io:println("Bills with no supplier: ", billsWithoutSupplier, " (outstanding ", outstandingWithoutSupplier, ")");
    }
}
