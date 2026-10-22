// Copyright (c) 2026, WSO2 LLC. (http://www.wso2.com).
//
// WSO2 LLC. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied.  See the License for the
// specific language governing permissions and limitations
// under the License.

import ballerina/http;
import ballerina/os;
import ballerina/test;

final boolean isLiveServer = os:getEnv("IS_LIVE_SERVER") == "true";
final string serviceUrl = isLiveServer ? "https://api-v2.reckonone.com" : "http://localhost:9090";
final string token = isLiveServer ? os:getEnv("RECKON_ONE_ACCESS_TOKEN") : "test_token";
final string subscriptionKey = isLiveServer ? os:getEnv("RECKON_ONE_SUBSCRIPTION_KEY") : "test_subscription_key";
final map<string> & readonly keyHeader = {"Ocp-Apim-Subscription-Key": subscriptionKey};
final string bookId = isLiveServer ? os:getEnv("RECKON_ONE_BOOK_ID") : "5af6572c-9771-4b86-995d-3374d3bc683c";

final Client reckon = check new ({auth: {token}, httpVersion: http:HTTP_1_1}, serviceUrl);

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListBooks() returns error? {
    Books response = check reckon->listBooks(headers = keyHeader);
    Book[]? books = response?.list;
    test:assertTrue(books is Book[]);
    test:assertTrue((<Book[]>books).length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetBook() returns error? {
    Book response = check reckon->getBook(bookId, headers = keyHeader);
    test:assertTrue(response?.id is string);
}

@test:Config {groups: ["mock_tests"]}
isolated function testGetBookNotFound() {
    Book|error response = reckon->getBook("missing", headers = keyHeader);
    test:assertTrue(response is error);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListCustomers() returns error? {
    Customers response = check reckon->listCustomers(bookId, headers = keyHeader);
    test:assertTrue(response?.list is Customer[]);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testCreateCustomer() returns error? {
    if isLiveServer {
        return;
    }
    IdNameResponse response = check reckon->createCustomer(bookId, {name: "Harbour Bridge Traders"}, headers = keyHeader);
    test:assertTrue(response?.id is string);
    test:assertEquals(response?.name, "Harbour Bridge Traders");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetCustomer() returns error? {
    string customerId = "b581a643-10dd-4d09-9a63-356654339795";
    if isLiveServer {
        Customers listed = check reckon->listCustomers(bookId, headers = keyHeader);
        Customer[] customers = listed?.list ?: [];
        if customers.length() == 0 {
            return;
        }
        customerId = customers[0]?.id ?: "";
    }
    Customer response = check reckon->getCustomer(bookId, customerId, headers = keyHeader);
    test:assertTrue(response?.id is string);
}

@test:Config {groups: ["mock_tests"]}
isolated function testGetCustomerNotFound() {
    Customer|error response = reckon->getCustomer(bookId, "missing", headers = keyHeader);
    test:assertTrue(response is error);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testUpdateCustomer() returns error? {
    if isLiveServer {
        return;
    }
    check reckon->updateCustomer(bookId, "b581a643-10dd-4d09-9a63-356654339795", {name: "Harbour Bridge Traders"}, headers = keyHeader);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testDeleteCustomer() returns error? {
    if isLiveServer {
        return;
    }
    IdNameResponse created = check reckon->createCustomer(bookId, {name: "Temporary Customer"}, headers = keyHeader);
    check reckon->deleteCustomer(bookId, <string>created?.id, headers = keyHeader);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListSuppliers() returns error? {
    Suppliers response = check reckon->listSuppliers(bookId, headers = keyHeader);
    test:assertTrue(response?.list is Supplier[]);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testCreateSupplier() returns error? {
    if isLiveServer {
        return;
    }
    IdNameResponse response = check reckon->createSupplier(bookId, {name: "Southern Cross Supplies", isTpar: false}, headers = keyHeader);
    test:assertTrue(response?.id is string);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetSupplier() returns error? {
    string supplierId = "e6abf51e-2052-43c7-be02-4146cbfe9d00";
    if isLiveServer {
        Suppliers listed = check reckon->listSuppliers(bookId, headers = keyHeader);
        Supplier[] suppliers = listed?.list ?: [];
        if suppliers.length() == 0 {
            return;
        }
        supplierId = suppliers[0]?.id ?: "";
    }
    Supplier response = check reckon->getSupplier(bookId, supplierId, headers = keyHeader);
    test:assertTrue(response?.id is string);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListInvoices() returns error? {
    Invoices response = check reckon->listInvoices(bookId, headers = keyHeader);
    test:assertTrue(response?.list is Invoice[]);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testCreateInvoice() returns error? {
    if isLiveServer {
        return;
    }
    IdResponse response = check reckon->createInvoice(bookId, {
        amountTaxStatus: "Exclusive",
        invoiceDate: "2026-04-01",
        customer: "Harbour Bridge Traders",
        lineItems: []
    }, headers = keyHeader);
    test:assertTrue(response?.id is string);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetInvoice() returns error? {
    string invoiceId = "907f8858-91c5-4d4e-8a3c-0d7b4c1f2a11";
    if isLiveServer {
        Invoices listed = check reckon->listInvoices(bookId, headers = keyHeader);
        Invoice[] invoices = listed?.list ?: [];
        if invoices.length() == 0 {
            return;
        }
        invoiceId = invoices[0]?.id ?: "";
    }
    Invoice response = check reckon->getInvoice(bookId, invoiceId, headers = keyHeader);
    test:assertTrue(response?.invoiceNumber is string);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testUpdateInvoice() returns error? {
    if isLiveServer {
        return;
    }
    check reckon->updateInvoice(bookId, "907f8858-91c5-4d4e-8a3c-0d7b4c1f2a11", {
        amountTaxStatus: "Exclusive",
        invoiceDate: "2026-04-01",
        customer: "Harbour Bridge Traders",
        template: "Default invoice template",
        lineItems: []
    }, headers = keyHeader);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testDeleteInvoice() returns error? {
    if isLiveServer {
        return;
    }
    IdResponse created = check reckon->createInvoice(bookId, {
        amountTaxStatus: "Exclusive",
        invoiceDate: "2026-04-02",
        customer: "Harbour Bridge Traders",
        lineItems: []
    }, headers = keyHeader);
    check reckon->deleteInvoice(bookId, <string>created?.id, headers = keyHeader);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListBills() returns error? {
    Bills response = check reckon->listBills(bookId, headers = keyHeader);
    test:assertTrue(response?.list is Bill[]);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testCreateBill() returns error? {
    if isLiveServer {
        return;
    }
    IdResponse response = check reckon->createBill(bookId, {
        amountTaxStatus: "Inclusive",
        billDate: "2026-03-05",
        supplier: "Southern Cross Supplies",
        lineItems: []
    }, headers = keyHeader);
    test:assertTrue(response?.id is string);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetBill() returns error? {
    string billId = "3c1d2f5a-6b7e-4f80-9a1b-2c3d4e5f6a7b";
    if isLiveServer {
        Bills listed = check reckon->listBills(bookId, headers = keyHeader);
        Bill[] bills = listed?.list ?: [];
        if bills.length() == 0 {
            return;
        }
        billId = bills[0]?.id ?: "";
    }
    Bill response = check reckon->getBill(bookId, billId, headers = keyHeader);
    test:assertTrue(response?.billNumber is string);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListContacts() returns error? {
    Contacts response = check reckon->listContacts(bookId, headers = keyHeader);
    test:assertTrue(response?.list is Contact[]);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetContact() returns error? {
    string contactId = "1a2b3c4d-5e6f-4a7b-8c9d-0e1f2a3b4c5d";
    if isLiveServer {
        Contacts listed = check reckon->listContacts(bookId, headers = keyHeader);
        Contact[] contacts = listed?.list ?: [];
        if contacts.length() == 0 {
            return;
        }
        contactId = contacts[0]?.id ?: "";
    }
    Contact response = check reckon->getContact(bookId, contactId, headers = keyHeader);
    test:assertTrue(response?.name is string);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListLedgerAccounts() returns error? {
    LedgerAccounts response = check reckon->listLedgerAccounts(bookId, headers = keyHeader);
    test:assertTrue(response?.list is LedgerAccount[]);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testCreateLedgerAccount() returns error? {
    if isLiveServer {
        return;
    }
    IdResponse response = check reckon->createLedgerAccount(bookId, {accountType: "Income", name: "Sales"}, headers = keyHeader);
    test:assertTrue(response?.id is string);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetLedgerAccount() returns error? {
    string accountId = "7d6c5b4a-3f2e-4d1c-b0a9-8f7e6d5c4b3a";
    if isLiveServer {
        LedgerAccounts listed = check reckon->listLedgerAccounts(bookId, headers = keyHeader);
        LedgerAccount[] accounts = listed?.list ?: [];
        if accounts.length() == 0 {
            return;
        }
        accountId = accounts[0]?.id ?: "";
    }
    LedgerAccount response = check reckon->getLedgerAccount(bookId, accountId, headers = keyHeader);
    test:assertTrue(response?.name is string);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListPayments() returns error? {
    Payments response = check reckon->listPayments(bookId, headers = keyHeader);
    test:assertTrue(response?.list is Payment[]);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListItems() returns error? {
    Items response = check reckon->listItems(bookId, headers = keyHeader);
    test:assertTrue(response?.list is Item[]);
}
