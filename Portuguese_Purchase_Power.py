#!/usr/bin/env python
# coding: utf-8

# In[62]:


import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
from bs4 import BeautifulSoup
import requests 

# Web Scraping the Portuguese Minimum Wage data from Wikipedia

url = 'https://pt.wikipedia.org/wiki/Sal%C3%A1rio_m%C3%ADnimo#Portugal'

page = requests.get(url)

soup = BeautifulSoup(page.text, 'html')


# In[63]:


table = soup.find_all('table')[4]


# In[64]:


minwage_title = table.find_all('th')

minwage_titles_table = [title.text.strip() for title in minwage_title]


# In[65]:


print(minwage_titles_table)


# In[66]:


data_rows=[]


# In[67]:


minwage_values = table.find_all('tr')

for row in minwage_values[1:]:
    ind_data = row.find_all('td')
    ind_data_ready = [data.text.strip() for data in ind_data]
    data_rows.append(ind_data_ready)


# In[68]:


data_rows


# In[69]:


df = pd.DataFrame(data = data_rows, columns = minwage_titles_table)


# In[70]:


df.head()


# In[71]:


df.drop(columns = ['R. A. Dos Açores','R. A. Da Madeira'], inplace = True)

df


# In[72]:


df.rename(columns = {'Efectivo em': 'Year', 'Portugal Continental':'Minimum Wage'}, inplace = True)


# In[73]:


# Adding the numeric values to the years 2012,2013 and 2015. Previsouly, they were all combined in the same line with
# a piece of text indicating that the minimum wage was stagnant in this period with the exception of 2015 that was completely missing.


missing_years = pd.DataFrame({'Year':[2012, 2013, 2015], 'Minimum Wage':['485,00 €','485,00 €','505,00 €']})


# In[74]:


growth_table = pd.concat([df, missing_years], ignore_index=True)


# In[75]:


growth_table.drop(index=5, inplace=True)


# In[76]:


# Transforming the data to a more standard and consistent format

growth_table['Year'].str.split()

growth_table['Year'] = growth_table['Year'].apply(lambda x: str(x).strip().split()[-1]).astype(int)


# In[77]:


growth_table.sort_values(by='Year', inplace=True)

growth_table.reset_index(drop=True, inplace=True)


# In[78]:


growth_table['Minimum Wage'] = growth_table['Minimum Wage'].apply(lambda x: str(x).split(',')[0])

# Changing the minimum wage values to annual values

growth_table['Minimum Wage'] = growth_table['Minimum Wage'].astype(int) * 14


# In[79]:


# Creating a Minimum Wage Growth column

growth_table['Min Wage Growth %'] = growth_table['Minimum Wage'].astype('Float64').pct_change().round(4) * 100


# In[80]:


growth_table


# In[81]:


# Manually inputting the average wages because the most reliable source (Pordata) only provided values in graphical format.

average_wage = [15689, 16099, 16519, 16750, 16653, 16230, 16624, 16379, 16451, 16743, 17116, 17601, 18518, 18860, 19851, 21131, 22933]


# In[82]:


# Adding those values to the dataframe

while len(average_wage) < len(growth_table):
                               average_wage.append(np.nan)

average_wage = pd.Series(average_wage, dtype='Int64')

growth_table['Average Wage'] = average_wage


# In[83]:


# Creating an Average Wage Growth column

import warnings
warnings.filterwarnings("ignore", category=DeprecationWarning)


growth_table['Avg Wage Growth %'] = growth_table['Average Wage'].pct_change().round(4) * 100


# In[84]:


# Manually inputting the inflation rate values because the most reliable source (Pordata) only provided values in graphical format.

inflation = [2.45, 2.59, -0.84, 1.4, 3.65, 2.77, 0.27, -0.28, 0.49, 0.61, 1.37, 0.99, 0.34, -0.01, 1.27, 7.83, 4.31, 2.42]

# Adding those values to the dataframe

while len(inflation) < len(growth_table):
    inflation.append(pd.NA)
    
growth_table['Inflation Growth %'] = inflation

growth_table['Inflation Growth %'] = growth_table['Inflation Growth %'].astype('Float64')


# In[85]:


growth_table['Diff Min Wage - Inflation'] = growth_table['Min Wage Growth %'] - growth_table['Inflation Growth %']
growth_table['Diff Avg Wage - Inflation'] = growth_table['Avg Wage Growth %'] - growth_table['Inflation Growth %']


growth_table


# In[86]:


# Generating a visualization-friendly table by removing all null values from the original DataFrame

viz_growth_table = growth_table.dropna(subset=['Min Wage Growth %','Average Wage'])


# In[87]:


viz_growth_table


# In[88]:


plt.figure(figsize=(12,6))

sns.lineplot(data=viz_growth_table, x='Year', y='Min Wage Growth %', label='Minimum Wage', color=(0.4, 0.7, 1))
sns.lineplot(data=viz_growth_table, x='Year', y='Avg Wage Growth %', label='Average Wage', color=(0.2, 0.3, 0.7))
sns.lineplot(data=viz_growth_table, x='Year', y='Inflation Growth %', label='Inflation', linestyle='dashed', color=(1, 0.5, 0))


plt.ylim(-3,10)
plt.title('Portuguese Minimum and Average Salaries Growth in % (2008-2023)')
plt.xlabel('Year')
plt.ylabel('Growth in %')
plt.grid(True)
plt.axhline(0, color='black', linewidth=1.2, linestyle="-")


# In[89]:


# Filtering the data that will be plotted in the next bar plot
new_viz = viz_growth_table[['Year', 'Diff Min Wage - Inflation', 'Diff Avg Wage - Inflation']]


# In[90]:


# Melting the filtered data so I can create a bar plot for both the 'Min Wage - Inflation'
# and the 'Avg Wage - Inflation' variables


df_melted = new_viz.melt(
    id_vars='Year',
    var_name='Type',
    value_name='Growth in %'
)

plt.figure(figsize=(12,6))
sns.barplot(
    data=df_melted,
    x='Year',
    y='Growth in %',
    hue='Type',
    palette={'Diff Min Wage - Inflation':(0.4, 0.7, 1) , 'Diff Avg Wage - Inflation': (0.2, 0.3, 0.7)}
)

plt.title('Difference in Growth between Minimum or Average Wage and Inflation')
plt.axhline(0, color='black', linewidth=0.2, linestyle="-")


# In[91]:


"""
Some quick notes:
- It's clear that the Troika years significantly impacted the purchasing power of the Portuguese population between 2011 and 2014.
- The COVID-19 pandemic is another event that has notably affected these variables in recent years.
- Initially, I wanted to dive deeper into this small project by using the median Portuguese wage instead of the average wage, which is 
heavily influenced by higher salaries. However, I couldn't find any reliable data sources for the median wage over the past 15 years.
To give you an idea, the median wage in Portugal in 2021 was around €13,430 annually, which is still far behind the €19,851 average wage.
"""

