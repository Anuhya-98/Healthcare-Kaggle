-- Creating Database named Healthcare.
CREATE DATABASE Healthcare;
USE Healthcare;

-- Assuming a table structure for demonstration. You might need to adjust it based on your actual data.
CREATE TABLE Healthcare (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255),
    Age INT,
    Medical_Condition VARCHAR(255),
    Medication VARCHAR(255),
    Insurance_Provider VARCHAR(255),
    Hospital VARCHAR(255),
    Billing_Amount DECIMAL(10, 2),
    Date_of_Admission DATE,
    Discharge_date DATE,
    Blood_Type VARCHAR(5),
    Test_Results VARCHAR(255),
    Doctor VARCHAR(255)
);

-- 1. Counting Total Records in Database
SELECT COUNT(*) AS Total_Records FROM Healthcare;

-- 2. Finding maximum age of patients admitted.
SELECT MAX(Age) AS Maximum_Age FROM Healthcare;

-- 3. Finding average age of hospitalized patients.
SELECT ROUND(AVG(Age), 0) AS Average_Age FROM Healthcare;

-- 4. Calculating Patients Hospitalized Age-wise from Maximum to Minimum
SELECT Age, COUNT(Age) AS Total
FROM Healthcare
GROUP BY Age
ORDER BY Age DESC;

-- 5. Calculating Maximum Count of patients based on total patients hospitalized with respect to age.
SELECT Age, COUNT(Age) AS Total
FROM Healthcare
GROUP BY Age
ORDER BY Total DESC, Age DESC;

-- 6. Ranking Age on the number of patients Hospitalized
SELECT Age, COUNT(Age) AS Total, 
       DENSE_RANK() OVER(ORDER BY COUNT(Age) DESC, Age DESC) AS Ranking_Admitted 
FROM Healthcare
GROUP BY Age;

-- 7. Finding Count of Medical Condition of patients and listing it by maximum number of patients.
SELECT Medical_Condition, COUNT(Medical_Condition) AS Total_Patients 
FROM Healthcare
GROUP BY Medical_Condition
ORDER BY Total_Patients DESC;

-- 8. Finding Rank & Maximum number of medicines recommended to patients based on Medical Condition pertaining to them.
SELECT Medical_Condition, Medication, COUNT(Medication) AS Total_Medications_to_Patients, 
       RANK() OVER(PARTITION BY Medical_Condition ORDER BY COUNT(Medication) DESC) AS Rank_Medicine
FROM Healthcare
GROUP BY Medical_Condition, Medication
ORDER BY Medical_Condition, Rank_Medicine;

-- 9. Most preferred Insurance Provider by Patients Hospitalized
SELECT Insurance_Provider, COUNT(Insurance_Provider) AS Total 
FROM Healthcare
GROUP BY Insurance_Provider
ORDER BY Total DESC;

-- 10. Finding out most preferred Hospital
SELECT Hospital, COUNT(Hospital) AS Total 
FROM Healthcare
GROUP BY Hospital
ORDER BY Total DESC;

-- 11. Identifying Average Billing Amount by Medical Condition.
SELECT Medical_Condition, ROUND(AVG(Billing_Amount), 2) AS Avg_Billing_Amount
FROM Healthcare
GROUP BY Medical_Condition;

-- 12. Finding Billing Amount of patients admitted and number of days spent in respective hospital.
SELECT Medical_Condition, Name, Hospital, 
       DATEDIFF(Discharge_date, Date_of_Admission) AS Number_of_Days, 
       SUM(ROUND(Billing_Amount, 2)) OVER(Partition BY Hospital ORDER BY Hospital DESC) AS Total_Amount
FROM Healthcare
ORDER BY Medical_Condition;

-- 13. Finding Total number of days spent by patient in a hospital for given medical condition
SELECT Name, Medical_Condition, ROUND(Billing_Amount, 2) AS Billing_Amount, Hospital, 
       DATEDIFF(Discharge_Date, Date_of_Admission) AS Total_Hospitalized_days
FROM Healthcare;

-- 14. Finding Hospitals which were successful in discharging patients after having test results as 'Normal' with count of days taken to get results to Normal
SELECT Medical_Condition, Hospital, DATEDIFF(Discharge_Date, Date_of_Admission) AS Total_Hospitalized_days, Test_results
FROM Healthcare
WHERE Test_results = 'Normal'
ORDER BY Medical_Condition, Hospital;

-- 15. Calculate number of blood types of patients which lies between age 20 to 45
SELECT Age, Blood_type, COUNT(Blood_Type) AS Count_Blood_Type
FROM Healthcare
WHERE Age BETWEEN 20 AND 45
GROUP BY Age, Blood_Type
ORDER BY Blood_Type DESC;

-- 16. Find how many patients are Universal Blood Donor and Universal Blood receiver
SELECT (SELECT Count(Blood_Type) FROM Healthcare WHERE Blood_Type = 'O-') AS Universal_Blood_Donor, 
       (SELECT Count(Blood_Type) FROM Healthcare WHERE Blood_Type = 'AB+') AS Universal_Blood_receiver
FROM Healthcare
LIMIT 1;

-- 17. Assuming the stored procedure and calling it is based on your database management system's syntax, which varies.

-- 18. Provide a list of hospitals along with the count of patients admitted in the year 2024 AND 2025
SELECT Hospital, Count(*) AS Total_Admitted
FROM Healthcare
WHERE YEAR(Date_of_Admission) IN (2024, 2025)
GROUP BY Hospital
ORDER BY Total_Admitted DESC;

-- 19. Find the average, minimum, and maximum billing amount for each insurance provider
SELECT Insurance_Provider, 
       ROUND(AVG(Billing_Amount), 0) AS Average_Amount, 
       ROUND(MIN(Billing_Amount), 0) AS Minimum_Amount, 
       ROUND(MAX(Billing_Amount), 0) AS Maximum_Amount
FROM Healthcare
GROUP BY Insurance_Provider;

-- 20. Creating a column for risk categorization is not directly possible in a SELECT statement. 
-- Assuming this is intended to show how one might categorize based on existing data without altering the table structure:
SELECT Name, Medical_Condition, Test_Results,
       CASE 
           WHEN Test_Results = 'Inconclusive' THEN 'Need More Checks / CANNOT be Discharged'
           WHEN Test_Results = 'Normal' THEN 'Can take discharge, But need to follow Prescribed medications timely' 
           WHEN Test_Results = 'Abnormal' THEN 'Needs more attention and more tests'
       END AS Status, Hospital, Doctor
FROM Healthcare;