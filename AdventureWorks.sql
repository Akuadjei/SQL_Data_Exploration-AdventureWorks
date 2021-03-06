
-- Question 1: What are the regional sales in the best-performing country?

--- a. Finding the best performing country:
SELECT CountryRegionCode, MAX(SalesYTD) AS Country_SalesYTD
FROM [Sales].[SalesTerritory]
GROUP BY CountryRegionCode

--- b. Finding the current and past sales figures between the
---various regions in the US(top-performing country)
SELECT [Name],
      [SalesYTD], SalesLastYear
  FROM [Sales].[SalesTerritory]
  WHERE [CountryRegionCode] = 'US'




-- Question 2: Identify the three most important cities.
-- Show the breakdown of top-level product categories against the cities.

SELECT
  TOP 4
  Person.Address.City,
  Production.ProductCategory.Name AS Product_Category_Name,
  SUM(Sales.SalesOrderDetail.OrderQty * Sales.SalesOrderDetail.UnitPrice) AS Total_Sales
FROM
  Person.Address
  JOIN
    Sales.SalesOrderHeader
    ON Person.Address.AddressID = Sales.SalesOrderHeader.ShipToAddressID
  JOIN
    Sales.SalesOrderDetail
    ON Sales.SalesOrderHeader.SalesOrderID = Sales.SalesOrderDetail.SalesOrderID
  JOIN
    Production.Product
    ON Sales.SalesOrderDetail.ProductID = Production.Product.ProductID
  JOIN
    Production.ProductCategory
    ON Production.ProductCategory.ProductCategoryID = Production.Product.ProductSubcategoryID
GROUP BY
  Person.Address.City,
  Production.ProductCategory.Name
  ORDER BY Total_Sales DESC;





-- Question 3: What is the relationship between Country and Revenue?

SELECT Person.CountryRegion.CountryRegionCode, Person.CountryRegion.Name,
	 SUM(SalesYTD) AS current_revenue, SUM(SalesLastYear) AS past_revenue,
	((SUM(SalesYTD)- SUM(SalesLastYear))/SUM(SalesLastYear) * 100.0) AS growth_rate
FROM [Sales].[SalesTerritory]
JOIN Person.CountryRegion
ON sales.SalesTerritory.CountryRegionCode = Person.CountryRegion.CountryRegionCode
GROUP BY Person.CountryRegion.CountryRegionCode, Person.CountryRegion.Name
ORDER BY growth_rate DESC;




---Question 4: What is the relationship between sick leave and Job Title (PersonType)?

--- a. Finding the number of sick leave hours grouped by departments.
SELECT GroupName, SUM(SickLeaveHours) AS Total_SickHours
  FROM HumanResources.Employee AS E
  JOIN HumanResources.EmployeeDepartmentHistory AS DH
  ON E.BusinessEntityID = DH.BusinessEntityID
  Join HumanResources.Department AS D
  on DH.DepartmentID = D.DepartmentID
  GROUP BY  GroupName
  ORDER BY Total_SickHours DESC;

--- b. Finding the number of sick leave hours grouped by organizational levels.
SELECT
       [JobTitle],[VacationHours],[SickLeaveHours],[OrganizationLevel]
  FROM [HumanResources].[Employee]
  GROUP BY JobTitle, SickLeaveHours, VacationHours, OrganizationLevel
  ORDER BY SickLeaveHours DESC;




---Question 5: What is the relationship between store trading duration and revenue?

-- Assuming the current year is 2001.
SELECT Name, YearOpened, AnnualRevenue, (2001 - YearOpened + 1) AS Trading_Duration
FROM [Sales].[vStoreWithDemographics]
ORDER BY Trading_Duration DESC;




---Question 6: What is the relationship between the size of the stores,
-- the number of employees, and revenue?

SELECT Name, SquareFeet, AnnualRevenue, NumberEmployees
FROM [Sales].[vStoreWithDemographics]
ORDER BY NumberEmployees
