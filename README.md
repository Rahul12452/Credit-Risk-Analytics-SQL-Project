# 🏦 Credit Risk Analytics SQL Project

An end-to-end PostgreSQL case study analyzing a trading firm's counterparty exposure, credit limits, market price volatility, and trade-level performance.

This project simulates **real-world financial risk management** scenarios involving:

* Credit exposure monitoring
* Limit utilization & breach detection
* Market-to-market valuation
* Commodity volatility tracking
* Profit & loss performance
* Data quality validations

---

# 🚀 Project Overview

The goal of this project is to design, query, and analyze a **risk analytics database** to support risk teams, compliance departments, and trading operations.

The project uses a **relational SQL schema** consisting of counterparty details, credit limits, market prices, and trade transactions.

Using PostgreSQL, I wrote 20+ queries to answer key business questions around:

* Credit risk
* Counterparty exposure
* Limit breaches
* Trade performance
* Market volatility
* Data quality
* Scenario analysis

The analysis helps identify **high-risk counterparties**, **limit breaches**, **exposure hot spots**, and **market-driven risks**.

---

# 📂 Database Schema

### **Tables Used**

#### **1. Counterparty_Master**

```
(Counterparty_ID, Counterparty_Name, Region, Country, Credit_Rating, Risk_Score)
```

#### **2. Credit_Limits**

```
(Counterparty_ID, Credit_Limit_USD, Approved_Date, Review_Date, Limit_Type)
```

#### **3. Market_Prices**

```
(Price_Date, Commodity, Price_USD, Volatility)
```

#### **4. Trade_Transactions**

```
(Trade_ID, Counterparty_ID, Trade_Date, Maturity_Date, Commodity, Quantity, 
 Trade_Value_USD, Market_Value_USD, PnL_USD, Exposure_USD, Breach_Flag, DataQuality_Flag)
```

---

# 🔗 Key Relationships (Business Logic)

* `Counterparty_ID` links **counterparty**, **credit limits**, and **trade transactions**
* `Commodity` links trade data with **market price & volatility**
* **Exposure** is derived from market value
* **PnL** shows profit/loss for each trade
* **Credit_Limit_USD** determines whether a counterparty is **safe / watch / breach**

---

# 🧱 Schema Diagram (Conceptual)

```
Counterparty_Master (1) —— (1) Credit_Limits —— (M) Trade_Transactions —— (M) Market_Prices
```

A fully relational structure suitable for real-world **risk management & compliance analytics**.

---

# 🛠 Skills & SQL Concepts Used

✔ PostgreSQL Joins & Aggregations
✔ Window Functions (Exposure ranking, PnL analysis)
✔ Date Functions (intervals, daily trends, volatility windows)
✔ CASE logic (breach classification)
✔ Grouping & Trend Analysis
✔ CTEs & Subqueries
✔ Scenario Testing (Market Price Shock)
✔ Data Quality Checks
✔ Risk Reporting Structure

---

# 🔍 Business Questions Solved

### **Exposure & Credit Risk**

📌 Total exposure per counterparty  
📌 Credit limit utilization %  
📌 Breach / Watchlist / Safe classification  
📌 Top 10 counterparties by exposure  
📌 Exposure by credit rating  
📌 Region-wise exposure concentration  

### **Trade Performance**

📌 Mark-to-Market (MTM) difference  
📌 Highest PnL counterparties  
📌 Worst performing trades  
📌 Commodity-wise trade value vs market value  

### **Market Analytics**

📌 Highest volatility commodities (last 30 days)  
📌 Daily exposure trend for a specific commodity  

### **Data Quality**

📌 Identify trades with missing or incorrect data  

### **Scenario Simulation**

📌 “What if market drops by 10%?” — exposure & PnL impact  

---

# 🧪 Sample Insights

✔ **Some counterparties exceed 90% limit utilization**, qualifying as “Breach” and requiring immediate action.

✔ **Exposure concentration is high in specific regions**, indicating geographical risk clusters.

✔ **Commodity volatility directly impacts exposure**, especially for crude oil and metals.

✔ **Counterparties with low credit ratings show higher exposure**, increasing default probability.

✔ **PnL analysis identifies few trades contributing significantly to losses**, useful for trader performance evaluation.

✔ **Data Quality Flags highlight trades with incorrect values**, ensuring clean reporting.

✔ A **10% market price drop scenario reveals which trades are most sensitive**, helping risk teams plan hedging strategies.

---

# 📎 Project Files

📄 **Risk_Analytics_Queries.sql** → All SQL queries: credit exposure, PnL, volatility, breaches, what-if analysis  
📊 **counterparty_data.csv** → Counterparty dataset  
📊 **trade_transactions.csv** → Trade details  
📊 **market_prices.csv** → Commodity prices & volatility.  
