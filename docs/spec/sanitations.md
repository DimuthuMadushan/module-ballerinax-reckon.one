_Author_:  @DimuthuMadushan \
_Created_: 2026/10/22 \
_Updated_: 2026/10/22 \
_Edition_: Swan Lake

# Sanitation for OpenAPI specification

This document records the sanitation done on top of the official OpenAPI specification from Reckon One. 
The OpenAPI specification is obtained from [wso2/api-specs](https://github.com/wso2/api-specs/blob/main/openapi/reckon/one/v2/openapi.json).
These changes are done in order to improve the overall usability, and as workarounds for some known language limitations.


## Sanitations

1. Added an `oauth2` security scheme (authorization code flow, authorization URL `https://identity.reckon.com/connect/authorize`, token and refresh URL `https://identity.reckon.com/connect/token`, scopes `read` and `write`) and a top-level `security` requirement. The original spec declared no security scheme, so the generated client had no `auth` configuration. This change was made in the original spec `docs/spec/openapi.json`.
2. Rewrote `info.description` as a short plain-text summary of what the connector does, which becomes the `Client` class documentation. This change was made in the original spec `docs/spec/openapi.json`.
3. Removed the `GET` operations that carry a request body, which cannot be generated as client methods: `Banking_GetBankTransactionLinks` (`GET /{bookId}/banking/banktransactionlinks`), and `SuperfundProviders_SearchSuperfundProvidersGET` and `SuperfundProviders_SearchSuperfundProductsGET` (the `GET` variants of `/{bookId}/superfundProviders/search` and `/{bookId}/superfundProviders/products/search`). The two search paths keep their `POST` operations, which take the same body. The bank transaction links operation has no `POST` equivalent and is no longer available. This change was made in the original spec `docs/spec/openapi.json`.
4. Added the missing `summary` to five operations: `Heartbeat_ThrowError`, `Heartbeat_LogTest`, `InvoiceReminderTemplates_CreateInvoicesReminderTemplate`, `InvoiceReminderTemplates_GetInvoiceReminderTemplate` and `InvoiceReminderTemplates_PatchInvoicesReminderTemplate`. This change was made in the original spec `docs/spec/openapi.json`.
5. Made duplicate operation summaries distinct, by naming the resource (the delete line item operations of bills, expense claims, invoices and superstreams; the create transaction link operations of credit notes, payments, receipts and supplier credit notes; the allocable transactions of payments and receipts; `PaymentTerms_PatchPaymentTerm`) or by marking the `POST` variant of each report that also has a `GET` variant as using a request body. This change was made in the original spec `docs/spec/openapi.json`.
6. Replaced the inline `oneOf` schema of the `parameters` query parameter on the payroll leave balances and accrual value, payroll detail, payroll transactions summary, super transactions, timesheet and super contributions by employee reports (12 operations) with a direct `$ref` to the report parameters schema, which avoids generating `Parameters*` and `Parameters*OneOf1` wrapper types. This change was made in the original spec `docs/spec/openapi.json`.
7. Removed invalid property `default` values: the string `"null"` (504 properties, including properties of type object, enum and string), the typo `"nulll"` (8) and descriptive text used as a default value such as `"The default bank account."`, `"empty string"` and `"Current value in Settings"` (35). They produced non-compiling record defaults, or would send the literal text to the API. This change was made in the original spec `docs/spec/openapi.json`.
8. Added the missing request body description (`Details of the email.`) to the `Invoices_EmailInvoice` operation. This change was made in the original spec `docs/spec/openapi.json`.
9. Added descriptions to 14 properties that had none, so the generated record fields are documented: `AuditHistory.fullDetails`, `RecurringTransOptionsInput.autoPaymentProvider`, `FinancialInstitution.isOpenBanking`, `isYodlee` and `isDirect`, `RecurringFrequencyInput.value` and `lastDayOfEachMonth`, `ItemInventory.itemId` and `canShowQuantityOnPurchaseOrder`, `InvoiceLineItemGroupInput.printAsSingleLine` and `key`, and `RecurringScheduleInput.startDate`, `frequency` and `endCondition`. The `$ref`-based `frequency` and `endCondition` carry the description beside their single-member `oneOf`. This change was made in the original spec `docs/spec/openapi.json`.
10. Added descriptions to the `2xx` responses that had an empty description (`Banking_BeginBankReconciliation`, `Banking_FinishBankReconciliation`, the three `DefaultSuperfunds_*` operations, `Heartbeat_ThrowError`, `Heartbeat_LogTest`, `Invoices_EmailInvoice` and `PurchaseOrders_EmailPurchaseOrder`), so the generated methods document their return value. This change was made in the original spec `docs/spec/openapi.json`.
11. Added descriptions to parameters that had none: `page` and `perPage` of `Industries_GetBusinessTypes`, `bookId` and `invoiceId` of `Invoices_EmailInvoice`, `paymentId` of `Payments_GetAllocatedAndAllocatablePaymentTransactions`, `bookId` of `Permissions_GetUserPermissions` and `transactionType` of `RecurringTransactions_GetRecurringTransaction`. This change was made in the original spec `docs/spec/openapi.json`.
12. Added the `offline_access` scope to the `oauth2` authorization code flow and to the top-level security requirement, so that Reckon issues a refresh token. This change was made in the original spec `docs/spec/openapi.json`.

## OpenAPI cli command

The following command was used to generate the Ballerina client from the OpenAPI specification. The command should be executed from the repository root directory.

```bash
bal openapi -i docs/spec/aligned_ballerina_openapi.json -o ballerina --mode client --license docs/license.txt --client-methods remote
```

Note: The license year is hardcoded to 2026, change if necessary.
