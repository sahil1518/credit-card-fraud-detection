use FraudDetectionDB;

  --- Query1 -  Fraud Summary KPIs

SELECT
    COUNT(*)                                            AS total_transactions,
    SUM(is_fraud)                                       AS fraud_count,
    CAST(SUM(is_fraud)*100.0/COUNT(*) AS DECIMAL(5,4)) AS fraud_percentage,
    SUM(CASE WHEN is_fraud=1 THEN amount END)           AS total_fraud_amount,
    AVG(CASE WHEN is_fraud=1 THEN amount END)           AS avg_fraud_amount
FROM transactions;

/*    Query2 --  Write a SQL query that groups transactions into amount bands and shows fraud rate for each band.
        The bands should be:

        micro — amount less than 10
        small — amount between 10 and 100
        medium — amount between 100 and 500
        large — amount between 500 and 2000
        very large — amount above 2000                    */

		SELECT
    CASE
        WHEN amount < 10  THEN 'micro'
        WHEN amount < 100  THEN 'small'
        WHEN amount < 500  THEN 'medium'
        WHEN amount < 2000  THEN 'large'
        ELSE 'very large'
    END                    AS amount_band,
    COUNT(*)               AS Total_transactions,
    SUM(is_fraud)          AS Fraud_count,
    CAST(SUM(is_fraud)*100.0/COUNT(*) AS DECIMAL(5,2)) AS Fraud_rate_per
FROM transactions
GROUP BY
    CASE
        WHEN amount < 10  THEN 'micro'
        WHEN amount < 100  THEN 'small'
        WHEN amount < 500 THEN 'medium'
        WHEN amount < 2000 THEN 'large'
        ELSE 'very large'
    END
ORDER BY MIN(amount);

/*      Query3 --  Write a SQL query that shows fraud pattern by hour of day.
         
 Show these columns:

 1.Hour of day (0 to 23)
 2.Total transactions in that hour
 3.Fraud count in that hour
 4.Fraud rate percentage
 5.Rank of each hour by fraud count — highest fraud hour = rank 1    
    */

WITH hourly AS (
    SELECT
        (CAST(time_seconds AS INT) / 3600) % 24  AS hour_of_day,
        COUNT(*)                                  AS tran_per_hour,
        SUM(is_fraud)                             AS fraud_count
    FROM transactions
    GROUP BY (CAST(time_seconds AS INT) / 3600) % 24
)
SELECT
    hour_of_day,
    tran_per_hour,
    fraud_count,
    CAST(fraud_count * 100.0 / tran_per_hour AS DECIMAL(5,2)) AS fraud_rate_per,
    RANK() OVER (ORDER BY fraud_count DESC) AS fraud_rnk
FROM hourly
ORDER BY hour_of_day desc;

 /*  Query 4 —   Write a SQL query that shows the top 10 highest value fraud transactions. Show these columns:

 1.transaction_id
 2.amount
 3.time_seconds
 4.A rank column — highest amount = rank 1     */

 select top 10  
        transaction_id ,
		amount , 
		time_seconds ,
        dense_rank() over (order by amount desc) as fraud_drnk
 from transactions
 where is_fraud = 1;

 /* Query 5 — Write a SQL query that shows cumulative fraud loss over time — how fraud amount keeps adding up hour by hour.Show these columns:

1.Hour bucket 
2.Hourly fraud loss — total fraud amount in that hour
3.Cumulative fraud loss — running total that keeps adding up from hour 0 to last hour         */
 
 select 
 CAST(time_seconds/3600 AS INT) as hours_basket ,
 SUM(CASE WHEN is_fraud=1 THEN amount ELSE 0 END) as Hourly_fraud_loss , 
 SUM(SUM(CASE WHEN is_fraud=1 THEN amount ELSE 0 END)) 
    OVER (ORDER BY CAST(time_seconds/3600 AS INT)) AS cumm_fraud_loss
 from transactions
 group by CAST(time_seconds/3600 AS INT)
 order by hours_basket;

  /*Query 6 —  Write a SQL query that shows average transaction amount for fraud vs legit transactions separately.

Show these 3 columns:
1.Transaction type — show 'Fraud' when is_fraud=1 and 'Legit' when is_fraud=0
2.Total transaction count
3.Average amount            */

select 
   CASE WHEN is_fraud=1 THEN 'Fraud' ELSE 'Legit' END as transaction_type ,
   COUNT(*) as total_count ,
   AVG(amount) as average_amount
   from transactions
   group by CASE WHEN is_fraud=1 THEN 'Fraud' ELSE 'Legit' END;

  /* Query 7 —  Write a SQL query that shows transaction count per hour of day.
            
  show these 2 columns:
  1.Hour of day (0 to 23)
  2.Total transactions in that hour   */

  select (CAST(time_seconds AS INT) / 3600) % 24 as trans_count_per_hr ,
         count(*) as Total_trans_hr 
  from transactions 
  group by (CAST(time_seconds AS INT) / 3600) % 24
  order by  trans_count_per_hr  ;

   /*  Query 8 —  Write a SQL query that shows top 5 hours by total fraud amount.
      Show these 3 columns:
	  1.Hour of day
	  2.Total fraud amount in that hour
	  3.Fraud transaction count in that hour     */

	  select top 5
	     (CAST(time_seconds AS INT) / 3600) % 24  as hr_days ,
	     SUM(CASE WHEN is_fraud=1 THEN amount ELSE 0 END) as fraud_amount_hr ,
		 SUM(is_fraud) as fraud_count
		 from transactions
		 group by  (CAST(time_seconds AS INT) / 3600) % 24
		 order by fraud_amount_hr desc;