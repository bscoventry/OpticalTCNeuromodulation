import pandas as pd
import plotly.express as px
import pdb
df = pd.read_csv('JPSTHTable.csv')
dfstim = pd.read_csv('JPSTHTableStim.csv')
#pdb.set_trace()
dist = df['dist']
dist = dist/2000
df['dist'] = dist
nelec = df['nElecJ']
nelec = nelec/16
df['nElecJ'] = nelec

dist = dfstim['distS']
dist = dist/2000
dfstim['distS'] = dist
nelec = dfstim['nelecS']
nelec = nelec/16
dfstim['nelecS'] = nelec 

fig = px.scatter_ternary(df, a="nElecJ", b="dist", c="cor")
figStim = px.scatter_ternary(dfstim, a="nelecS", b="distS", c="CorStim")

fig.show()
fig.write_image("JPSTHTernary.eps", width=1920, height=1080)
figStim.show()
figStim.write_image("JPSTHTernaryStim.eps", width=1920, height=1080)