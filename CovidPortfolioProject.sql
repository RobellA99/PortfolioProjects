SELECT * 
FROM CovidDeaths
WHERE continent IS NOT NULL

SELECT * 
FROM CovidDeaths
WHERE continent IS NOT NULL

-- Total Cases VS Total Deaths
SELECT location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercent
FROM CovidDeaths
WHERE location like '%King%'

-- Total Cases VS Popultion 
-- Percnetage of Population tested positive
SELECT location, date, total_cases, population, (total_cases/population)*100 AS PercentOfPopulation
FROM CovidDeaths
WHERE location like '%King%'

-- Worst hit locations 
SELECT location, date, total_cases, MAX(total_deaths/total_cases)*100 AS DeathPercent, MAX(total_deaths) AS TotalDeaths
FROM CovidDeaths
GROUP BY location, date, total_cases
HAVING MAX(total_deaths) > 50000
ORDER BY TotalDeaths DESC

-- Highest Infection Rate VS Population
SELECT location, population, MAX(total_cases) AS HighestCases, MAX(total_cases/population)*100 AS HighestRateOfInfection
FROM CovidDeaths
GROUP BY location, population
ORDER BY HighestRateOfInfection DESC

-- Highest Death Rate VS Population
SELECT location, population, MAX(CAST(total_deaths AS INT)) AS HighestDeaths
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY HighestDeaths DESC

-- Highest Death Rate (By Continent) VS Population
SELECT location, MAX(CAST(total_deaths AS INT)) AS HighestDeathsByContinent
FROM CovidDeaths
WHERE continent IS NULL
GROUP BY location
ORDER BY HighestDeathsByContinent DESC

-- Global Figures
SELECT date, SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS DeathPercentage
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY date

-- Total Covid Cases and Death Count
SELECT SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths, SUM(CAST(new_deaths AS INT))/SUM(new_cases)*100 AS DeathPercentage
FROM CovidDeaths
WHERE continent IS NOT NULL 

SELECT * FROM CovidVaccinations

-- Population By Country AND Total number of Vaccinations 
SELECT Death.date, Death.location, Death.population, Vaccine.total_vaccinations
FROM CovidVaccinations AS Vaccine
JOIN CovidDeaths AS Death
	ON Vaccine.date = Death.date
	AND Vaccine.location = Death.location
WHERE Vaccine.total_vaccinations IS NOT NULL AND Death.continent IS NOT NULL 
GROUP BY Death.date, Death.location, Death.population, Vaccine.total_vaccinations
ORDER BY location

-- Population VS Vaccinations
SELECT Death.date, Death.continent, Death.location, Death.population, Vaccine.new_vaccinations, SUM(CONVERT(INT, Vaccine.new_vaccinations)) OVER(PARTITION BY Death.location ORDER BY Death.location, Death.date) AS AggregateVaccineCount
FROM CovidVaccinations AS Vaccine
JOIN CovidDeaths AS Death
	ON Vaccine.date = Death.date
	AND Vaccine.location = Death.location
WHERE Death.continent IS NOT NULL 
ORDER BY location, date

-- CTE Population VS Vaccination
WITH PopvsVacc (continent, location, date, population, new_vaccinations, AggregateVaccineCount)
AS (
SELECT Death.date, Death.continent, Death.location, Death.population, Vaccine.new_vaccinations, SUM(CONVERT(INT, Vaccine.new_vaccinations)) OVER(PARTITION BY Death.location ORDER BY Death.location, Death.date) AS AggregateVaccineCount
FROM CovidVaccinations AS Vaccine
JOIN CovidDeaths AS Death
	ON Vaccine.date = Death.date
	AND Vaccine.location = Death.location
WHERE Death.continent IS NOT NULL 
)
SELECT *, (AggregateVaccineCount/population)*100 AS AggVaccineCountPerPop
FROM PopvsVacc

-- Temp Table Population VS Vaccination
DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated (
date DATETIME,
continent NVARCHAR (255),
location NVARCHAR (255),
population NUMERIC,
new_vaccinations NUMERIC, 
AggregateVaccineCount NUMERIC)

INSERT INTO #PercentPopulationVaccinated
SELECT Death.date, Death.continent, Death.location, Death.population, Vaccine.new_vaccinations, SUM(CONVERT(INT, Vaccine.new_vaccinations)) OVER(PARTITION BY Death.location ORDER BY Death.location, Death.date) AS AggregateVaccineCount
FROM CovidVaccinations AS Vaccine
JOIN CovidDeaths AS Death
	ON Vaccine.date = Death.date
	AND Vaccine.location = Death.location
WHERE Death.continent IS NOT NULL 

SELECT *, (AggregateVaccineCount/population)*100 AS AggVaccineCountPerPop
FROM #PercentPopulationVaccinated

-- Views
CREATE VIEW PercentPopulationVaccinated AS 
SELECT Death.date, Death.continent, Death.location, Death.population, Vaccine.new_vaccinations, SUM(CONVERT(INT, Vaccine.new_vaccinations)) OVER(PARTITION BY Death.location ORDER BY Death.location, Death.date) AS AggregateVaccineCount
FROM CovidVaccinations AS Vaccine
JOIN CovidDeaths AS Death
	ON Vaccine.date = Death.date
	AND Vaccine.location = Death.location
WHERE Death.continent IS NOT NULL 

CREATE VIEW HighestDeaths AS 
SELECT location, population, MAX(CAST(total_deaths AS INT)) AS HighestDeaths
FROM CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population



