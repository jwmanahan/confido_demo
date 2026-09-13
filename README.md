This project is an exploration of a demo dataset that appears clipped from the real-life database of Confido, plus a few additions to make certain edge cases remain present.

The project builds a complete staging layer, then one example of intermediate and mart table on top of it, with the goal of "a clean, standardized invoice line items model".  See more on each layer in turn

### Staging layer
Having a staging layer does two things
1. We aren't directly `ref`ing raw data and therefore can swap out source tables in cases like ingestion pipeline migrations
2. Light logic editing like name changes and null value logic here is DRY and assures us that such things will be treated the same in every place they're encountered across this dbt project. No joins.

The staging layer still gets the benefit of maximal freshness that we would get from directly calling source tables because it's all views. Naming aligns tightly with the source table naming.

### Intermediate layer
The goal of this layer is normalization
* If an entity exists and is important enough to be needed for the mart layer, it should have a dedicated table in the intermediate layer
    * Exception: if the staging table is already well normalized, just call the staging table from the mart layer
    * See conceptual_model.png or confido_demo.drawio for more on what counts as an entity
* Joins and aggregations are common here
* In this project, limited to just int_invoices because we only care about invoice line items

### Mart layer
The goal of this layer is being useful to decisionmakers, whether human or algorithmic
* Denormalization is okay, for example a company+date granular table
* In this project, limited to just tbl_invoice_line_items, because that's the goal
    * But there are plenty of other eligible usages: see below

### Possible future improvements
* Mart tables with rolling totals
    * tbl_date_invoice_volume
    * tbl_date_company_invoice_volume
    * etc
* Product-level analytics
    * tbl_product_invoice_volume
    * Interpolate child product presence in invoices via item_id
* Point in time (PIT) support: two paths
    1. Product price and configs are already time-bound. Include them to compare in invoice prices to expectations
    2. dbt snapshots to create changelogs of everything else
