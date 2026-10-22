import ballerina/io;
import ballerinax/reckon.one;

configurable string accessToken = ?;
configurable string subscriptionKey = ?;
configurable string bookId = ?;
configurable string customerName = ?;
configurable string incomeLedgerAccount = ?;
configurable string invoiceDate = ?;
configurable string invoiceDescription = "Consulting services";
configurable decimal invoiceAmount = ?;

// Reckon One requires the subscription key on every call.
final map<string> keyHeader = {"Ocp-Apim-Subscription-Key": subscriptionKey};

public function main() returns error? {
    one:Client reckon = check new ({auth: {token: accessToken}});

    // Step 1: Create the customer the invoice will be raised for.
    one:IdNameResponse customer = check reckon->createCustomer(bookId, {name: customerName}, headers = keyHeader);
    string customerId = customer?.id ?: "";
    if customerId == "" {
        return error("Reckon One did not return an id for the new customer");
    }
    io:println("Created customer ", customer?.name, " with id ", customerId);

    // Step 2: Create an invoice for the customer with a single line item.
    one:IdResponse invoice = check reckon->createInvoice(bookId, {
        customer: customerId,
        invoiceDate,
        amountTaxStatus: "Exclusive",
        lineItems: [
            {
                lineNumber: 1,
                description: invoiceDescription,
                accountDetails: {ledgerAccount: incomeLedgerAccount, amount: invoiceAmount, quantity: 1}
            }
        ]
    }, headers = keyHeader);
    string invoiceId = invoice?.id ?: "";
    if invoiceId == "" {
        return error("Reckon One did not return an id for the new invoice");
    }

    // Step 3: Read the invoice back to confirm what was stored.
    one:Invoice created = check reckon->getInvoice(bookId, invoiceId, headers = keyHeader);
    io:println("Invoice ", created?.invoiceNumber, " total: ", created?.totalAmount, ", balance: ", created?.balance);
}
