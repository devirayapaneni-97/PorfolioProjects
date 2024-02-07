Select * 
From [portfolio project ]..[covideaths]
where continent is not null
order by 3,4

--Select * 
--From [portfolio project ]..[covidvaccinations]
--order by 3,4

--select the data that we are going to be using 

Select location,date,total_cases,new_cases,total_deaths,population
From [portfolio project ]..[covideaths]
where continent is not null
order by 1,2

--we are looking at total cases vs total deaths 
-- how many cases are there in this country vs how many deaths

Select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as Deathpercentage
From [portfolio project ]..[covideaths]
order by 1,2


Select location, date,total_cases,total_deaths, (cast(total_deaths as decimal)/cast(total_cases as decimal))*100 as Deathpercentage
from [portfolio project ]..covideaths
where location like '%states%'
order by 1,2

--- loooking at total cases vs population 
--- shows what percentage of people got covid
Select location, date, population, total_cases, (cast(total_cases as decimal)/cast(population as decimal))*100 as PercentPopulaitonInfected
from [portfolio project ]..covideaths
--where location like '%states%'
order by 1,2

--looking at countries with highest infection rate compared to population
Select location, population, Max(total_cases) as HighestInfectionCount, Max((cast(total_cases as decimal)/cast(population as decimal)))*100 as PercentPopulaitonInfected
from [portfolio project ]..covideaths
--where location like '%states%'
where continent is not null
group by location, population
order by PercentPopulaitonInfected desc

--lets break things down by continent 
select location, Max(cast(Total_deaths as int)) as Totaldeathcount
from [portfolio project ]..covideaths
--where location like '%states'
 where continent is  not null
group by location
order by Totaldeathcount desc

--showing countries with highest death count per population 

select location, Max(cast(Total_deaths as int)) as Totaldeathcount
from [portfolio project ]..covideaths
--where location like '%states'
where continent is not null
group by location 
order by Totaldeathcount desc


--global numbers 
Select Sum(new_cases) as total_cases, Sum(cast(new_deaths as decimal)) as total_deaths,
sum(cast(new_deaths as decimal))/SUM(cast(nullif(new_cases,0) as decimal))*100 as DeathPercentage
from [portfolio project ]..covideaths
--where location like '%states%'
where continent is not null
--group by date
order by 1,2


--vaccinations

--total population vs vaccinations
select dea.continent, dea.location, dea.date, dea.population, 
vac.new_vaccinations, Sum(cast(vac.new_vaccinations as decimal)) over (partition by dea.location order by dea.location,
dea.date) as Rollingpeoplevaccinated,(Rollingpeoplevaccinated/population)
from [portfolio project ]..covideaths dea
join [portfolio project ]..covidvaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
order by 2,3



--using CTE
with popvsvac(continent,location,Date,population,new_vaccinations,Rollingpeoplevaccinated)
as
(select dea.continent, dea.location, dea.date, dea.population, 
vac.new_vaccinations, Sum(cast(vac.new_vaccinations as decimal)) over (partition by dea.location order by dea.location,
dea.date) as Rollingpeoplevaccinated--,(Rollingpeoplevaccinated/population)*100
from [portfolio project ]..covideaths dea
join [portfolio project ]..covidvaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *,(Rollingpeoplevaccinated/population)*100
from popvsvac

--temp table

DROP Table if exists #percentpopulationvaccinated
create Table #percentpopulationvaccinated
(continent nvarchar(255),
location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
Rollingpeoplevaccinated numeric)


Insert into #percentpopulationvaccinated
select dea.continent, dea.location, dea.date, dea.population, 
vac.new_vaccinations, Sum(cast(vac.new_vaccinations as decimal)) over (partition by dea.location order by dea.location,
dea.date) as Rollingpeoplevaccinated--,(Rollingpeoplevaccinated/population)*100
from [portfolio project ]..covideaths dea
join [portfolio project ]..covidvaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
--where dea.continent is not null
--order by 2,3

select *,(Rollingpeoplevaccinated/population)*100
from #percentpopulationvaccinated



---creating view to store data for later visualizations
create view Percentpopulationvaccinated as
select dea.continent, dea.location, dea.date, dea.population, 
vac.new_vaccinations, Sum(cast(vac.new_vaccinations as decimal)) over (partition by dea.location order by dea.location,
dea.date) as Rollingpeoplevaccinated--,(Rollingpeoplevaccinated/population)*100
from [portfolio project ]..covideaths dea
join [portfolio project ]..covidvaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select * from Percentpopulationvaccinated
