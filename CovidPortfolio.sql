
--Select Data that we are going to be using
SELECT location,date,total_cases,new_cases,total_deaths,population
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
ORDER BY 1,2

--Looking at Total Cases vs Total Deaths
--Shows likelihood of dying if you contract covid in your country
SELECT location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM PortfolioProject..CovidDeaths
WHERE location like '%united k%'
ORDER BY 2,5 DESC

--Looking at Total Cases vs Population
--Shows what persentage of population got Covid
SELECT location, date, population, total_cases, (total_cases/population)*100 PopulationInfected
FROM PortfolioProject..CovidDeaths
WHERE location like '%united k%'
ORDER BY 2,5 DESC


--Looking at Countries with Highest Infection Rate compared to Population
SELECT location, population, MAX(total_cases) AS HighesInfectionCount, MAX((total_cases/population))*100 PercentPopulationInfected
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY location,population
ORDER BY PercentPopulationInfected

--Showing countries with highest death count per population
SELECT location, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY location
ORDER BY TotalDeathCount DESC

--Showing continents with highest death count per population
SELECT continent, MAX(cast(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC

-- Looking at Population vs Vaccinations
SELECT death.continent,death.location, death.date, death.population, vaccin.new_vaccinations
FROM PortfolioProject..CovidDeaths death
JOIN PortfolioProject..CovidVaccinations vaccin
	ON death.location = vaccin.location
	AND death.date = vaccin.date
WHERE death.continent is not null
ORDER BY 2,3

-- CTE cases and death
WITH CTE as (
	SELECT location,date,population,total_cases,new_cases,total_deaths,new_deaths
	FROM PortfolioProject..CovidDeaths
	WHERE total_deaths is not null
)
SELECT *
FROM CTE






