This code is about covid deaths worldwide
It also explains about the data for each country and how they are distributed
We compared total cases vs total deaths (shows likelihood of you dying if you contract covid in your counttry)
We compared total cases vs population (shows what percentage of population got covid)
We queried countries with highest infection rate compared to population.
We showed countries with highest death count per population. 
We showed the data by breaking them by continent 
We created temp tables, views.
We used Drop table. 

some notes or issues faced while working with the code

Operand data type nvarchar is invalid for divide operator.

example :
before : Select location, date,total_cases,total_deaths, (total_deaths as int)/(total_cases as int)*100 as Deathpercentage
from [portfolio project ]..covideaths
order by 1,2

after using cast
Select location, date,total_cases,total_deaths, (cast(total_deaths as int)/cast(total_cases as int))*100 as Deathpercentage
from [portfolio project ]..covideaths
order by 1,2 

after using decimal and cast 
Select location, date,total_cases,total_deaths, (cast(total_deaths as decimal)/cast(total_cases as decimal))*100 as Deathpercentage
from [portfolio project ]..covideaths
order by 1,2



using nullif function:

before : 
Select date,Sum(new_cases), Sum(cast(new_deaths as decimal)),
sum(cast(new_deaths as decimal))/SUM(cast(new_cases as decimal))*100 as DeathPercentage
from [portfolio project ]..covideaths
--where location like '%states%'
where continent is not null
group by date
order by 1,2

after: 
Select date,Sum(new_cases), Sum(cast(new_deaths as decimal)),
sum(cast(new_deaths as decimal))/SUM(cast(nullif(new_cases,0) as decimal))*100 as DeathPercentage
from [portfolio project ]..covideaths
--where location like '%states%'
where continent is not null
group by date
order by 1,2

we used nullif(value,0) -- divide by zero encountered issue. 
