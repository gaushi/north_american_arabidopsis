###########
#Python 3.7.7
#Pandas 1.1.1
#latlon-utils 0.0.5

#%%
import latlon_utils
from latlon_utils import get_climate
import pandas
import numpy as np
from tqdm import tqdm
#%%
#df = get_climate([48,42.3314], [9,-83.0458], res='2.5m',variables=['tmax'])
#%%
latlongdata = pandas.read_csv("allAccessions_GPS_forBioclim.txt", sep="\t")
#latlongdata = pandas.read_csv("testLatLong.txt", sep="\t")

#%%
def fetchData(latitude, longitude):
    return get_climate(latitude, longitude, variables = ['tavg', 'tmax', 'tmin','prec', 'srad', 'vapr', 'wind',], res='2.5m')

#%%
print("\nprocessing latitude and longitude information")
result = []
with tqdm(total=latlongdata.shape[0]) as pbar:
    for index, row in latlongdata.iterrows():
        info =(fetchData(row['latitude'], row['longitude']))
        result.append(info)
        pbar.update(1)

acc = []
for index, row in latlongdata.iterrows():
    acc.append(row['ind'])
#%%
accResult = dict(zip(acc,result))
#result.shape
# %%
mydf = pandas.DataFrame.from_dict(accResult, orient='index')

# %%
mydf.to_csv("allAccessions_BioclimData.csv.gz", float_format='%.4f')
