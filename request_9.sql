WITH Output AS (
    SELECT 
        C.channel,
        ROUND(SUM(G.gross_price * FS.sold_quantity / 1000000), 2) AS Gross_sales_mln
    FROM 
        fact_sales_monthly FS 
        JOIN dim_customer C ON FS.customer_code = C.customer_code
        JOIN fact_gross_price G ON FS.product_code = G.product_code
    WHERE 
        FS.fiscal_year = 2021
    GROUP BY 
        C.channel
),
TotalSales AS (
    SELECT 
        SUM(Gross_sales_mln) AS total
    FROM 
        Output
)
SELECT 
    O.channel,
    CONCAT(O.Gross_sales_mln, ' M') AS Gross_sales_mln,
    CONCAT(ROUND(O.Gross_sales_mln * 100 / T.total, 2), ' %') AS percentage
FROM 
    Output O,
    TotalSales T
ORDER BY 
    percentage DESC;