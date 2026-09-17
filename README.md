# Canadian Bank Stock SQL Analysis

## Project Overview

This project uses SQL to analyze historical stock price data for five major Canadian banks from 2016 to 2025.

The goal is to explore stock price trends, annual returns, trading volume, and long-term performance using SQL and SQLite.

## Banks Analyzed

* Royal Bank of Canada (RY.TO)
* Toronto-Dominion Bank (TD.TO)
* Bank of Montreal (BMO.TO)
* Bank of Nova Scotia (BNS.TO)
* Canadian Imperial Bank of Commerce (CM.TO)

## Tools & Technologies

* Python
* Jupyter Notebook
* SQL
* SQLite
* pandas
* yfinance
* GitHub

## Data

Historical stock price data was collected using Yahoo Finance through the `yfinance` Python library.

The dataset contains daily stock prices from approximately January 2016 to December 2025.

The main fields include:

* Date
* Ticker
* Open
* High
* Low
* Close
* Adjusted Close
* Volume

## SQL Analysis

The project contains 15 SQL queries covering:

* Data validation and record counts
* Bank identification
* Historical date ranges
* Average, highest, and lowest closing prices
* Average closing price by year
* Highest closing price dates
* Average daily trading volume
* Long-term price returns
* Annual returns
* Best and worst performing years
* Average annual returns

## Key Skills Demonstrated

* SQL querying and filtering
* GROUP BY and aggregate functions
* Common Table Expressions (CTEs)
* Window functions
* Subqueries
* Data transformation
* Financial return calculations
* SQLite database analysis
* Working with financial market data

## Limitations

The return calculations use unadjusted closing prices and therefore do not include dividends.

The analysis focuses on historical performance and does not represent investment advice or future performance.

## Project Structure

```text
canadian-bank-sql-analysis/
│
├── bank_stock_data.csv
├── bank_stock.db
├── analysis_queries.sql
├── README.md
└── bank_stock_analysis.ipynb
```
