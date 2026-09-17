-- Canadian Bank Stock SQL Analysis
-- Analysis of 5 Canadian banks from 2016 to 2025

-- Query 1: Count total records
SELECT COUNT(*) AS total_rows
FROM stock_prices;

-- Query 2: List all banks
SELECT DISTINCT Ticker FROM stock_prices;

-- Query 3: Count records for each bank
SELECT Ticker, COUNT(*) AS number_of_rows 
FROM stock_prices 
GROUP BY Ticker;

-- Query 4: Find the data range
SELECT MIN(Date) AS first_date, MAX(Date) AS last_date
FROM stock_prices;

-- Query 5: Average closing price
SELECT Ticker, ROUND(AVG(CLOSE), 2) AS avg_close
FROM stock_prices
GROUP BY Ticker
ORDER BY avg_close DESC;

-- Query 6: Find highest closing price
SELECT Ticker, 
ROUND(MAX(Close), 2) AS highest_close
FROM stock_prices
GROUP BY Ticker
ORDER BY highest_close DESC;

-- Query 7: Find lowest closing price
SELECT Ticker, 
ROUND(MIN(Close), 2) AS lowest_close
FROM stock_prices
GROUP BY Ticker
ORDER BY lowest_close DESC;

-- Query 8: Calculate average closing price by year
SELECT Ticker, 
SUBSTR(Date, 1, 4) AS Year, 
ROUND(AVG(Close), 2) AS avg_close
FROM stock_prices
GROUP BY Ticker, Year
ORDER BY Year, Ticker;

-- Query 9: Find the date of each bank's highest closing price
SELECT Ticker, Date, Close FROM stock_prices 
WHERE (Ticker, Close) IN (
SELECT Ticker, MAX(Close) FROM stock_prices
GROUP BY Ticker
)
ORDER BY Ticker;

-- Query 10: Calculate average daily trading volume
SELECT Ticker, ROUND(AVG(Volume), 0) AS avg_volume
FROM stock_prices
GROUP BY Ticker
ORDER BY avg_volume DESC;

-- Query 11: Calculate price return from 2016 to 2025
WITH first_prices AS (
    SELECT Ticker, Close
    FROM stock_prices
    WHERE Date = '2016-01-04'),
last_prices AS (
    SELECT Ticker, Close
    FROM stock_prices
    WHERE Date = '2025-12-31')
SELECT 
    f.Ticker,
    ROUND(f.Close, 2) AS start_price,
    ROUND(l.Close, 2) AS end_price,
    ROUND((l.Close - f.Close) / f.Close * 100, 2) AS return_pct
FROM first_prices f
JOIN last_prices l
ON f.Ticker = l.Ticker
ORDER BY return_pct DESC;

-- Query 12: Calculate annual returns
WITH yearly_prices AS (
    SELECT
        Ticker,
        SUBSTR(Date, 1, 4) AS Year,
        FIRST_VALUE(Close) OVER (
            PARTITION BY Ticker, SUBSTR(Date, 1, 4)
            ORDER BY Date
        ) AS start_price,
        LAST_VALUE(Close) OVER (
            PARTITION BY Ticker, SUBSTR(Date, 1, 4)
            ORDER BY Date
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS end_price
    FROM stock_prices
)
SELECT DISTINCT
    Ticker,
    Year,
    ROUND((end_price - start_price) / start_price * 100, 2) AS annual_return_pct
FROM yearly_prices
ORDER BY Year, Ticker;

-- Query 13: Find the best performing year for each bank
WITH yearly_returns AS (
    SELECT
        Ticker,
        SUBSTR(Date, 1, 4) AS Year,
        FIRST_VALUE(Close) OVER (
            PARTITION BY Ticker, SUBSTR(Date, 1, 4)
            ORDER BY Date
        ) AS start_price,
        LAST_VALUE(Close) OVER (
            PARTITION BY Ticker, SUBSTR(Date, 1, 4)
            ORDER BY Date
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS end_price
    FROM stock_prices
),
annual_returns AS (
    SELECT DISTINCT
        Ticker,
        Year,
        (end_price - start_price) / start_price * 100 AS return_pct
    FROM yearly_returns
)
SELECT
    Ticker,
    Year,
    ROUND(return_pct, 2) AS best_return_pct
FROM annual_returns a
WHERE return_pct = (
    SELECT MAX(return_pct)
    FROM annual_returns b
    WHERE b.Ticker = a.Ticker
)
ORDER BY best_return_pct DESC;

-- Query 14: Find the worst performing year for each bank
WITH yearly_returns AS (
    SELECT
        Ticker,
        SUBSTR(Date, 1, 4) AS Year,
        FIRST_VALUE(Close) OVER (
            PARTITION BY Ticker, SUBSTR(Date, 1, 4)
            ORDER BY Date
        ) AS start_price,
        LAST_VALUE(Close) OVER (
            PARTITION BY Ticker, SUBSTR(Date, 1, 4)
            ORDER BY Date
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS end_price
    FROM stock_prices
),
annual_returns AS (
    SELECT DISTINCT
        Ticker,
        Year,
        (end_price - start_price) / start_price * 100 AS return_pct
    FROM yearly_returns
)
SELECT
    Ticker,
    Year,
    ROUND(return_pct, 2) AS worst_return_pct
FROM annual_returns a
WHERE return_pct = (
    SELECT MIN(return_pct)
    FROM annual_returns b
    WHERE b.Ticker = a.Ticker
)
ORDER BY worst_return_pct ASC;

-- Query 15: Calculate average annual return
WITH yearly_returns AS (
    SELECT
        Ticker,
        SUBSTR(Date, 1, 4) AS Year,
        FIRST_VALUE(Close) OVER (
            PARTITION BY Ticker, SUBSTR(Date, 1, 4)
            ORDER BY Date
        ) AS start_price,
        LAST_VALUE(Close) OVER (
            PARTITION BY Ticker, SUBSTR(Date, 1, 4)
            ORDER BY Date
            ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
        ) AS end_price
    FROM stock_prices
),
annual_returns AS (
    SELECT DISTINCT
        Ticker,
        Year,
        (end_price - start_price) / start_price * 100 AS return_pct
    FROM yearly_returns
)
SELECT
    Ticker,
    ROUND(AVG(return_pct), 2) AS avg_annual_return_pct
FROM annual_returns
GROUP BY Ticker
ORDER BY avg_annual_return_pct DESC;