-- DATASET - COVIDDEATHS

-- Quick view of the datasets
select top 10 * from PortfolioProject..CovidDeaths
select top 10 * from PortfolioProject..CovidVaccinations

-- Select the data we are going to be using
SELECT location, date, total_cases, new_cases, total_deaths, population 
FROM PortfolioProject..CovidDeaths
ORDER BY 1,2

-- Looking at Total Cases vs. Total Death
-- likelihood of dying if you cintract covid in your country
SELECT continent, location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location = 'India'
ORDER BY 1,2

-- Looking at Total Cases vs Population
-- what % of population got covid
SELECT continent,location, date, total_cases, population, (total_cases/population)*100 AS PercentPopluationInfected
FROM PortfolioProject..CovidDeaths
WHERE location = 'India' 
ORDER BY 1,2

-- Looking at countries with Highest Infection rate compared to Population
SELECT continent,location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PercentPopluationInfected
FROM PortfolioProject..CovidDeaths
where continent is not null
GROUP BY continent, location, population
ORDER BY 5 desc

-- Countries with highest death count per population
SELECT continent,location, MAX(CAST(total_deaths as INT)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
where continent is not null
GROUP BY location, continent
ORDER BY 3 desc


-- Continent with highest death count per population
SELECT continent, MAX(CAST(total_deaths as INT)) AS TotalDeathCount
FROM PortfolioProject..CovidDeaths
where continent is not null
GROUP BY continent
ORDER BY 2 desc

-- Global Numbers
SELECT date, SUM(new_cases) AS total_cases, SUM(CAST(new_deaths AS INT)) AS total_deaths,
		(SUM(CAST(new_deaths AS INT))/SUM(new_cases)) * 100 as DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY date
ORDER BY 4 desc

-- Total Population vs Vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(CAST(vac.new_vaccinations AS bigint)) OVER (PARTITION BY dea.location
	ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3

-- Using CTE
WITH PopvsVac(continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
	SUM(CAST(vac.new_vaccinations AS bigint)) OVER (PARTITION BY dea.location
	ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM PortfolioProject..CovidDeaths dea
JOIN PortfolioProject..CovidVaccinations vac
	ON dea.location = vac.location
	AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
)
SELECT *,(RollingPeopleVaccinated/population)*100 
FROM PopvsVac
ORDER BY 2,3

--Temp Table

DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations bigint,
RollingPeopleVaccinated numeric
)
Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
--where dea.continent is not null 
--order by 2,3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated
order by 2,3

-- Create View
CREATE VIEW PercentPopulationVaccinated AS
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(bigint,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
From PortfolioProject..CovidDeaths dea
Join PortfolioProject..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

Select * From PercentPopulationVaccinated