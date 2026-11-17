-- select * from BRONZE.crm_cust_info

-- select * FROM BRONZE.crm_prd_info

-- select * FROM BRONZE.crm_sales_details

select * from BRONZE.erp_cust_info

select 
gen,
count(*) from BRONZE.erp_cust_info
group by gen

SELECT
    CASE
        WHEN UPPER(TRIM(Gen)) IN ('M', 'MALE') THEN 'Male'
        WHEN UPPER(TRIM(Gen)) IN ('F', 'FEMALE') THEN 'Female'
        ELSE 'Unknown'
    END AS Gen,
    COUNT(*) AS Student_Count
FROM BRONZE.erp_cust_info
GROUP BY
    CASE
        WHEN UPPER(TRIM(Gen)) IN ('M', 'MALE') THEN 'Male'
        WHEN UPPER(TRIM(Gen)) IN ('F', 'FEMALE') THEN 'Female'
        ELSE 'Unknown'
    END;


    WITH Actual AS (
    SELECT
        CASE
            WHEN UPPER(TRIM(Gen)) IN ('M', 'MALE') THEN 'Male'
            WHEN UPPER(TRIM(Gen)) IN ('F', 'FEMALE') THEN 'Female'
            ELSE 'Unknown'
        END AS Gender,
        COUNT(*) AS Student_Count
    FROM BRONZE.erp_cust_info
    GROUP BY
        CASE
            WHEN UPPER(TRIM(Gen)) IN ('M', 'MALE') THEN 'Male'
            WHEN UPPER(TRIM(Gen)) IN ('F', 'FEMALE') THEN 'Female'
            ELSE 'Unknown'
        END
),
Expected AS (
    SELECT 'Male' AS Gender, 8612 AS Student_Count
    UNION ALL
    SELECT 'Female', 8396
    UNION ALL
    SELECT 'Unknown', 1475
)
SELECT
    E.Gender,
    E.Student_Count AS Expected_Count,
    ISNULL(A.Student_Count, 0) AS Actual_Count,
    CASE
        WHEN E.Student_Count = ISNULL(A.Student_Count, 0)
        THEN 'PASS'
        ELSE 'FAIL'
    END AS Test_Result
FROM Expected E
LEFT JOIN Actual A
    ON E.Gender = A.Gender;