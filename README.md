# Ballerina Reckon One connector

[![Build](https://github.com/ballerina-platform/module-ballerinax-reckon.one/actions/workflows/ci.yml/badge.svg)](https://github.com/ballerina-platform/module-ballerinax-reckon.one/actions/workflows/ci.yml)
[![GitHub Last Commit](https://img.shields.io/github/last-commit/ballerina-platform/module-ballerinax-reckon.one.svg)](https://github.com/ballerina-platform/module-ballerinax-reckon.one/commits/main)
[![GitHub Issues](https://img.shields.io/github/issues/ballerina-platform/ballerina-library/module/reckon.one.svg?label=Open%20Issues)](https://github.com/ballerina-platform/ballerina-library/labels/module%2Freckon.one)

## Overview

[Reckon One](https://www.reckon.com/au/products/reckon-one/) is a cloud accounting platform for small businesses and their accountants. The Reckon One connector gives Ballerina programs access to version 2 of the Reckon One API, so you can read and manage the accounting data held in a Reckon One book from your integrations.

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

1. [Customer invoice creation](examples/customer_invoice_creation/customer_invoice_creation.md) - Create a customer, raise an invoice for it and read the invoice back.
2. [Supplier bill summary](examples/supplier_bill_summary/supplier_bill_summary.md) - Page through all bills and suppliers in a book and total the outstanding balance per supplier.

## Build from the source

### Setting up the prerequisites

1. Download and install Java SE Development Kit (JDK) version 21. You can download it from either of the following sources:

    * [Oracle JDK](https://www.oracle.com/java/technologies/downloads/)
    * [OpenJDK](https://adoptium.net/)

   > **Note:** After installation, remember to set the `JAVA_HOME` environment variable to the directory where JDK was installed.

2. Download and install [Ballerina Swan Lake](https://ballerina.io/).

3. Download and install [Docker](https://www.docker.com/get-started).

   > **Note**: Ensure that the Docker daemon is running before executing any tests.

4. Export Github Personal access token with read package permissions as follows,

    ```bash
    export packageUser=<Username>
    export packagePAT=<Personal access token>
    ```

### Build options

Execute the commands below to build from the source.

1. To build the package:

   ```bash
   ./gradlew clean build
   ```

2. To run the tests:

   ```bash
   ./gradlew clean test
   ```

3. To build the without the tests:

   ```bash
   ./gradlew clean build -x test
   ```

4. To run tests against different environments:

   ```bash
   ./gradlew clean test -Pgroups=<Comma separated groups/test cases>
   ```

5. To debug the package with a remote debugger:

   ```bash
   ./gradlew clean build -Pdebug=<port>
   ```

6. To debug with the Ballerina language:

   ```bash
   ./gradlew clean build -PbalJavaDebug=<port>
   ```

7. Publish the generated artifacts to the local Ballerina Central repository:

    ```bash
    ./gradlew clean build -PpublishToLocalCentral=true
    ```

8. Publish the generated artifacts to the Ballerina Central repository:

   ```bash
   ./gradlew clean build -PpublishToCentral=true
   ```

## Contribute to Ballerina

As an open-source project, Ballerina welcomes contributions from the community.

For more information, go to the [contribution guidelines](https://github.com/ballerina-platform/ballerina-lang/blob/master/CONTRIBUTING.md).

## Code of conduct

All the contributors are encouraged to read the [Ballerina Code of Conduct](https://ballerina.io/code-of-conduct).

## Useful links

* For more information go to the [`reckon.one` package](https://central.ballerina.io/ballerinax/reckon.one/latest).
* For example demonstrations of the usage, go to [Ballerina By Examples](https://ballerina.io/learn/by-example/).
* Chat live with us via our [Discord server](https://discord.gg/ballerinalang).
* Post all technical questions on Stack Overflow with the [#ballerina](https://stackoverflow.com/questions/tagged/ballerina) tag.
