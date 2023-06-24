import pandas as pd
import plotly.express as px
import matplotlib.pyplot as plt
import pdb
import seaborn as sns #Strange I know, but sns box plots look better
import plotly.graph_objects as go

df = pd.read_csv('JPSTHTable.csv')
dfstim = pd.read_csv('JPSTHTableStim.csv')
fig = go.Figure(data=go.Scatter(x=df['dist'],
                                y=df['cor'],
                                mode='markers',
                                marker_color=df['nElecJ']))
fig.show()

fig = go.Figure(data=go.Scatter(x=dfstim['distS'],
                                y=dfstim['CorStim'],
                                mode='markers',
                                marker_color=dfstim['nelecS']))
fig.show()