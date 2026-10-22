# Tests

The test suite covers 25 representative operations of the Reckon One API. It lists books, customers, suppliers, invoices, bills, contacts, ledger accounts, payments and items, and reads books, customers, suppliers, invoices, bills, contacts and ledger accounts. It creates customers, suppliers, invoices, bills and ledger accounts, and updates and deletes customers and invoices. Two additional tests check that a missing resource surfaces as an error.

Tests run against a mock server (`tests/mock_service.bal`) by default. Set `IS_LIVE_SERVER=true` to run the read-only tests against the live Reckon One API; the tests that create, update or delete data are skipped on a live server.

## Running Tests

```bash
bal test
```

The test suite uses a mock server (`tests/mock_service.bal`) that intercepts HTTP calls so no real credentials are required.

To run against the live API, set the following environment variables:

| Variable | Description |
|---|---|
| `IS_LIVE_SERVER` | Set to `true` to use the live Reckon One API |
| `RECKON_ONE_ACCESS_TOKEN` | OAuth 2.0 access token for the Reckon One API |
| `RECKON_ONE_SUBSCRIPTION_KEY` | Reckon One API subscription key, sent in the `Ocp-Apim-Subscription-Key` header on every call |
| `RECKON_ONE_BOOK_ID` | ID of the book to run the tests against |
