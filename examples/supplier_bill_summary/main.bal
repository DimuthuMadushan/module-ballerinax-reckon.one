import ballerina/io;
import ballerinax/reckon.one;

configurable string accessToken = ?;
configurable string bookId = ?;
configurable int pageSize = 50;

public function main() returns error? {
    one:Client reckon = check new ({auth: {token: accessToken}});
    int:Signed32 perPage = <int:Signed32>pageSize;

    // Step 1: Page through every bill and total the outstanding balance per supplier.
    map<decimal> outstandingBySupplier = {};
    int:Signed32 page = 1;
    while true {
        one:Bills bills = check reckon->listBills(bookId, queries = {page, perPage});
        one:Bill[] pageItems = bills?.list ?: [];
        foreach one:Bill bill in pageItems {
            string supplierName = bill?.supplier?.name ?: "Unknown supplier";
            decimal balance = bill?.balance ?: 0d;
            outstandingBySupplier[supplierName] = (outstandingBySupplier[supplierName] ?: 0d) + balance;
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
        one:Suppliers suppliers = check reckon->listSuppliers(bookId, queries = {page, perPage});
        one:Supplier[] pageItems = suppliers?.list ?: [];
        supplierCount += pageItems.length();
        if pageItems.length() < perPage {
            break;
        }
        page = <int:Signed32>(page + 1);
    }

    io:println("Suppliers in book: ", supplierCount);
    foreach [string, decimal] [name, total] in outstandingBySupplier.entries() {
        io:println(name, ": ", total);
    }
}
