SELECT * FROM Calendar$
SELECT * FROM Listings$
SELECT * FROM Reviews$

-- Price by Zipcode
SELECT Zipcode, AVG(Price) AS Average_Price
FROM Listings$
WHERE Zipcode IS NOT NULL
GROUP BY Zipcode
ORDER BY Average_Price DESC

-- Price for Year
SELECT date, SUM(price) AS Total_Revenue
FROM Calendar$
GROUP BY date
ORDER BY date

-- Average Price Per Bedroom 
SELECT Bedrooms, AVG(Price) AS Average_Price
FROM Listings$
WHERE Bedrooms IS NOT NULL AND Bedrooms <> 0 
GROUP BY Bedrooms
ORDER BY Bedrooms  

-- Bedrooms Listings (Distinct Count)
SELECT DISTINCT(CAST(COUNT(Id) AS INT)) AS Bedroom_Listings, Bedrooms
FROM Listings$
GROUP BY Bedrooms
HAVING Bedrooms > 0
ORDER BY Bedrooms 

-- Map Visualisation 1
SELECT Zipcode, AVG(Price) AS Average_Price
FROM Listings$
WHERE Zipcode IS NOT NULL
GROUP BY Zipcode
