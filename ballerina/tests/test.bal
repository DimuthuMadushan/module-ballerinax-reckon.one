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
final string bookId = isLiveServer ? os:getEnv("RECKON_ONE_BOOK_ID") : "5af6572c-9771-4b86-995d-3374d3bc683c";

final Client reckon = check new ({auth: {token}, httpVersion: http:HTTP_1_1}, serviceUrl);

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListBooks() returns error? {
    Books response = check reckon->listBooks();
    Book[]? books = response?.list;
    test:assertTrue(books is Book[]);
    test:assertTrue((<Book[]>books).length() > 0);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetBook() returns error? {
    Book response = check reckon->getBook(bookId);
    test:assertTrue(response?.id is string);
}

@test:Config {groups: ["mock_tests"]}
isolated function testGetBookNotFound() {
    Book|error response = reckon->getBook("missing");
    test:assertTrue(response is error);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListCustomers() returns error? {
    Customers response = check reckon->listCustomers(bookId);
    test:assertTrue(response?.list is Customer[]);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testCreateCustomer() returns error? {
    if isLiveServer {
        return;
    }
    IdNameResponse response = check reckon->createCustomer(bookId, {name: "Harbour Bridge Traders"});
    test:assertTrue(response?.id is string);
    test:assertEquals(response?.name, "Harbour Bridge Traders");
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetCustomer() returns error? {
    Customer response = check reckon->getCustomer(bookId, "b581a643-10dd-4d09-9a63-356654339795");
    test:assertTrue(response?.id is string);
}

@test:Config {groups: ["mock_tests"]}
isolated function testGetCustomerNotFound() {
    Customer|error response = reckon->getCustomer(bookId, "missing");
    test:assertTrue(response is error);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testUpdateCustomer() returns error? {
    if isLiveServer {
        return;
    }
    check reckon->updateCustomer(bookId, "b581a643-10dd-4d09-9a63-356654339795", {name: "Harbour Bridge Traders"});
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testDeleteCustomer() returns error? {
    if isLiveServer {
        return;
    }
    IdNameResponse created = check reckon->createCustomer(bookId, {name: "Temporary Customer"});
    check reckon->deleteCustomer(bookId, <string>created?.id);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListSuppliers() returns error? {
    Suppliers response = check reckon->listSuppliers(bookId);
    test:assertTrue(response?.list is Supplier[]);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testCreateSupplier() returns error? {
    if isLiveServer {
        return;
    }
    IdNameResponse response = check reckon->createSupplier(bookId, {name: "Southern Cross Supplies", isTpar: false});
    test:assertTrue(response?.id is string);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetSupplier() returns error? {
    Supplier response = check reckon->getSupplier(bookId, "e6abf51e-2052-43c7-be02-4146cbfe9d00");
    test:assertTrue(response?.id is string);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListInvoices() returns error? {
    Invoices response = check reckon->listInvoices(bookId);
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
    });
    test:assertTrue(response?.id is string);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetInvoice() returns error? {
    Invoice response = check reckon->getInvoice(bookId, "907f8858-91c5-4d4e-8a3c-0d7b4c1f2a11");
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
    });
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
    });
    check reckon->deleteInvoice(bookId, <string>created?.id);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListBills() returns error? {
    Bills response = check reckon->listBills(bookId);
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
    });
    test:assertTrue(response?.id is string);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetBill() returns error? {
    Bill response = check reckon->getBill(bookId, "3c1d2f5a-6b7e-4f80-9a1b-2c3d4e5f6a7b");
    test:assertTrue(response?.billNumber is string);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListContacts() returns error? {
    Contacts response = check reckon->listContacts(bookId);
    test:assertTrue(response?.list is Contact[]);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetContact() returns error? {
    Contact response = check reckon->getContact(bookId, "1a2b3c4d-5e6f-4a7b-8c9d-0e1f2a3b4c5d");
    test:assertTrue(response?.name is string);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListLedgerAccounts() returns error? {
    LedgerAccounts response = check reckon->listLedgerAccounts(bookId);
    test:assertTrue(response?.list is LedgerAccount[]);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testCreateLedgerAccount() returns error? {
    if isLiveServer {
        return;
    }
    IdResponse response = check reckon->createLedgerAccount(bookId, {accountType: "Income", name: "Sales"});
    test:assertTrue(response?.id is string);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testGetLedgerAccount() returns error? {
    LedgerAccount response = check reckon->getLedgerAccount(bookId, "7d6c5b4a-3f2e-4d1c-b0a9-8f7e6d5c4b3a");
    test:assertTrue(response?.name is string);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListPayments() returns error? {
    Payments response = check reckon->listPayments(bookId);
    test:assertTrue(response?.list is Payment[]);
}

@test:Config {groups: ["live_tests", "mock_tests"]}
isolated function testListItems() returns error? {
    Items response = check reckon->listItems(bookId);
    test:assertTrue(response?.list is Item[]);
}
