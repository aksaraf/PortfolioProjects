# PortfolioProjects

## **Project: [SQL Data Exploration](https://github.com/aksaraf/PortfolioProjects/blob/main/Covid_SQL.sql)**
- Dataset: [Coronavirus(Covid 19) Deaths](https://ourworldindata.org/covid-deaths)
- Divided the original datasets into two different datasets, covid_deaths and covid_vaccination, using excel. 
- Created a new database 'PortfolioProjects' in ***Microsoft SQL Server Management Studio*** and uploaded both the excel files.
- Found out answers to following question using SQL:
  - The likelihood of dying if you contract covid in your country?
  - What percentage of population got covid?
  - Which country has the highest infection rate?
  - Countries with the highest death count per population?
  - Continents with the highest death count per population?
  - Global numbers (total cases, total deaths, death percentage)
  - Total population vs vaccination?
- Special thanks to [Alex The Analyst](https://github.com/AlexTheAnalyst) for the [youtube tutorial](https://www.youtube.com/watch?v=qfyynHBFOsM&list=PLUaB-1hjhk8H48Pj32z4GZgGWyylqv85f&index=1)

## **Project: [Tableau Visulization](https://public.tableau.com/app/profile/akshay.saraf/viz/Covid-19Dashboard_16268423182770/Dashboard1)**
- Created excel sheets of the results I got from **SQL Data Exploration** project
- I did some basic data cleaning in excel
- Using these excel file in tableau, I built the following visualization
  - Table for Global Numbers
  - Bar chart for Total Deaths Per Continent
  - Map for Percent Population Infected Per Country
  - Line chart for Percent Population Infected
  - Created a dashboard containing all 4 visualizations. 
- (You can find my other tableau visualizations [here](https://public.tableau.com/app/profile/akshay.saraf))
  
## **Project: [Data Cleaning in SQL](https://github.com/aksaraf/PortfolioProjects/blob/main/Nashville%20Housing%20Data%20Cleaning%20Using%20SQL.sql)**
- Dataset: [Nashville Housing Data](https://github.com/AlexTheAnalyst/PortfolioProjects/blob/main/Nashville%20Housing%20Data%20for%20Data%20Cleaning.xlsx)
- I did the following data cleaning work:
  - Standardize SaleDate column
  - Populate PropertyAddress data
  - Breaking down PropertyAddress into individual column (address, city, state)
  - Breaking down OwnerAddress into individual column (address, city, state)
  - Change Y and N to YES and NO in SoldAsVacant column
  - Remove duplicates
  - Delete unused columns
  
## **Project: [Correlation in Python](https://github.com/aksaraf/PortfolioProjects/blob/main/Correlation%20in%20Python.ipynb)**
- Dataset: [Movie Industry](https://www.kaggle.com/danielgrijalvas/movies)
- Python libraries used:
  - [Numpy](https://github.com/aksaraf/PythonLibraries/blob/main/NumpyCheatSheet.ipynb)
  - [Pandas](https://github.com/aksaraf/PythonLibraries/blob/main/PandasCheatSheet.ipynb)
  - [Matplotlib](https://github.com/aksaraf/PythonLibraries/blob/main/MatplotlibCheatSheet.ipynb)
  - [Seaborn](https://github.com/aksaraf/PythonLibraries/blob/main/SeabornCheatSheet.ipynb)
- I did the following tasks in ***Jupyter Notebook***
  - Importing libraries
  - Reading the data
  - Finding columns having missing data
  - Data types of each column
  - Creating new column 'yearcorrect' based on 'released' column
  - Removing duplicates
  - Scatterplot of budget vs gross using matplotlib
  - Scatterplot with regression line of budget vs gross using seaborn
  - Creating correlation table using pearson, kendall, spearman method
  - Creating heatmap of correlation matrix
  - Converting object type column to numeric(category)
  
