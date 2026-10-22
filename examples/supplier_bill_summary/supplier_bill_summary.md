# Supplier bill summary

This example pages through every bill in a Reckon One book and totals the outstanding balance for each supplier, keyed by supplier id. Bills that have no supplier are counted and reported separately, and a bill with no balance stops the run with an error naming the bill. `pageSize` must be between 1 and the largest 32-bit integer. The example then pages through the suppliers to report how many the book holds.

## Prerequisites

- Ballerina Swan Lake 2201.12.0 or later
- Create a `Config.toml` in this directory:
  ```toml
  accessToken = "<your-access-token>"
  subscriptionKey = "<your-subscription-key>"
  bookId = "<your-book-id>"
  pageSize = 50
  ```

## Run the example

```bash
bal run
```
