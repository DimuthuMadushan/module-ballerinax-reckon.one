# Supplier bill summary

This example pages through every bill in a Reckon One book and totals the outstanding balance for each supplier. It then pages through the suppliers to report how many the book holds.

## Prerequisites

- Ballerina Swan Lake 2201.12.0 or later
- Create a `Config.toml` in this directory:
  ```toml
  accessToken = "<your-access-token>"
  bookId = "<your-book-id>"
  pageSize = 50
  ```

## Run the example

```bash
bal run
```
