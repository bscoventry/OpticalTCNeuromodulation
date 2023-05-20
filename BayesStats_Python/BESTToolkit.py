#---------------------------------------------------------------------------------------------------------
# Author: Brandon Coventry, PhD             Wisconsin Institute for Translational Neuroengineering
# Date: 02/16/2023
# Purpose: This is an implementation of PyMCs implementation of Krusckes Bayesian Estimation Supercedes
#          T-Test (BEST). This is run on JPSTH distance data
#---------------------------------------------------------------------------------------------------------
import pandas as pd
import numpy as np
import pymc as pm
import arviz as az
import seaborn as sns
import pdb
import matplotlib.pyplot as plt
import best

# Double checks to watch version. Won't necessarily work with PyMC < 4
print(f"Running on PyMC v{pm.__version__}")
# Define/import data here
if __name__ == '__main__':  
    numBurnIn = 20000
    numSamples = 20000
    data = pd.read_csv("C:\CodeRepos\SpikeAnalysis\JPSTHTableJPSTH.csv")
    
    maxCorr = data['MaxCor']
    maxDist = data['MaxDist']
    maxDistCats = np.unique(maxDist)
    
    #Full JPSTH
    dfMaxCorrDist0 = maxCorr.loc[maxDist == 0]                   
    dfMaxCorrDist0.reset_index(drop=True, inplace = True)
    dfMaxCorrDist250 = maxCorr.loc[maxDist == 250]                   
    dfMaxCorrDist250.reset_index(drop=True, inplace = True)
    dfMaxCorrDist500 = maxCorr.loc[maxDist == 500]                   
    dfMaxCorrDist500.reset_index(drop=True, inplace = True)
    #dfMaxCorrDist750 = maxCorr.loc[maxDist == 750]                   
    #dfMaxCorrDist750.reset_index(drop=True, inplace = True)
    dfMaxCorrDist1000 = maxCorr.loc[maxDist == 1000]                   
    dfMaxCorrDist1000.reset_index(drop=True, inplace = True)
    dfMaxCorrDist1250 = maxCorr.loc[maxDist == 1250]                   
    dfMaxCorrDist1250.reset_index(drop=True, inplace = True)
    df1 = pd.concat([dfMaxCorrDist0,dfMaxCorrDist250,dfMaxCorrDist500,dfMaxCorrDist1000])
    df3 = pd.concat([dfMaxCorrDist0,dfMaxCorrDist250])
    #Stim Correlations
    data = pd.read_csv("C:\CodeRepos\SpikeAnalysis\JPSTHTableStim.csv")
    maxCorrStim = data['MaxCorrStim']
    maxDistStim = data['MaxDistStim']
    maxDistStimCats = np.unique(maxDistStim)
    dfMaxCorrDistStim0 = maxCorrStim.loc[maxDistStim == 0]                   
    dfMaxCorrDistStim0.reset_index(drop=True, inplace = True)
    dfMaxCorrDistStim250 = maxCorrStim.loc[maxDistStim == 250]                   
    dfMaxCorrDistStim250.reset_index(drop=True, inplace = True)
    dfMaxCorrDistStim500 = maxCorrStim.loc[maxDistStim == 500]                   
    dfMaxCorrDistStim500.reset_index(drop=True, inplace = True)
    dfMaxCorrDistStim750 = maxCorrStim.loc[maxDistStim == 750]                   
    dfMaxCorrDistStim750.reset_index(drop=True, inplace = True)
    dfMaxCorrDistStim1000 = maxCorrStim.loc[maxDistStim == 1000]                   
    dfMaxCorrDistStim1000.reset_index(drop=True, inplace = True)
    dfMaxCorrDistStim1250 = maxCorrStim.loc[maxDistStim == 1250]                   
    dfMaxCorrDistStim1250.reset_index(drop=True, inplace = True)
    # dfMaxCorrDistStim1500 = maxCorrStim.loc[maxDistStim == 1500]                   
    # dfMaxCorrDistStim1500.reset_index(drop=True, inplace = True)
    #indv = pd.concat([df1, df2]).reset_index()          #Set up data frame groups
    df2 = pd.concat([dfMaxCorrDistStim0,dfMaxCorrDistStim250,dfMaxCorrDistStim500,dfMaxCorrDistStim750,dfMaxCorrDistStim1000,dfMaxCorrDistStim1250])
    #Define Model here
    MaxCorrDist0_250 = best.analyze_two(dfMaxCorrDist0,dfMaxCorrDist250)
    fig = best.plot_all(MaxCorrDist0_250)
    MaxCorrDist0_500 = best.analyze_two(dfMaxCorrDist0,dfMaxCorrDist500)
    fig = best.plot_all(MaxCorrDist0_500)
    # MaxCorrDist0_750 = best.analyze_two(dfMaxCorrDist0,dfMaxCorrDist750)
    # fig = best.plot_all(MaxCorrDist0_750)
    MaxCorrDist0_1000 = best.analyze_two(dfMaxCorrDist0,dfMaxCorrDist1000)
    fig = best.plot_all(MaxCorrDist0_1000)
    # MaxCorrDist0_1250 = best.analyze_two(dfMaxCorrDist0,dfMaxCorrDist1250)
    # fig = best.plot_all(MaxCorrDist0_1250)
    MaxCorrDist250_500 = best.analyze_two(dfMaxCorrDist250,dfMaxCorrDist500)
    fig = best.plot_all(MaxCorrDist250_500)
    # MaxCorrDist250_750 = best.analyze_two(dfMaxCorrDist250,dfMaxCorrDist750)
    # fig = best.plot_all(MaxCorrDist250_750)
    MaxCorrDist250_1000 = best.analyze_two(dfMaxCorrDist250,dfMaxCorrDist1000)
    fig = best.plot_all(MaxCorrDist250_1000)
    # MaxCorrDist250_1250 = best.analyze_two(dfMaxCorrDist250,dfMaxCorrDist1250)
    # fig = best.plot_all(MaxCorrDist250_1250)
    # MaxCorrDist500_750 = best.analyze_two(dfMaxCorrDist500,dfMaxCorrDist750)
    # fig = best.plot_all(MaxCorrDist500_750)
    MaxCorrDist500_1000 = best.analyze_two(dfMaxCorrDist500,dfMaxCorrDist1000)
    fig = best.plot_all(MaxCorrDist500_1000)
    # MaxCorrDist750_1000 = best.analyze_two(dfMaxCorrDist750,dfMaxCorrDist1000)
    # fig = best.plot_all(MaxCorrDist750_1000)
    # MaxCorrDist500_1250 = best.analyze_two(dfMaxCorrDist500,dfMaxCorrDist1250)
    # fig = best.plot_all(MaxCorrDist500_1250)
    # MaxCorrDist750_1250 = best.analyze_two(dfMaxCorrDist750,dfMaxCorrDist1250)
    # fig = best.plot_all(MaxCorrDist500_1250)
    # MaxCorrDist1000_1250 = best.analyze_two(dfMaxCorrDist1000,dfMaxCorrDist1250)
    # fig = best.plot_all(MaxCorrDist1000_1250)
    pdb.set_trace()
    #fig = best.plot.make_figure(M)
    MaxCorrDistStim0_250 = best.analyze_two(dfMaxCorrDistStim0,dfMaxCorrDistStim250)
    fig = best.plot_all(MaxCorrDistStim0_250)
    MaxCorrDistStim0_750 = best.analyze_two(dfMaxCorrDistStim0,dfMaxCorrDistStim750)
    fig = best.plot_all(MaxCorrDistStim0_750)
    MaxCorrDistStim0_500= best.analyze_two(dfMaxCorrDistStim0,dfMaxCorrDistStim500)
    fig = best.plot_all(MaxCorrDistStim0_500)
    MaxCorrDistStim0_1000 = best.analyze_two(dfMaxCorrDistStim0,dfMaxCorrDistStim1000)
    fig = best.plot_all(MaxCorrDistStim0_1000)
    MaxCorrDistStim0_1250 = best.analyze_two(dfMaxCorrDistStim0,dfMaxCorrDistStim1250)
    fig = best.plot_all(MaxCorrDistStim0_1250)
    MaxCorrDistStim250_500 = best.analyze_two(dfMaxCorrDistStim250,dfMaxCorrDistStim500)
    fig = best.plot_all(MaxCorrDistStim250_500)
    MaxCorrDistStim250_750 = best.analyze_two(dfMaxCorrDistStim250,dfMaxCorrDistStim750)
    fig = best.plot_all(MaxCorrDistStim250_750)
    MaxCorrDistStim250_1000 = best.analyze_two(dfMaxCorrDistStim250,dfMaxCorrDistStim1000)
    fig = best.plot_all(MaxCorrDistStim250_1000)
    MaxCorrDistStim250_1250 = best.analyze_two(dfMaxCorrDistStim250,dfMaxCorrDistStim1250)
    fig = best.plot_all(MaxCorrDistStim250_1250)
    MaxCorrDistStim500_750 = best.analyze_two(dfMaxCorrDistStim500,dfMaxCorrDistStim750)
    fig = best.plot_all(MaxCorrDistStim500_750)
    MaxCorrDistStim500_1000 = best.analyze_two(dfMaxCorrDistStim500,dfMaxCorrDistStim1000)
    fig = best.plot_all(MaxCorrDistStim500_1000)
    MaxCorrDistStim500_1250 = best.analyze_two(dfMaxCorrDistStim500,dfMaxCorrDistStim1250)
    fig = best.plot_all(MaxCorrDistStim500_1250)
    MaxCorrDistStim750_1000 = best.analyze_two(dfMaxCorrDistStim750,dfMaxCorrDistStim1000)
    fig = best.plot_all(MaxCorrDistStim750_1000)
    MaxCorrDistStim750_1250 = best.analyze_two(dfMaxCorrDistStim750,dfMaxCorrDistStim1250)
    fig = best.plot_all(MaxCorrDistStim750_1250)
    MaxCorrDistStim1000_1250 = best.analyze_two(dfMaxCorrDistStim1000,dfMaxCorrDistStim1250)
    fig = best.plot_all(MaxCorrDistStim1000_1250)
    # MaxCorrDistStim0_1500 = best.analyze_two(dfMaxCorrDistStim0,dfMaxCorrDistStim1500)
    # fig = best.plot_all(MaxCorrDistStim0_1500)
    # MaxCorrDistStim250_1500 = best.analyze_two(dfMaxCorrDistStim250,dfMaxCorrDistStim1500)
    # fig = best.plot_all(MaxCorrDistStim250_1500)
    # MaxCorrDistStim750_1500 = best.analyze_two(dfMaxCorrDistStim750,dfMaxCorrDistStim1500)
    # fig = best.plot_all(MaxCorrDistStim750_1500)
    # MaxCorrDistStim1000_1500 = best.analyze_two(dfMaxCorrDistStim1000,dfMaxCorrDistStim1500)
    # fig = best.plot_all(MaxCorrDistStim1000_1500)
    # MaxCorrDistStim1250_1500 = best.analyze_two(dfMaxCorrDistStim1250,dfMaxCorrDistStim1500)
    # fig = best.plot_all(MaxCorrDistStim1250_1500)
    plt.show()
    pdb.set_trace()
