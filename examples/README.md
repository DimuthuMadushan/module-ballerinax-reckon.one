# Examples

The `ballerinax/reckon.one` connector provides practical examples illustrating usage in various scenarios.

1. [Customer invoice creation](./customer_invoice_creation/customer_invoice_creation.md) - Create a customer, raise an invoice for it and read the invoice back.
2. [Supplier bill summary](./supplier_bill_summary/supplier_bill_summary.md) - Page through all bills and suppliers in a book and total the outstanding balance per supplier.

## Prerequisites

- Ballerina Swan Lake 2201.12.0 or later
- An access token for a Reckon One book and the Reckon One API subscription key, which every example sends in the `Ocp-Apim-Subscription-Key` header. Each example documents the `Config.toml` values it needs.

## Running an example

Execute the following commands to build an example from the source:

* To build an example:

    ```bash
    bal build
    ```

* To run an example:

    ```bash
    bal run
    ```

## Building the examples with the local module

**Warning**: Due to the absence of support for reading local repositories for single Ballerina files, the Bala of the module is manually written to the central repository as a workaround. Consequently, the bash script may modify your local Ballerina repositories.

Execute the following commands to build all the examples against the changes you have made to the module locally:

* To build all the examples:

    ```bash
    ./build.sh build
    ```

* To run all the examples:

    ```bash
    ./build.sh run
    ```
