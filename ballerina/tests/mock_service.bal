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

listener http:Listener ep0 = new (9090);

const string MOCK_BOOK_ID = "5af6572c-9771-4b86-995d-3374d3bc683c";
const string MOCK_CUSTOMER_ID = "b581a643-10dd-4d09-9a63-356654339795";
const string MOCK_SUPPLIER_ID = "e6abf51e-2052-43c7-be02-4146cbfe9d00";
const string MOCK_INVOICE_ID = "907f8858-91c5-4d4e-8a3c-0d7b4c1f2a11";
const string MOCK_BILL_ID = "3c1d2f5a-6b7e-4f80-9a1b-2c3d4e5f6a7b";
const string MOCK_CONTACT_ID = "1a2b3c4d-5e6f-4a7b-8c9d-0e1f2a3b4c5d";
const string MOCK_ACCOUNT_ID = "7d6c5b4a-3f2e-4d1c-b0a9-8f7e6d5c4b3a";
const string MOCK_PAYMENT_ID = "9e8d7c6b-5a49-4382-a1b0-c9d8e7f60514";
const string MOCK_ITEM_ID = "2f3e4d5c-6b7a-4988-b7a6-5f4e3d2c1b0a";

// Service-mode response types. `bal openapi --mode client` collapses 4XX/5XX
// to `error` and never emits these, so they are defined here for the mock only.
public type ErrorResponse record {|
    string message?;
|};

public type ErrorResponseBadRequest record {|
    *http:BadRequest;
    ErrorResponse body;
|};

public type ErrorResponseNotFoundNotFound record {|
    *http:NotFound;
    ErrorResponse body;
|};

public type ErrorResponseForbiddenForbidden record {|
    *http:Forbidden;
    ErrorResponse body;
|};

public type ErrorResponseUnauthorizedUnauthorized record {|
    *http:Unauthorized;
    ErrorResponse body;
|};

function notFound(string message) returns ErrorResponseNotFoundNotFound {
    return {body: {message}};
}

function mockCustomer() returns Customer {
    return {
        id: MOCK_CUSTOMER_ID,
        name: "Harbour Bridge Traders",
        organisationName: "Harbour Bridge Traders Pty Ltd",
        businessNumber: "51824753556",
        notes: "Preferred customer",
        balance: 1250.50,
        creditLimit: 5000,
        invoiceCount: 12,
        status: "Active",
        lastModifiedDateTime: "2026-03-14T09:30:00Z",
        contacts: [{id: MOCK_CONTACT_ID, name: "Olivia Bennett"}]
    };
}

function mockSupplier() returns Supplier {
    return {
        id: MOCK_SUPPLIER_ID,
        name: "Southern Cross Supplies",
        organisationName: "Southern Cross Supplies Pty Ltd",
        businessNumber: "33102417032",
        balance: 830.00,
        overdueBillCount: 1,
        isCustomer: false,
        status: "Active",
        lastModifiedDateTime: "2026-02-20T14:05:00Z"
    };
}

function mockInvoice() returns Invoice {
    return {
        id: MOCK_INVOICE_ID,
        invoiceNumber: "INV-0001",
        invoiceDate: "2026-04-01",
        dueDate: "2026-04-30",
        reference: "PO-4471",
        amountTaxStatus: "Exclusive",
        totalAmount: 1100.00,
        balance: 1100.00,
        includeInInvoiceReminders: true,
        emailStatus: "Unsent",
        createdDateTime: "2026-04-01T08:00:00Z",
        lastModifiedDateTime: "2026-04-01T08:00:00Z"
    };
}

function mockBill() returns Bill {
    return {
        id: MOCK_BILL_ID,
        billNumber: "BILL-0007",
        billDate: "2026-03-05",
        dueDate: "2026-04-04",
        reference: "SUP-2210",
        amountTaxStatus: "Inclusive",
        totalAmount: 440.00,
        totalTaxAmount: 40.00,
        balance: 440.00,
        status: "Approved",
        supplier: {id: MOCK_SUPPLIER_ID, name: "Southern Cross Supplies"},
        emailStatus: "Unsent",
        createdDateTime: "2026-03-05T10:15:00Z",
        lastModifiedDateTime: "2026-03-05T10:15:00Z"
    };
}

function mockContact() returns Contact {
    return {
        id: MOCK_CONTACT_ID,
        name: "Olivia Bennett",
        position: "Accounts Manager",
        department: "Finance",
        salutation: "Ms",
        status: "Active",
        createdDateTime: "2026-01-10T11:00:00Z",
        lastModifiedDateTime: "2026-01-10T11:00:00Z"
    };
}

function mockLedgerAccount() returns LedgerAccount {
    return {
        id: MOCK_ACCOUNT_ID,
        name: "Sales",
        fullName: "Income:Sales",
        accountCode: "4-1000",
        accountType: "Income",
        cashflowClassification: "Operating",
        description: "Revenue from product sales",
        balance: 15200.75,
        isDebit: false,
        systemAccount: false,
        sortOrder: 1,
        status: "Active",
        lastModifiedDateTime: "2026-01-02T00:00:00Z"
    };
}

function mockPayment() returns Payment {
    return {
        id: MOCK_PAYMENT_ID,
        paymentNumber: "PAY-0003",
        paymentDate: "2026-04-10",
        reference: "EFT 88421",
        totalAmount: 440.00,
        reconciliationStatus: "Uncleared",
        supplier: {id: MOCK_SUPPLIER_ID, name: "Southern Cross Supplies"},
        allocateFullAmount: true,
        createdDateTime: "2026-04-10T13:20:00Z",
        lastModifiedDateTime: "2026-04-10T13:20:00Z"
    };
}

function mockItem() returns Item {
    return {
        id: MOCK_ITEM_ID,
        name: "Standard Widget",
        fullName: "Widgets:Standard Widget",
        itemCode: "WID-001",
        itemType: "Product",
        amountTaxStatus: "Exclusive",
        status: "Active",
        createdDateTime: "2026-01-15T09:00:00Z",
        lastModifiedDateTime: "2026-01-15T09:00:00Z"
    };
}

service / on ep0 {
    # Deletes an existing customer.
    #
    # + bookId - The book's id
    # + customerId - The customer's id
    # + return - returns can be any of following types
    # http:NoContent (The result of the deletion)
    # http:BadRequest (The customer could not be deleted.)
    # http:NotFound (The specified book or customer does not exist.)
    # http:Forbidden (The user does not have permission to delete customers.)
    # http:Unauthorized (The authentication token is missing, expired or invalid.)
    resource function delete [string bookId]/customers/[string customerId]() returns http:NoContent|ErrorResponseBadRequest|ErrorResponseNotFoundNotFound|ErrorResponseForbiddenForbidden|ErrorResponseUnauthorizedUnauthorized {
        if customerId == "missing" {
            return notFound("The specified customer does not exist.");
        }
        return http:NO_CONTENT;
    }

    # Deletes an existing invoice.
    #
    # + bookId - The book's id
    # + invoiceId - The invoice's id
    # + return - returns can be any of following types
    # http:NoContent (The result of the deletion)
    # http:BadRequest (The invoice could not be deleted.)
    # http:NotFound (The specified book or invoice does not exist.)
    # http:Forbidden (The user does not have permission to delete invoices.)
    # http:Unauthorized (The authentication token is missing, expired or invalid.)
    resource function delete [string bookId]/invoices/[string invoiceId]() returns http:NoContent|ErrorResponseBadRequest|ErrorResponseNotFoundNotFound|ErrorResponseForbiddenForbidden|ErrorResponseUnauthorizedUnauthorized {
        if invoiceId == "missing" {
            return notFound("The specified invoice does not exist.");
        }
        return http:NO_CONTENT;
    }

    # Gets a list of bills.
    #
    # + bookId - The book's id
    # + page - The page to retrieve
    # + perPage - The number of bills per page
    # + return - returns can be any of following types
    # http:Ok (A paged list of bills for the specified book)
    # http:NotFound (The specified book does not exist.)
    # http:Forbidden (The user does not have permission to retrieve the bills.)
    # http:Unauthorized (The authentication token is missing, expired or invalid.)
    resource function get [string bookId]/bills(int:Signed32 page = 1, int:Signed32? perPage = 0) returns Bills|ErrorResponseNotFoundNotFound|ErrorResponseForbiddenForbidden|ErrorResponseUnauthorizedUnauthorized {
        return {list: [mockBill()]};
    }

    # Gets a bill.
    #
    # + bookId - The book's id
    # + billId - The bill's id
    # + format - The format to use, e.g. pdf
    # + return - returns can be any of following types
    # http:Ok (The requested bill)
    # http:NotFound (The specified book or bill does not exist.)
    # http:Forbidden (The user does not have permission to retrieve the bill.)
    # http:Unauthorized (The authentication token is missing, expired or invalid.)
    resource function get [string bookId]/bills/[string billId](string? format) returns Bill|ErrorResponseNotFoundNotFound|ErrorResponseForbiddenForbidden|ErrorResponseUnauthorizedUnauthorized {
        return mockBill();
    }

    # Gets a list of contacts.
    #
    # + bookId - The book's id
    # + page - The page to retrieve
    # + perPage - The number of contacts per page
    # + return - returns can be any of following types
    # http:Ok (A paged list of contacts for the specified book)
    # http:NotFound (The specified book does not exist.)
    # http:Forbidden (The user does not have permission to retrieve the contacts.)
    # http:Unauthorized (The authentication token is missing, expired or invalid.)
    resource function get [string bookId]/contacts(int:Signed32 page = 1, int:Signed32? perPage = 0) returns Contacts|ErrorResponseNotFoundNotFound|ErrorResponseForbiddenForbidden|ErrorResponseUnauthorizedUnauthorized {
        return {list: [mockContact()]};
    }

    # Gets a contact.
    #
    # + bookId - The book's id
    # + contactId - The contact's id
    # + return - returns can be any of following types
    # http:Ok (The requested contact)
    # http:NotFound (The specified book or contact does not exist.)
    # http:Forbidden (The user does not have permission to retrieve the contact.)
    # http:Unauthorized (The authentication token is missing, expired or invalid.)
    resource function get [string bookId]/contacts/[string contactId]() returns Contact|ErrorResponseNotFoundNotFound|ErrorResponseForbiddenForbidden|ErrorResponseUnauthorizedUnauthorized {
        return mockContact();
    }

    # Gets a list of customers.
    #
    # + bookId - The book's id
    # + page - The page to retrieve
    # + perPage - The number of customers per page
    # + externalClientId - The external client application's id
    # + externalTenancyId - The external book/file/tenancy/etc's id
    # + return - returns can be any of following types
    # http:Ok (A paged list of customers for the specified book)
    # http:NotFound (The specified book does not exist.)
    # http:Forbidden (The user does not have permission to retrieve the customers.)
    # http:Unauthorized (The authentication token is missing, expired or invalid.)
    resource function get [string bookId]/customers(@http:Query {name: "ExternalClientId"} string? externalClientId, @http:Query {name: "ExternalTenancyId"} string? externalTenancyId, int:Signed32 page = 1, int:Signed32? perPage = 0) returns Customers|ErrorResponseNotFoundNotFound|ErrorResponseForbiddenForbidden|ErrorResponseUnauthorizedUnauthorized {
        return {list: [mockCustomer()]};
    }

    # Gets a customer.
    #
    # + bookId - The book's id
    # + customerId - The customer's id
    # + return - returns can be any of following types
    # http:Ok (The requested customer)
    # http:NotFound (The specified book or customer does not exist.)
    # http:Forbidden (The user does not have permission to retrieve the customer.)
    # http:Unauthorized (The authentication token is missing, expired or invalid.)
    resource function get [string bookId]/customers/[string customerId]() returns Customer|ErrorResponseNotFoundNotFound|ErrorResponseForbiddenForbidden|ErrorResponseUnauthorizedUnauthorized {
        if customerId == "missing" {
            return notFound("The specified customer does not exist.");
        }
        return mockCustomer();
    }

    # Gets a list of invoices.
    #
    # + bookId - The book's id
    # + page - The page to retrieve
    # + perPage - The number of invoices per page
    # + return - returns can be any of following types
    # http:Ok (A paged list of invoices for the specified book)
    # http:NotFound (The specified book does not exist.)
    # http:Forbidden (The user does not have permission to retrieve the invoices.)
    # http:Unauthorized (The authentication token is missing, expired or invalid.)
    resource function get [string bookId]/invoices(int:Signed32 page = 1, int:Signed32? perPage = 0) returns Invoices|ErrorResponseNotFoundNotFound|ErrorResponseForbiddenForbidden|ErrorResponseUnauthorizedUnauthorized {
        return {list: [mockInvoice()]};
    }

    # Gets an invoice.
    #
    # + bookId - The book's id
    # + invoiceId - The invoice's id
    # + format - The format to use, e.g. pdf
    # + return - returns can be any of following types
    # http:Ok (The requested invoice)
    # http:NotFound (The specified book or invoice does not exist.)
    # http:Forbidden (The user does not have permission to retrieve the invoice.)
    # http:Unauthorized (The authentication token is missing, expired or invalid.)
    resource function get [string bookId]/invoices/[string invoiceId](string? format) returns Invoice|ErrorResponseNotFoundNotFound|ErrorResponseForbiddenForbidden|ErrorResponseUnauthorizedUnauthorized {
        if invoiceId == "missing" {
            return notFound("The specified invoice does not exist.");
        }
        return mockInvoice();
    }

    # Gets a list of items.
    #
    # + bookId - The book's id
    # + baseDate - The date to use when calculating the net or gross price
    # + page - The page to retrieve
    # + perPage - The number of items per page
    # + externalClientId - The external client application's id
    # + externalTenancyId - The external book/file/tenancy/etc's id
    # + return - returns can be any of following types
    # http:Ok (A paged list of items for the specified book)
    # http:NotFound (The specified book does not exist.)
    # http:Forbidden (The user does not have permission to retrieve the items.)
    # http:Unauthorized (The authentication token is missing, expired or invalid.)
    resource function get [string bookId]/items(string? baseDate, @http:Query {name: "ExternalClientId"} string? externalClientId, @http:Query {name: "ExternalTenancyId"} string? externalTenancyId, int:Signed32 page = 1, int:Signed32? perPage = 0) returns Items|ErrorResponseNotFoundNotFound|ErrorResponseForbiddenForbidden|ErrorResponseUnauthorizedUnauthorized {
        return {list: [mockItem()]};
    }

    # Gets a list of ledger accounts.
    #
    # + bookId - The book's id
    # + page - The page to retrieve
    # + perPage - The number of accounts per page
    # + externalClientId - The external client application's id
    # + externalTenancyId - The external book/file/tenancy/etc's id
    # + return - returns can be any of following types
    # http:Ok (A paged list of ledger accounts for the specified book)
    # http:NotFound (The specified book does not exist.)
    # http:Forbidden (The user does not have permission to retrieve the ledger accounts.)
    # http:Unauthorized (The authentication token is missing, expired or invalid.)
    resource function get [string bookId]/ledgeraccounts(@http:Query {name: "ExternalClientId"} string? externalClientId, @http:Query {name: "ExternalTenancyId"} string? externalTenancyId, int:Signed32 page = 1, int:Signed32? perPage = 0) returns LedgerAccounts|ErrorResponseNotFoundNotFound|ErrorResponseForbiddenForbidden|ErrorResponseUnauthorizedUnauthorized {
        return {list: [mockLedgerAccount()]};
    }

    # Gets a ledger account.
    #
    # + bookId - The book's id
    # + accountId - The ledger account's id
    # + return - returns can be any of following types
    # http:Ok (The requested ledger account)
    # http:NotFound (The specified book or ledger account does not exist.)
    # http:Forbidden (The user does not have permission to retrieve the ledger account.)
    # http:Unauthorized (The authentication token is missing, expired or invalid.)
    resource function get [string bookId]/ledgeraccounts/[string accountId]() returns LedgerAccount|ErrorResponseNotFoundNotFound|ErrorResponseForbiddenForbidden|ErrorResponseUnauthorizedUnauthorized {
        return mockLedgerAccount();
    }

    # Get a list of payments.
    #
    # + bookId - The book's id
    # + page - The page to retrieve
    # + perPage - The number of payments per page
    # + return - returns can be any of following types
    # http:Ok (A paged list of payments for the specified book)
    # http:NotFound (The specified book does not exist.)
    # http:Forbidden (The user does not have permission to retrieve the payments.)
    # http:Unauthorized (The authentication token is missing, expired or invalid.)
    resource function get [string bookId]/payments(int:Signed32 page = 1, int:Signed32? perPage = 0) returns Payments|ErrorResponseNotFoundNotFound|ErrorResponseForbiddenForbidden|ErrorResponseUnauthorizedUnauthorized {
        return {list: [mockPayment()]};
    }

    # Gets a list of suppliers.
    #
    # + bookId - The book's id
    # + page - The page to retrieve
    # + perPage - The number of suppliers per page
    # + externalClientId - The external client application's id
    # + externalTenancyId - The external book/file/tenancy/etc's id
    # + return - returns can be any of following types
    # http:Ok (A paged list of suppliers for the specified book)
    # http:NotFound (The specified book does not exist.)
    # http:Forbidden (The user does not have permission to retrieve the suppliers.)
    # http:Unauthorized (The authentication token is missing, expired or invalid.)
    resource function get [string bookId]/suppliers(@http:Query {name: "ExternalClientId"} string? externalClientId, @http:Query {name: "ExternalTenancyId"} string? externalTenancyId, int:Signed32 page = 1, int:Signed32? perPage = 0) returns Suppliers|ErrorResponseNotFoundNotFound|ErrorResponseForbiddenForbidden|ErrorResponseUnauthorizedUnauthorized {
        return {list: [mockSupplier()]};
    }

    # Gets a supplier.
    #
    # + bookId - The book's id
    # + supplierId - The supplier's id
    # + return - returns can be any of following types
    # http:Ok (The requested supplier)
    # http:NotFound (The specified book or supplier does not exist.)
    # http:Forbidden (The user does not have permission to retrieve the supplier.)
    # http:Unauthorized (The authentication token is missing, expired or invalid.)
    resource function get [string bookId]/suppliers/[string supplierId]() returns Supplier|ErrorResponseNotFoundNotFound|ErrorResponseForbiddenForbidden|ErrorResponseUnauthorizedUnauthorized {
        return mockSupplier();
    }

    # Gets a list of books that the current user has access to.
    #
    # + return - returns can be any of following types
    # http:Ok (A list of books)
    # http:NotFound (No books were found.)
    # http:Unauthorized (The authentication token is missing, expired or invalid.)
    resource function get books() returns Books|ErrorResponseNotFoundNotFound|ErrorResponseUnauthorizedUnauthorized {
        return {
            list: [
                {
                    id: MOCK_BOOK_ID,
                    name: "Bondi Coffee Roasters",
                    country: "AU",
                    ownership: "Owned",
                    bookCreated: true,
                    hasRoleAssigned: true,
                    isTrial: false,
                    ownedAsPartner: false
                }
            ]
        };
    }

    # Gets details of the specified book.
    #
    # + bookId - The book's id
    # + return - returns can be any of following types
    # http:Ok (Details of the book)
    # http:NotFound (Book was not found.)
    # http:Unauthorized (The authentication token is missing, expired or invalid.)
    resource function get books/[string bookId]() returns Book|ErrorResponseNotFoundNotFound|ErrorResponseUnauthorizedUnauthorized {
        if bookId == "missing" {
            return notFound("Book was not found.");
        }
        return {
            id: bookId,
            name: "Bondi Coffee Roasters",
            country: "AU",
            ownership: "Owned",
            bookCreated: true,
            hasRoleAssigned: true,
            isTrial: false,
            ownedAsPartner: false
        };
    }

    # Creates a new bill.
    #
    # + bookId - The book's id
    # + payload - Details of the new bill
    # + return - returns can be any of following types
    # http:Created (The id of the bill that has been created)
    # http:BadRequest (The bill could not be created as the request contains invalid data.)
    # http:NotFound (The specified book does not exist.)
    # http:Forbidden (The user does not have permission to create bills.)
    # http:Unauthorized (The authentication token is missing, expired or invalid.)
    resource function post [string bookId]/bills(@http:Payload BillInput payload) returns IdResponse|ErrorResponseBadRequest|ErrorResponseNotFoundNotFound|ErrorResponseForbiddenForbidden|ErrorResponseUnauthorizedUnauthorized {
        return {id: MOCK_BILL_ID};
    }

    # Creates a new customer.
    #
    # + bookId - The book's id
    # + externalResourceId - The external resource's id
    # + externalClientId - The external client application's id
    # + externalTenancyId - The external book/file/tenancy/etc's id
    # + payload - Details of the new customer
    # + return - returns can be any of following types
    # http:Created (The id of the customer that has been created)
    # http:BadRequest (The customer could not be created as the request contains invalid data.)
    # http:NotFound (The specified book does not exist.)
    # http:Forbidden (The user does not have permission to create customers.)
    # http:Unauthorized (The authentication token is missing, expired or invalid.)
    resource function post [string bookId]/customers(@http:Query {name: "ExternalResourceId"} string? externalResourceId, @http:Query {name: "ExternalClientId"} string? externalClientId, @http:Query {name: "ExternalTenancyId"} string? externalTenancyId, @http:Payload CustomerInput payload) returns IdNameResponse|ErrorResponseBadRequest|ErrorResponseNotFoundNotFound|ErrorResponseForbiddenForbidden|ErrorResponseUnauthorizedUnauthorized {
        return {id: MOCK_CUSTOMER_ID, name: payload.name};
    }

    # Creates a new invoice.
    #
    # + bookId - The book's id
    # + ignoreWarnings - Ignore warnings
    # + payload - Details of the new invoice
    # + return - returns can be any of following types
    # http:Created (The id of the invoice that has been created)
    # http:BadRequest (The invoice could not be created as the request contains invalid data.)
    # http:NotFound (The specified book does not exist.)
    # http:Forbidden (The user does not have permission to create invoices.)
    # http:Unauthorized (The authentication token is missing, expired or invalid.)
    resource function post [string bookId]/invoices(boolean? ignoreWarnings, @http:Payload InvoiceInput payload) returns IdResponse|ErrorResponseBadRequest|ErrorResponseNotFoundNotFound|ErrorResponseForbiddenForbidden|ErrorResponseUnauthorizedUnauthorized {
        return {id: MOCK_INVOICE_ID};
    }

    # Creates a new ledger account.
    #
    # + bookId - The book's id
    # + externalResourceId - The external resource's id
    # + externalClientId - The external client application's id
    # + externalTenancyId - The external book/file/tenancy/etc's id
    # + payload - The account to create
    # + return - returns can be any of following types
    # http:Created (The id of the account that has been created)
    # http:BadRequest (The ledger account could not be created as the request contains invalid data.)
    # http:NotFound (The specified book does not exist.)
    # http:Forbidden (The user does not have permission to create a new ledger account.)
    # http:Unauthorized (The authentication token is missing, expired or invalid.)
    resource function post [string bookId]/ledgeraccounts(@http:Query {name: "ExternalResourceId"} string? externalResourceId, @http:Query {name: "ExternalClientId"} string? externalClientId, @http:Query {name: "ExternalTenancyId"} string? externalTenancyId, @http:Payload LedgerAccountInput payload) returns IdResponse|ErrorResponseBadRequest|ErrorResponseNotFoundNotFound|ErrorResponseForbiddenForbidden|ErrorResponseUnauthorizedUnauthorized {
        return {id: MOCK_ACCOUNT_ID};
    }

    # Creates a new supplier.
    #
    # + bookId - The book's id
    # + externalResourceId - The external resource's id
    # + externalClientId - The external client application's id
    # + externalTenancyId - The external book/file/tenancy/etc's id
    # + payload - Details of the new supplier
    # + return - returns can be any of following types
    # http:Created (The id of the supplier that has been created)
    # http:BadRequest (The supplier could not be created as the request contains invalid data.)
    # http:NotFound (The specified book does not exist.)
    # http:Forbidden (The user does not have permission to create suppliers.)
    # http:Unauthorized (The authentication token is missing, expired or invalid.)
    resource function post [string bookId]/suppliers(@http:Query {name: "ExternalResourceId"} string? externalResourceId, @http:Query {name: "ExternalClientId"} string? externalClientId, @http:Query {name: "ExternalTenancyId"} string? externalTenancyId, @http:Payload SupplierInput payload) returns IdNameResponse|ErrorResponseBadRequest|ErrorResponseNotFoundNotFound|ErrorResponseForbiddenForbidden|ErrorResponseUnauthorizedUnauthorized {
        return {id: MOCK_SUPPLIER_ID, name: payload.name};
    }

    # Updates an existing customer.
    #
    # + bookId - The book's id
    # + customerId - The customer's id
    # + externalResourceId - The external resource's id
    # + externalClientId - The external client application's id
    # + externalTenancyId - The external book/file/tenancy/etc's id
    # + payload - Details of the updated customer
    # + return - returns can be any of following types
    # http:NoContent (The result of the update)
    # http:BadRequest (The customer could not be updated as the request contains invalid data.)
    # http:NotFound (The specified book or customer does not exist.)
    # http:Forbidden (The user does not have permission to update the customer.)
    # http:Unauthorized (The authentication token is missing, expired or invalid.)
    resource function put [string bookId]/customers/[string customerId](@http:Query {name: "ExternalResourceId"} string? externalResourceId, @http:Query {name: "ExternalClientId"} string? externalClientId, @http:Query {name: "ExternalTenancyId"} string? externalTenancyId, @http:Payload CustomerInput payload) returns http:NoContent|ErrorResponseBadRequest|ErrorResponseNotFoundNotFound|ErrorResponseForbiddenForbidden|ErrorResponseUnauthorizedUnauthorized {
        if customerId == "missing" {
            return notFound("The specified customer does not exist.");
        }
        return http:NO_CONTENT;
    }

    # Updates an existing invoice.
    #
    # + bookId - The book's id
    # + invoiceId - The invoice's id
    # + ignoreWarnings - Ignore warnings
    # + payload - Details of the updated invoice
    # + return - returns can be any of following types
    # http:NoContent (The result of the update)
    # http:BadRequest (The invoice could not be updated as the request contains invalid data.)
    # http:NotFound (The specified book or invoice does not exist.)
    # http:Forbidden (The user does not have permission to edit invoices.)
    # http:Unauthorized (The authentication token is missing, expired or invalid.)
    resource function put [string bookId]/invoices/[string invoiceId](boolean? ignoreWarnings, @http:Payload InvoicePut payload) returns http:NoContent|ErrorResponseBadRequest|ErrorResponseNotFoundNotFound|ErrorResponseForbiddenForbidden|ErrorResponseUnauthorizedUnauthorized {
        if invoiceId == "missing" {
            return notFound("The specified invoice does not exist.");
        }
        return http:NO_CONTENT;
    }
}
