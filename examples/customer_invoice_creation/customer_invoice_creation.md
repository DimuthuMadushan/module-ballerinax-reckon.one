# Customer invoice creation

This example creates a customer in a Reckon One book, raises an invoice for that customer with a single line item, and reads the invoice back to confirm the stored invoice number, total and balance.

## Prerequisites

- Ballerina Swan Lake 2201.12.0 or later
- Create a `Config.toml` in this directory:
  ```toml
  accessToken = "<your-access-token>"
  subscriptionKey = "<your-subscription-key>"
  bookId = "<your-book-id>"
  customerName = "<new-customer-name>"
  incomeLedgerAccount = "<income-ledger-account-id-or-full-name>"
  invoiceDate = "<yyyy-mm-dd>"
  invoiceDescription = "Consulting services"
  invoiceAmount = 100.00
  ```

## Run the example

```bash
bal run
```
