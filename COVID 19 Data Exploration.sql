/*
Covid 19 Data Exploration 

Skills used: Joins, Temp Tables, Windows Functions, Aggregate Functions, Creating Views, Converting Data Types

*/

select *
from PortfolioProject001..CovidDeaths$
where continent is not null
order by 3, 4

select *
from PortfolioProject001..CovidVaccinations$
order by 3, 4

select location, date, total_cases, new_cases, total_deaths, population
from PortfolioProject001..CovidDeaths$
order by 1,2

-- Total Cases vs Total Deaths
-- ShoWs the Likelihood of Dying if you Contract Covid in India

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject001..CovidDeaths$
where location like '%india'
order by 1,2

-- Total Cases vs Total Deaths
-- Shows what Percentage of Population Infected with Covid

select location, date, population, total_cases, (total_cases/population)*100 as PercentagePopulationInfected
from PortfolioProject001..CovidDeaths$
where location like '%india%'
order by 1,2

-- Counties with Highest Infection Rate Compered to Population

select location, population, max(total_cases) as HighestInfectionCount, max(total_cases/population)*100 as PercentagePopulationInfected
from PortfolioProject001..CovidDeaths$
where population is not null
group by location,population
order by PercentagePopulationInfected desc

-- Counties with Highest Death Count per Population

select location, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject001..CovidDeaths$
where continent is not null
group by location
order by TotalDeathCount desc

-- Show Continent by Highest Death Count

select continent, max(cast(total_deaths as int)) as TotalDeathCount
from PortfolioProject001..CovidDeaths$
where continent is not null
group by continent
order by TotalDeathCount desc

--Globel Numbers

select date, sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject001..CovidDeaths$
where continent is not null
group by date
order by 1,2

select sum(new_cases) as total_cases, sum(cast(new_deaths as int)) as total_deaths, sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
from PortfolioProject001..CovidDeaths$
where continent is not null
order by 1,2


-- Total Population vs Vaccinations
-- Shows Percentage of Population that has recieved at least one Covid Vaccine

select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as AccumilativePeopleVaccinated
from PortfolioProject001..CovidDeaths$ dea
join PortfolioProject001..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date=vac.date
where dea.continent is not null and dea.population is not null
order by 2,3

-- Using Temp Table to perform Calculation on Partition By in previous query

drop table if exists PercentagePopulationVaccinated
create table PercentagePopulationVaccinated
(
continent nvarchar (255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)
insert into PercentagePopulationVaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from PortfolioProject001..CovidDeaths$ dea
join PortfolioProject001..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date=vac.date
where dea.continent is not null and dea.population is not null

select *, (RollingPeopleVaccinated/population)*100
from PercentagePopulationVaccinated

-- Creating View to Store Data for Later Visualizations

Create View PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(int,vac.new_vaccinations)) over (partition by dea.location order by dea.location,dea.date) as RollingPeopleVaccinated
from PortfolioProject001..CovidDeaths$ dea
join PortfolioProject001..CovidVaccinations$ vac
on dea.location = vac.location
and dea.date=vac.date
where dea.continent is not null and dea.population is not null


