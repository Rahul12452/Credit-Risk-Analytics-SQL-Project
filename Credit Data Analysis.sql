CREATE TABLE Counterparty_Master (
    Counterparty_ID VARCHAR(10) PRIMARY KEY,
    Counterparty_Name VARCHAR(100) NOT NULL,
    Region VARCHAR(20),
    Country VARCHAR(50),
    Credit_Rating VARCHAR(5),
    Risk_Score INT
);
CREATE TABLE Credit_Limits (
    Counterparty_ID VARCHAR(10) PRIMARY KEY,
    Credit_Limit_USD DECIMAL(18,2),
    Approved_Date DATE,
    Review_Date DATE,
    Limit_Type VARCHAR(20),
    FOREIGN KEY (Counterparty_ID) REFERENCES Counterparty_Master(Counterparty_ID)
);
CREATE TABLE Market_Prices (
    Price_Date DATE,
    Commodity VARCHAR(50),
    Price_USD DECIMAL(10,4),
    Volatility DECIMAL(5,4),
    PRIMARY KEY (Price_Date, Commodity)
);
CREATE TABLE Trade_Transactions (
    Trade_ID VARCHAR(10) PRIMARY KEY,
    Counterparty_ID VARCHAR(10),
    Trade_Date DATE,
    Maturity_Date DATE,
    Commodity VARCHAR(50),
    Quantity INT,
    Trade_Value_USD DECIMAL(18,2),
    Market_Value_USD DECIMAL(18,2),
    PnL_USD DECIMAL(18,2),
    Exposure_USD DECIMAL(18,2),
    Breach_Flag VARCHAR(10),
    DataQuality_Flag VARCHAR(20),
    FOREIGN KEY (Counterparty_ID) REFERENCES Counterparty_Master(Counterparty_ID)
);



-- Total Exposure per Counterparty

SELECT * from counterparty_master;
SELECT * from Trade_Transactions;
SELECT * from credit_limits;




SELECT 
cp.counterparty_id,
cp.counterparty_name,
cp.region,
cl.credit_limit_usd,
sum(t.Exposure_USD) as Total_expoture,
round(sum(t.Exposure_USD/cl.Credit_Limit_USD*100),2) as utilisation_Percentage,
case 
when sum(t.Exposure_USD)/cl.Credit_Limit_USD>0.9  THEN 'Breach'
when sum(t.Exposure_USD)/cl.Credit_Limit_USD>0.7  THEN 'Watch'
ELSE 'safe'
end as breach_flag
from counterparty_master as cp
JOIN credit_limits as cl
ON cp.counterparty_id = cl.counterparty_id
LEFT join trade_transactions as t
on cp.counterparty_id = t.counterparty_id
GROUP by 
cp.counterparty_id,
cp.counterparty_name,
cp.region,
cl.credit_limit_usd
order by utilisation_Percentage desc



--- Top 10 Counterparties by Exposure

SELECT cp.Counterparty_ID,
cp.Counterparty_Name,
sum(t.Exposure_USD) as Total_Exposure
from counterparty_master as cp
JOIN trade_transactions as t on cp.Counterparty_ID = t.Counterparty_ID
GROUP by  cp.Counterparty_ID,
cp.Counterparty_Name
ORDER by Total_Exposure desc


-- Daily Exposure Trend for a Commodity

SELECT Trade_Date,
Commodity,
sum(Exposure_USD) As Total_exposture
FROM trade_transactions
WHERE Commodity = 'Brent_Crude'
group by  Trade_Date,
Commodity
ORDER by Trade_Date ASC

--- Trades with Data Quality Issues

SELECT
Trade_ID,
Counterparty_ID,
Commodity,
Trade_Date,
Market_Value_USD,
DataQuality_Flag
FROM Trade_Transactions
WHERE DataQuality_Flag <> 'OK'
ORDER BY Trade_Date DESC;


--- Exposure by Credit Rating

SELECT
cp.Credit_Rating,
COUNT(t.Trade_ID) AS Num_Trades,
SUM(t.Exposure_USD) AS Total_Exposure,
ROUND(AVG(t.Exposure_USD),2) AS Avg_Exposure
FROM Counterparty_Master cp
JOIN Trade_Transactions t ON cp.Counterparty_ID = t.Counterparty_ID
GROUP BY cp.Credit_Rating
ORDER BY Total_Exposure DESC;


--- What-If: Exposure if Market Prices Drop 10%

SELECT
t.Trade_ID,
t.Counterparty_ID,
t.Commodity,
t.Quantity,
t.Market_Value_USD,
ROUND(t.Market_Value_USD * 0.9, 2) AS Exposure_10pct_Drop,
t.Exposure_USD - ROUND(t.Market_Value_USD * 0.9, 2) AS PnL_Impact
FROM Trade_Transactions t
ORDER BY PnL_Impact ASC
LIMIT 20;

--— Identify counterparties whose exposure exceeds their credit limit

SELECT 
    cm.counterparty_id,
    cm.counterparty_name,
    cl.credit_limit_usd,
    SUM(tt.exposure_usd) AS total_exposure,
    (SUM(tt.exposure_usd) - cl.credit_limit_usd) AS breach_amount
FROM counterparty_master cm
JOIN credit_limits cl 
    ON cm.counterparty_id = cl.counterparty_id
JOIN trade_transactions tt 
    ON cm.counterparty_id = tt.counterparty_id
GROUP BY 
    cm.counterparty_id, cm.counterparty_name, cl.credit_limit_usd
HAVING SUM(tt.exposure_usd) > cl.credit_limit_usd;

--— Identify all trades flagged as breaches

SELECT 
    trade_id,
    counterparty_id,
    commodity,
    trade_value_usd,
    exposure_usd,
    breach_flag
FROM trade_transactions
WHERE breach_flag = 'YES';

-- — Find top 5 most profitable counterparties (highest PnL)


SELECT 
    cm.counterparty_name,
    SUM(tt.pnl_usd) AS total_pnl
FROM counterparty_master cm
JOIN trade_transactions tt 
    ON cm.counterparty_id = tt.counterparty_id
GROUP BY cm.counterparty_name
ORDER BY total_pnl DESC
LIMIT 5;

-- — Identify commodities with highest volatility (last 30 days)

SELECT 
    commodity,
    AVG(volatility) AS avg_volatility
FROM market_prices
WHERE price_date >= CURRENT_DATE - INTERVAL '30 days'
GROUP BY commodity
ORDER BY avg_volatility DESC;

-- — Calculate Mark-to-Market (MTM) difference for all trades

SELECT 
    trade_id,
    trade_date,
    market_value_usd - trade_value_usd AS mtm_difference
FROM trade_transactions;

--— Detect data quality issues


SELECT *
FROM trade_transactions
WHERE dataquality_flag IS NOT NULL
  AND dataquality_flag <> 'OK';

--— Calculate exposure by region

SELECT 
    cm.region,
    SUM(tt.exposure_usd) AS total_exposure
FROM counterparty_master cm
JOIN trade_transactions tt
    ON cm.counterparty_id = tt.counterparty_id
GROUP BY cm.region
ORDER BY total_exposure DESC;

-- Compare Market Value vs Trade Value per commodity

SELECT 
    tt.commodity,
    AVG(tt.trade_value_usd) AS avg_trade_value,
    AVG(tt.market_value_usd) AS avg_market_value
FROM trade_transactions tt
GROUP BY tt.commodity;

--- Identify counterparties with high risk score

SELECT 
    counterparty_id,
    counterparty_name,
    credit_rating,
    risk_score
FROM counterparty_master
WHERE risk_score > 80
ORDER BY risk_score DESC;

-- Identify credit limits overdue for review

SELECT 
    counterparty_id,
    credit_limit_usd,
    approved_date,
    review_date
FROM credit_limits
WHERE review_date < CURRENT_DATE;

