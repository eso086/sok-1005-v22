```python
url = "https://www.motor.no/bil/sjekk-motors-rekkevidde-resultater-bilmodell-for-bilmodell/202424"
```


```python
from bs4 import BeautifulSoup
import requests

def fetch_html_tables(url):
    "Returns a list of tables in the html of url"
    page = requests.get(url)
    bs=BeautifulSoup(page.content)
    tables=bs.find_all('table')
    return tables
tables=fetch_html_tables('https://www.motor.no/bil/sjekk-motors-rekkevidde-resultater-bilmodell-for-bilmodell/202424')
table_html=tables[0]

#printing top
print(str(table_html)[:1000])
```

    <table class="">
    <thead>
    <tr>
    <td>
                
                Bilmodell
                </td>
    <td>
                
                Test
                </td>
    <td>
                
                Rekkevidde i testen
                </td>
    <td>
                
                Oppgitt WLTP
                </td>
    <td>
                
                Avvik i prosent
                </td>
    <td>
                
                Forbruk (målt) kWt/ 100km
                </td>
    <td>
                
                Forbruk (oppgitt) kWt/ 100km
                </td>
    <td>
                
                Utstyrsnivå
                </td>
    </tr>
    </thead>
    <tbody>
    <tr><td>Audi e-tron 55</td><td>Sommer 2020</td><td>399 km</td><td>370 km</td><td>7,83</td><td>20,3</td><td>24,3</td><td>Advanced Business</td></tr>
    <tr><td>Audi e-tron 55 Sportback</td><td>Sommer 2020</td><td>436 km</td><td>376 km</td><td>15,95</td><td>19,8</td><td>23,9</td><td>S-Line</td></tr>
    <tr><td>Audi e-tron Quattro 50</td><td>Vinter 2020</td><td>259 km</td><td>332 km</td><td>−13,38</td><td>N/A</td><td>23,9</td><td>Advance



```python
def html_to_table(html):
    "Returns the table defined in html as a list"
    #defining the table:
    table=[]
    #iterating over all rows
    for row in html.find_all('tr'):
        r=[]
        #finding all cells in each row:
        cells=row.find_all('td')
        
        #if no cells are found, look for headings
        if len(cells)==0:
            cells=row.find_all('th')
            
        #iterate over cells:
        for cell in cells:
            cell=format(cell)
            r.append(cell)
        
        #append the row to t:
        table.append(r)
    return table

def format(cell):
    "Returns a string after converting bs4 object cell to clean text"
    if cell.content is None:
        s=cell.text
    elif len(cell.content)==0:
        return ''
    else:
        s=' '.join([str(c) for c in cell.content])
        
    #here you can add additional characters/strings you want to 
    #remove, change punctuations or format the string in other
    #ways:
    s=s.replace('\xa0','')
    s=s.replace('\n','')
    return s

table=html_to_table(table_html)

#printing top
print(str(table)[:1000])
```

    [['                        Bilmodell            ', '                        Test            ', '                        Rekkevidde i testen            ', '                        Oppgitt WLTP            ', '                        Avvik i prosent            ', '                        Forbruk (målt) kWt/ 100km            ', '                        Forbruk (oppgitt) kWt/ 100km            ', '                        Utstyrsnivå            '], ['Audi e-tron 55', 'Sommer 2020', '399 km', '370 km', '7,83', '20,3', '24,3', 'Advanced Business'], ['Audi e-tron 55 Sportback', 'Sommer 2020', '436 km', '376 km', '15,95', '19,8', '23,9', 'S-Line'], ['Audi e-tron Quattro 50', 'Vinter 2020', '259 km', '332 km', '−13,38', 'N/A', '23,9', 'Advanced Sport'], ['Audi e-tron Quattro 55', 'Vinter 2020', '341 km', '415 km', '−11,42', '24,4', '24,3', 'Advanced Business'], ['Audi e-Tron GT quattro', 'Sommer 2021', '528,1 km', '468 km', '12,84', '16,1', '20,1', 'GT quattro Pro'], ['BMW i3', 'Sommer 2020', '319



```python
';'.join(table[0])
```




    '                        Bilmodell            ;                        Test            ;                        Rekkevidde i testen            ;                        Oppgitt WLTP            ;                        Avvik i prosent            ;                        Forbruk (målt) kWt/ 100km            ;                        Forbruk (oppgitt) kWt/ 100km            ;                        Utstyrsnivå            '




```python
def save_data(file_name,table):
    "Saves table to file_name"
    f=open(file_name,'w')
    for row in table:
        f.write(';'.join(row)+'\n')
    f.close()
    
save_data('wltp.csv',table)
```


```python
import pandas as pd
g_df = pd.read_csv("wltp.csv", delimiter=';', encoding='latin1')#reading data
g_df
```




<div>
<style scoped>
    .dataframe tbody tr th:only-of-type {
        vertical-align: middle;
    }

    .dataframe tbody tr th {
        vertical-align: top;
    }

    .dataframe thead th {
        text-align: right;
    }
</style>
<table border="1" class="dataframe">
  <thead>
    <tr style="text-align: right;">
      <th></th>
      <th>Bilmodell</th>
      <th>Test</th>
      <th>Rekkevidde i testen</th>
      <th>Oppgitt WLTP</th>
      <th>Avvik i prosent</th>
      <th>Forbruk (mÃ¥lt) kWt/ 100km</th>
      <th>Forbruk (oppgitt) kWt/ 100km</th>
      <th>UtstyrsnivÃ¥</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <th>0</th>
      <td>Audi e-tron 55</td>
      <td>Sommer 2020</td>
      <td>399 km</td>
      <td>370 km</td>
      <td>7,83</td>
      <td>20,3</td>
      <td>24,3</td>
      <td>Advanced Business</td>
    </tr>
    <tr>
      <th>1</th>
      <td>Audi e-tron 55 Sportback</td>
      <td>Sommer 2020</td>
      <td>436 km</td>
      <td>376 km</td>
      <td>15,95</td>
      <td>19,8</td>
      <td>23,9</td>
      <td>S-Line</td>
    </tr>
    <tr>
      <th>2</th>
      <td>Audi e-tron Quattro 50</td>
      <td>Vinter 2020</td>
      <td>259 km</td>
      <td>332 km</td>
      <td>â13,38</td>
      <td>NaN</td>
      <td>23,9</td>
      <td>Advanced Sport</td>
    </tr>
    <tr>
      <th>3</th>
      <td>Audi e-tron Quattro 55</td>
      <td>Vinter 2020</td>
      <td>341 km</td>
      <td>415 km</td>
      <td>â11,42</td>
      <td>24,4</td>
      <td>24,3</td>
      <td>Advanced Business</td>
    </tr>
    <tr>
      <th>4</th>
      <td>Audi e-Tron GT quattro</td>
      <td>Sommer 2021</td>
      <td>528,1 km</td>
      <td>468 km</td>
      <td>12,84</td>
      <td>16,1</td>
      <td>20,1</td>
      <td>GT quattro Pro</td>
    </tr>
    <tr>
      <th>...</th>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
      <td>...</td>
    </tr>
    <tr>
      <th>83</th>
      <td>Volvo XC40 Recharge P8</td>
      <td>Sommer 2021</td>
      <td>445,4 km</td>
      <td>415 km</td>
      <td>7,33</td>
      <td>17,5</td>
      <td>24,0</td>
      <td>Recharge P8 AWD</td>
    </tr>
    <tr>
      <th>84</th>
      <td>Volvo XC40 Recharge P8</td>
      <td>Vinter 2021</td>
      <td>332 km</td>
      <td>409 km</td>
      <td>â18,82</td>
      <td>21,8</td>
      <td>23,9</td>
      <td>Recharge Pure Electric P8</td>
    </tr>
    <tr>
      <th>85</th>
      <td>Xpeng G3</td>
      <td>Sommer 2020</td>
      <td>506 km</td>
      <td>450 km</td>
      <td>12,44</td>
      <td>13,1</td>
      <td>14,7</td>
      <td>Smart</td>
    </tr>
    <tr>
      <th>86</th>
      <td>Xpeng G3</td>
      <td>Sommer 2021</td>
      <td>438,9 km</td>
      <td>451 km</td>
      <td>â2,68</td>
      <td>-</td>
      <td>14,7</td>
      <td>Premium</td>
    </tr>
    <tr>
      <th>87</th>
      <td>Xpeng G3</td>
      <td>Vinter 2021</td>
      <td>341 km</td>
      <td>451 km</td>
      <td>â24,39</td>
      <td>16,7</td>
      <td>14,7</td>
      <td>Smart</td>
    </tr>
  </tbody>
</table>
<p>88 rows × 8 columns</p>
</div>




```python
import pandas as pd
from skimpy import clean_columns # kommer ikke videre fordi colnames ikke kan cleanes.
```


    ---------------------------------------------------------------------------

    ModuleNotFoundError                       Traceback (most recent call last)

    Input In [163], in <module>
          1 import pandas as pd
    ----> 2 from skimpy import clean_columns


    ModuleNotFoundError: No module named 'skimpy'



```python
#from matplotlib import pyplot as plt
#
#fig,ax=plt.subplots()
#
##adding axis lables:
#ax.set_ylabel('range')
#ax.set_xlabel('WLTP')
#
##plotting the function:
#ax.scatter(g['Rekkevidde i testen'], g['Oppgitt WLTP'],  label='Observasjoner')
#ax.legend(loc='lower right',frameon=False)
```

jeg har gjort samme analyse i R hvor en tydlig kan se at det er en sammenheng mellom WLTP (låvd distanse) og virkelig distanse for bilene. 


```python

```
