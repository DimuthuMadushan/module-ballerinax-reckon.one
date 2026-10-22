## Overview

[Reckon One](https://www.reckon.com/au/products/reckon-one/) is a cloud accounting platform for small businesses and their accountants. The Reckon One connector gives Ballerina programs access to version 2 of the Reckon One API, so you can read and manage the accounting data held in a Reckon One book from your integrations.

### Key features

- Manage customers, suppliers and contacts, including their addresses and phone numbers
- Create, update and retrieve sales invoices, bills, payments and other transactions
- Work with ledger accounts, items, tax rates and other chart-of-accounts reference data
- Run payroll, superannuation and financial reports
- Read and update book-level settings and templates

## Setup guide

To use the Reckon One connector you need an access token for a Reckon One book.

1. Sign in to your Reckon One account, or create one if you do not have one.

2. Register an application with Reckon so that you receive a client ID and client secret for the Reckon One API.

3. Authorize your application with the OAuth 2.0 authorization code flow against the Reckon identity server (`https://identity.reckon.com/connect/authorize`), requesting the `read`, `write` and `offline_access` scopes. The `offline_access` scope is what makes Reckon issue a refresh token.

4. Exchange the authorization code for an access token, and a refresh token, at `https://identity.reckon.com/connect/token`.

5. Get your subscription key. Sign in to the Reckon Developer Portal, open your user profile and copy the **Primary key**. Reckon One API v2 requires this key on every call. Send it in the `Ocp-Apim-Subscription-Key` header on every call, by passing it in the `headers` argument of each connector operation.

6. Note the ID of the book you want to work with. You can list the books available to your user with the connector's `listBooks` operation.

## Quickstart

To use the Reckon One connector in your Ballerina application, update the `.bal` file as follows:

### Step 1: Import the module

```ballerina
import ballerinax/reckon.one;
```

### Step 2: Create a new connector instance

Add the access token and the subscription key to a `Config.toml` file:

```toml
accessToken = "<your-access-token>"
subscriptionKey = "<your-subscription-key>"
```

Then create the client in your `.bal` file:

```ballerina
configurable string accessToken = ?;
configurable string subscriptionKey = ?;

final one:Client reckon = check new ({auth: {token: accessToken}});
```

### Step 3: Invoke the connector operation

```ballerina
public function main() returns error? {
    one:Books _ = check reckon->listBooks(headers = {"Ocp-Apim-Subscription-Key": subscriptionKey});
}
```

### Step 4: Run the Ballerina application

```bash
bal run
```

## Examples

The `Reckon One` connector provides practical examples illustrating usage in various scenarios. Explore these [examples](https://github.com/ballerina-platform/module-ballerinax-reckon.one/tree/main/examples/), covering the following use cases:

1. [Customer invoice creation](../examples/customer_invoice_creation/customer_invoice_creation.md) - Create a customer, raise an invoice for it and read the invoice back.
2. [Supplier bill summary](../examples/supplier_bill_summary/supplier_bill_summary.md) - Page through all bills and suppliers in a book and total the outstanding balance per supplier.
