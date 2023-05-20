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
# Double checks to watch version. Won't necessarily work with PyMC < 4
print(f"Running on PyMC v{pm.__version__}")
# Define/import data here
if __name__ == '__main__':  
    numBurnIn = 20000
    numSamples = 20000
    data = pd.read_csv("C:\CodeRepos\SpikeAnalysis\JPSTHTable.csv")
    
    maxCorr = data['MaxCorr']
    maxDist = data['MaxDist']
    maxCorrStim = data['MaxCorrStim']
    maxDistStim = data['MaxDistStim']
    maxDistCats = np.unique(maxDist)
    maxDistStimCats = np.unique(maxDistStim)
    #Full JPSTH
    dfMaxCorrDist0 = maxCorr.loc[maxDist == 0]                   
    dfMaxCorrDist0.reset_index(drop=True, inplace = True)
    dfMaxCorrDist250 = maxCorr.loc[maxDist == 250]                   
    dfMaxCorrDist250.reset_index(drop=True, inplace = True)
    dfMaxCorrDist500 = maxCorr.loc[maxDist == 500]                   
    dfMaxCorrDist500.reset_index(drop=True, inplace = True)
    dfMaxCorrDist750 = maxCorr.loc[maxDist == 750]                   
    dfMaxCorrDist750.reset_index(drop=True, inplace = True)
    dfMaxCorrDist1000 = maxCorr.loc[maxDist == 1000]                   
    dfMaxCorrDist1000.reset_index(drop=True, inplace = True)
    dfMaxCorrDist1250 = maxCorr.loc[maxDist == 1250]                   
    dfMaxCorrDist1250.reset_index(drop=True, inplace = True)
    df1 = pd.concat([dfMaxCorrDist0,dfMaxCorrDist250,dfMaxCorrDist500,dfMaxCorrDist750,dfMaxCorrDist1000,dfMaxCorrDist1250])
    #Stim Correlations
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
    dfMaxCorrDistStim1500 = maxCorrStim.loc[maxDistStim == 1500]                   
    dfMaxCorrDistStim1500.reset_index(drop=True, inplace = True)
    #indv = pd.concat([df1, df2]).reset_index()          #Set up data frame groups
    df2 = pd.concat([dfMaxCorrDistStim0,dfMaxCorrDistStim250,dfMaxCorrDistStim500,dfMaxCorrDistStim750,dfMaxCorrDistStim1000,dfMaxCorrDistStim1250,dfMaxCorrDistStim1500])
    #Define Model here
    with pm.Model() as BEST:
        mu_m = df1.mean()
        mu_s = df1.std() * 2
        mu_mS = df2.mean()
        mu_sS = df2.std() * 2
        
        groupDist0_mean = pm.Normal("groupDist0_mean", mu=mu_m, sigma=mu_s)
        groupDist250_mean = pm.Normal("groupDist250_mean", mu=mu_m, sigma=mu_s)
        groupDist500_mean = pm.Normal("groupDist500_mean", mu=mu_m, sigma=mu_s)
        #groupDist750_mean = pm.Normal("groupDist750_mean",mu=mu_m, sigma=mu_s)
        groupDist1000_mean = pm.Normal("groupDist1000_mean",mu=mu_m, sigma=mu_s)
        groupDist1250_mean = pm.Normal("groupDist1250_mean", mu=mu_m, sigma=mu_s)
        groupDistStim0_mean = pm.Normal("groupDistStim0_mean", mu=mu_mS, sigma=mu_sS)
        groupDistStim250_mean = pm.Normal("groupDistStim250_mean", mu=mu_mS, sigma=mu_sS)
        #groupDistStim500_mean = pm.Normal("groupDistStim500_mean", mu=dfMaxCorrDistStim500.mean(), sigma=dfMaxCorrDistStim500.std()*2)
        groupDistStim750_mean = pm.Normal("groupDistStim750_mean", mu=mu_mS, sigma=mu_sS)
        groupDistStim1000_mean = pm.Normal("groupDistStim1000_mean", mu=mu_mS, sigma=mu_sS)
        groupDistStim1250_mean = pm.Normal("groupDistStim1250_mean", mu=mu_mS, sigma=mu_sS)
        groupDistStim1500_mean = pm.Normal("groupDistStim1500_mean", mu=mu_mS, sigma=mu_sS)
        sigma_low = 10**-1
        sigma_high = 1
        groupDist0_std = pm.Uniform("groupDist0_std", lower=sigma_low, upper=sigma_high)
        groupDist250_std = pm.Uniform("groupDist250_std", lower=sigma_low, upper=sigma_high)
        groupDist500_std = pm.Uniform("groupDist500_std", lower=sigma_low, upper=sigma_high)
        #groupDist750_std = pm.Uniform("groupDist750_std", lower=sigma_low, upper=sigma_high)
        groupDist1000_std = pm.Uniform("groupDist1000_std", lower=sigma_low, upper=sigma_high)
        groupDist1250_std = pm.Uniform("groupDist1250_std", lower=sigma_low, upper=sigma_high)
        groupDistStim0_std = pm.Uniform("groupDistStim0_std", lower=sigma_low, upper=sigma_high)
        groupDistStim250_std = pm.Uniform("groupDistStim250_std", lower=sigma_low, upper=sigma_high)
        #groupDistStim500_std = pm.Uniform("groupDistStim500_std", lower=sigma_low, upper=sigma_high)
        groupDistStim750_std = pm.Uniform("groupDistStim750_std", lower=sigma_low, upper=sigma_high)
        groupDistStim1000_std = pm.Uniform("groupDistStim1000_std", lower=sigma_low, upper=sigma_high)
        groupDistStim1250_std = pm.Uniform("groupDistStim1250_std", lower=sigma_low, upper=sigma_high)
        groupDistStim1500_std = pm.Uniform("groupDistStim1500_std", lower=sigma_low, upper=sigma_high)
        #Following Kruscke's lead here
        nu_minus_one = pm.Exponential("nu_minus_one", 1 / 29.0)
        nu = pm.Deterministic("nu", nu_minus_one + 1)
        nu_log10 = pm.Deterministic("nu_log10", np.log10(nu))
        #Enumerate groups here
        diffDist0_250 = pm.Deterministic("diffDist0_250", groupDist0_mean - groupDist250_mean)
        diffDist0_250_stds = pm.Deterministic("diffDist0_250_stds", groupDist0_std - groupDist250_std)
        diffDist0_250_effect_size = pm.Deterministic(
            "diffDist0_250_effect_size", diffDist0_250 / np.sqrt((groupDist0_std**2 + groupDist250_std**2) / 2)
        )
        diffDist0_500 = pm.Deterministic("diffDist0_500", groupDist0_mean - groupDist500_mean)
        diffDist0_500_stds = pm.Deterministic("diffDist0_500_stds", groupDist0_std - groupDist500_std)
        diffDist0_500_effect_size = pm.Deterministic(
            "diffDist0_500_effect_size", diffDist0_500 / np.sqrt((groupDist0_std**2 + groupDist500_std**2) / 2)
        )
        # diffDist0_750 = pm.Deterministic("diffDist0_750", groupDist0_mean - groupDist750_mean)
        # diffDist0_750_stds = pm.Deterministic("diffDist0_750_stds", groupDist0_std - groupDist750_std)
        # diffDist0_750_effect_size = pm.Deterministic(
        #     "diffDist0_750_effect_size", diffDist0_750 / np.sqrt((groupDist0_std**2 + groupDist750_std**2) / 2)
        # )
        diffDist0_1000 = pm.Deterministic("diffDist0_1000", groupDist0_mean - groupDist1000_mean)
        diffDist0_1000_stds = pm.Deterministic("diffDist0_1000_stds", groupDist0_std - groupDist1000_std)
        diffDist0_1000_effect_size = pm.Deterministic(
            "diffDist0_1000_effect_size", diffDist0_1000 / np.sqrt((groupDist0_std**2 + groupDist1000_std**2) / 2)
        )
        diffDist0_1250 = pm.Deterministic("diffDist0_1250", groupDist0_mean - groupDist1250_mean)
        diffDist0_1250_stds = pm.Deterministic("diffDist0_1250_stds", groupDist0_std - groupDist1250_std)
        diffDist0_1250_effect_size = pm.Deterministic(
            "diffDist0_1250_effect_size", diffDist0_1250 / np.sqrt((groupDist0_std**2 + groupDist1250_std**2) / 2)
        )
        diffDist250_500 = pm.Deterministic("diffDist250_500", groupDist250_mean - groupDist500_mean)
        diffDist250_500_stds = pm.Deterministic("diffDist250_500_stds", groupDist250_std - groupDist500_std)
        diffDist250_500_effect_size = pm.Deterministic(
            "diffDist250_500_effect_size", diffDist250_500 / np.sqrt((groupDist250_std**2 + groupDist500_std**2) / 2)
        )
        # diffDist250_750 = pm.Deterministic("diffDist250_750", groupDist250_mean - groupDist750_mean)
        # diffDist250_750_stds = pm.Deterministic("diffDist250_750_stds", groupDist250_std - groupDist750_std)
        # diffDist250_750_effect_size = pm.Deterministic(
        #     "diffDist250_750_effect_size", diffDist250_750 / np.sqrt((groupDist250_std**2 + groupDist750_std**2) / 2)
        # )
        diffDist250_1000 = pm.Deterministic("diffDist250_1000", groupDist250_mean - groupDist1000_mean)
        diffDist250_1000_stds = pm.Deterministic("diffDist250_1000_stds", groupDist250_std - groupDist1000_std)
        diffDist250_1000_effect_size = pm.Deterministic(
            "diffDist250_1000_effect_size", diffDist250_1000 / np.sqrt((groupDist250_std**2 + groupDist1000_std**2) / 2)
        )
        diffDist250_1250 = pm.Deterministic("diffDist250_1250", groupDist250_mean - groupDist1250_mean)
        diffDist250_1250_stds = pm.Deterministic("diffDist250_1250_stds", groupDist250_std - groupDist1250_std)
        diffDist250_1250_effect_size = pm.Deterministic(
            "diffDist250_1250_effect_size", diffDist250_1250 / np.sqrt((groupDist250_std**2 + groupDist1250_std**2) / 2)
        )
        # diffDist500_750 = pm.Deterministic("diffDist500_750", groupDist500_mean - groupDist750_mean)
        # diffDist500_750_stds = pm.Deterministic("diffDist500_750_stds", groupDist500_std - groupDist750_std)
        # diffDist500_750_effect_size = pm.Deterministic(
        #     "diffDist500_750_effect_size", diffDist500_750 / np.sqrt((groupDist500_std**2 + groupDist750_std**2) / 2)
        # )
        diffDist500_1000 = pm.Deterministic("diffDist500_1000", groupDist500_mean - groupDist1000_mean)
        diffDist500_1000_stds = pm.Deterministic("diffDist500_1000_stds", groupDist500_std - groupDist1000_std)
        diffDist500_1000_effect_size = pm.Deterministic(
            "diffDist500_1000_effect_size", diffDist500_1000 / np.sqrt((groupDist500_std**2 + groupDist1000_std**2) / 2)
        )
        diffDist500_1250 = pm.Deterministic("diffDist500_1250", groupDist500_mean - groupDist1250_mean)
        diffDist500_1250_stds = pm.Deterministic("diffDist500_1250_stds", groupDist500_std - groupDist1250_std)
        diffDist500_1250_effect_size = pm.Deterministic(
            "diffDist500_1250_effect_size", diffDist500_1250 / np.sqrt((groupDist500_std**2 + groupDist1250_std**2) / 2)
        )
        # diffDist750_1000 = pm.Deterministic("diffDist750_1000", groupDist750_mean - groupDist1000_mean)
        # diffDist750_1000_stds = pm.Deterministic("diffDist750_1000_stds", groupDist750_std - groupDist1000_std)
        # diffDist750_1000_effect_size = pm.Deterministic(
        #     "diffDist750_1000_effect_size", diffDist750_1000 / np.sqrt((groupDist750_std**2 + groupDist1000_std**2) / 2)
        # )
        # diffDist750_1250 = pm.Deterministic("diffDist750_1250", groupDist750_mean - groupDist1250_mean)
        # diffDist750_1250_stds = pm.Deterministic("diffDist750_1250_stds", groupDist750_std - groupDist1250_std)
        # diffDist750_1250_effect_size = pm.Deterministic(
        #     "diffDist750_1250_effect_size", diffDist750_1250 / np.sqrt((groupDist750_std**2 + groupDist1250_std**2) / 2)
        # )
        diffDist1000_1250 = pm.Deterministic("diffDist1000_1250", groupDist1000_mean - groupDist1250_mean)
        diffDist1000_1250_stds = pm.Deterministic("diffDist1000_1250_stds", groupDist1000_std - groupDist1250_std)
        diffDist1000_1250_effect_size = pm.Deterministic(
            "diffDist1000_1250_effect_size", diffDist1000_1250 / np.sqrt((groupDist1000_std**2 + groupDist1250_std**2) / 2)
        )
        # Now Stim Driven
        diffDistStim0_250 = pm.Deterministic("diffDistStim0_250", groupDistStim0_mean - groupDistStim250_mean)
        diffDistStim0_250_stds = pm.Deterministic("diffDistStim0_250_stds", groupDistStim0_std - groupDistStim250_std)
        diffDistStim0_250_effect_size = pm.Deterministic(
            "diffDistStim0_250_effect_size", diffDistStim0_250 / np.sqrt((groupDistStim0_std**2 + groupDistStim250_std**2) / 2)
        )
        # diffDistStim0_500 = pm.Deterministic("diffDistStim0_500", groupDistStim0_mean - groupDistStim500_mean)
        # diffDistStim0_500_stds = pm.Deterministic("diffDistStim0_500_stds", groupDistStim0_std - groupDistStim500_std)
        # diffDistStim0_500_effect_size = pm.Deterministic(
        #     "diffDistStim0_500_effect_size", diffDistStim0_500 / np.sqrt((groupDistStim0_std**2 + groupDistStim500_std**2) / 2)
        # )
        diffDistStim0_750 = pm.Deterministic("diffDistStim0_750", groupDistStim0_mean - groupDistStim750_mean)
        diffDistStim0_750_stds = pm.Deterministic("diffDistStim0_750_stds", groupDistStim0_std - groupDistStim750_std)
        diffDistStim0_750_effect_size = pm.Deterministic(
            "diffDistStim0_750_effect_size", diffDistStim0_750 / np.sqrt((groupDistStim0_std**2 + groupDistStim750_std**2) / 2)
        )
        diffDistStim0_1000 = pm.Deterministic("diffDistStim0_1000", groupDistStim0_mean - groupDistStim1000_mean)
        diffDistStim0_1000_stds = pm.Deterministic("diffDistStim0_1000_stds", groupDistStim0_std - groupDistStim1000_std)
        diffDistStim0_1000_effect_size = pm.Deterministic(
            "diffDistStim0_1000_effect_size", diffDistStim0_1000 / np.sqrt((groupDistStim0_std**2 + groupDistStim1000_std**2) / 2)
        )
        diffDistStim0_1250 = pm.Deterministic("diffDistStim0_1250", groupDistStim0_mean - groupDistStim1250_mean)
        diffDistStim0_1250_stds = pm.Deterministic("diffDistStim0_1250_stds", groupDistStim0_std - groupDistStim1250_std)
        diffDistStim0_1250_effect_size = pm.Deterministic(
            "diffDistStim0_1250_effect_size", diffDistStim0_1250 / np.sqrt((groupDistStim0_std**2 + groupDistStim1250_std**2) / 2)
        )
        # diffDistStim250_500 = pm.Deterministic("diffDistStim250_500", groupDistStim250_mean - groupDistStim500_mean)
        # diffDistStim250_500_stds = pm.Deterministic("diffDistStim250_500_stds", groupDistStim250_std - groupDistStim500_std)
        # diffDistStim250_500_effect_size = pm.Deterministic(
        #     "diffDistStim250_500_effect_size", diffDistStim250_500 / np.sqrt((groupDistStim250_std**2 + groupDistStim500_std**2) / 2)
        # )
        diffDistStim250_750 = pm.Deterministic("diffDistStim250_750", groupDistStim250_mean - groupDistStim750_mean)
        diffDistStim250_750_stds = pm.Deterministic("diffDistStim250_750_stds", groupDistStim250_std - groupDistStim750_std)
        diffDistStim250_750_effect_size = pm.Deterministic(
            "diffDistStim250_750_effect_size", diffDistStim250_750 / np.sqrt((groupDistStim250_std**2 + groupDistStim750_std**2) / 2)
        )
        diffDistStim250_1000 = pm.Deterministic("diffDistStim250_1000", groupDistStim250_mean - groupDistStim1000_mean)
        diffDistStim250_1000_stds = pm.Deterministic("diffDistStim250_1000_stds", groupDistStim250_std - groupDistStim1000_std)
        diffDistStim250_1000_effect_size = pm.Deterministic(
            "diffDistStim250_1000_effect_size", diffDistStim250_1000 / np.sqrt((groupDistStim250_std**2 + groupDistStim1000_std**2) / 2)
        )
        diffDistStim250_1250 = pm.Deterministic("diffDistStim250_1250", groupDistStim250_mean - groupDistStim1250_mean)
        diffDistStim250_1250_stds = pm.Deterministic("diffDistStim250_1250_stds", groupDistStim250_std - groupDistStim1250_std)
        diffDistStim250_1250_effect_size = pm.Deterministic(
            "diffDistStim250_1250_effect_size", diffDistStim250_1250 / np.sqrt((groupDistStim250_std**2 + groupDistStim1250_std**2) / 2)
        )
        # diffDistStim500_750 = pm.Deterministic("diffDistStim500_750", groupDistStim500_mean - groupDistStim750_mean)
        # diffDistStim500_750_stds = pm.Deterministic("diffDistStim500_750_stds", groupDistStim500_std - groupDistStim750_std)
        # diffDistStim500_750_effect_size = pm.Deterministic(
        #     "diffDistStim500_750_effect_size", diffDistStim500_750 / np.sqrt((groupDistStim500_std**2 + groupDistStim750_std**2) / 2)
        # )
        # diffDistStim500_1000 = pm.Deterministic("diffDistStim500_1000", groupDistStim500_mean - groupDistStim1000_mean)
        # diffDistStim500_1000_stds = pm.Deterministic("diffDistStim500_1000_stds", groupDistStim500_std - groupDistStim1000_std)
        # diffDistStim500_1000_effect_size = pm.Deterministic(
        #     "diffDistStim500_1000_effect_size", diffDistStim500_1000 / np.sqrt((groupDistStim500_std**2 + groupDistStim1000_std**2) / 2)
        # )
        # diffDistStim500_1250 = pm.Deterministic("diffDistStim500_1250", groupDistStim500_mean - groupDistStim1250_mean)
        # diffDistStim500_1250_stds = pm.Deterministic("diffDistStim500_1250_stds", groupDistStim500_std - groupDistStim1250_std)
        # diffDistStim500_1250_effect_size = pm.Deterministic(
        #     "diffDistStim500_1250_effect_size", diffDistStim500_1250 / np.sqrt((groupDistStim500_std**2 + groupDistStim1250_std**2) / 2)
        # )
        diffDistStim750_1000 = pm.Deterministic("diffDistStim750_1000", groupDistStim750_mean - groupDistStim1000_mean)
        diffDistStim750_1000_stds = pm.Deterministic("diffDistStim750_1000_stds", groupDistStim750_std - groupDistStim1000_std)
        diffDistStim750_1000_effect_size = pm.Deterministic(
            "diffDistStim750_1000_effect_size", diffDistStim750_1000 / np.sqrt((groupDistStim750_std**2 + groupDistStim1000_std**2) / 2)
        )
        diffDistStim750_1250 = pm.Deterministic("diffDistStim750_1250", groupDistStim750_mean - groupDistStim1250_mean)
        diffDistStim750_1250_stds = pm.Deterministic("diffDistStim750_1250_stds", groupDistStim750_std - groupDistStim1250_std)
        diffDistStim750_1250_effect_size = pm.Deterministic(
            "diffDistStim750_1250_effect_size", diffDistStim750_1250 / np.sqrt((groupDistStim750_std**2 + groupDistStim1250_std**2) / 2)
        )
        diffDistStim1000_1250 = pm.Deterministic("diffDistStim1000_1250", groupDistStim1000_mean - groupDistStim1250_mean)
        diffDistStim1000_1250_stds = pm.Deterministic("diffDistStim1000_1250_stds", groupDistStim1000_std - groupDistStim1250_std)
        diffDistStim1000_1250_effect_size = pm.Deterministic(
            "diffDistStim1000_1250_effect_size", diffDistStim1000_1250 / np.sqrt((groupDistStim1000_std**2 + groupDistStim1250_std**2) / 2)
        )
        diffDistStim1000_1500 = pm.Deterministic("diffDistStim1000_1500", groupDistStim1000_mean - groupDistStim1500_mean)
        diffDistStim1000_1500_stds = pm.Deterministic("diffDistStim1000_1500_stds", groupDistStim1000_std - groupDistStim1500_std)
        diffDistStim1000_1500_effect_size = pm.Deterministic(
            "diffDistStim1000_1500_effect_size", diffDistStim1000_1500 / np.sqrt((groupDistStim1000_std**2 + groupDistStim1500_std**2) / 2)
        )
        diffDistStim1250_1500 = pm.Deterministic("diffDistStim1250_1500", groupDistStim1250_mean - groupDistStim1500_mean)
        diffDistStim1250_1500_stds = pm.Deterministic("diffDistStim1250_1500_stds", groupDistStim1250_std - groupDistStim1500_std)
        diffDistStim1250_1500_effect_size = pm.Deterministic(
            "diffDistStim1250_1500_effect_size", diffDistStim1250_1500 / np.sqrt((groupDistStim1250_std**2 + groupDistStim1500_std**2) / 2)
        )
        # diffDistStim500_1500 = pm.Deterministic("diffDistStim500_1500", groupDistStim500_mean - groupDistStim1500_mean)
        # diffDistStim500_1500_stds = pm.Deterministic("diffDistStim500_1500_stds", groupDistStim500_std - groupDistStim1500_std)
        # diffDistStim500_1500_effect_size = pm.Deterministic(
        #     "diffDistStim500_1500_effect_size", diffDistStim500_1500 / np.sqrt((groupDistStim500_std**2 + groupDistStim1500_std**2) / 2)
        # )
        diffDistStim250_1500 = pm.Deterministic("diffDistStim250_1500", groupDistStim250_mean - groupDistStim1500_mean)
        diffDistStim250_1500_stds = pm.Deterministic("diffDistStim250_1500_stds", groupDistStim250_std - groupDistStim1500_std)
        diffDistStim250_1500_effect_size = pm.Deterministic(
            "diffDistStim250_1500_effect_size", diffDistStim250_1500 / np.sqrt((groupDistStim250_std**2 + groupDistStim1500_std**2) / 2)
        )
        diffDistStim0_1500 = pm.Deterministic("diffDistStim0_1500", groupDistStim0_mean - groupDistStim1500_mean)
        diffDistStim0_1500_stds = pm.Deterministic("diffDistStim0_1500_stds", groupDistStim0_std - groupDistStim1500_std)
        diffDistStim0_1500_effect_size = pm.Deterministic(
            "diffDistStim0_1500_effect_size", diffDistStim0_1500 / np.sqrt((groupDistStim0_std**2 + groupDistStim1500_std**2) / 2)
        )
        diffDistStim750_1500 = pm.Deterministic("diffDistStim750_1500", groupDistStim750_mean - groupDistStim1500_mean)
        diffDistStim750_1500_stds = pm.Deterministic("diffDistStim750_1500_stds", groupDistStim750_std - groupDistStim1500_std)
        diffDistStim750_1500_effect_size = pm.Deterministic(
            "diffDistStim750_1500_effect_size", diffDistStim750_1500 / np.sqrt((groupDistStim750_std**2 + groupDistStim1500_std**2) / 2)
        )
            #Sample and do inference
    with BEST:
        trace = pm.sample(numSamples, tune=numBurnIn, target_accept=0.95,chains = 4)

    #Plot the posteriors
    az.plot_posterior(
        trace,
        var_names=["diffDist0_250", "diffDist0_250_stds", "diffDist0_250_effect_size"],
        ref_val=0,
        color="#87ceeb",hdi_prob=0.95
    )
    az.plot_posterior(
        trace,
        var_names=["diffDist0_500", "diffDist0_500_stds", "diffDist0_500_effect_size"],
        ref_val=0,
        color="#87ceeb",hdi_prob=0.95
    )
    # az.plot_posterior(
    #     trace,
    #     var_names=["diffDist0_750", "diffDist0_750_stds", "diffDist0_750_effect_size"],
    #     ref_val=0,
    #     color="#87ceeb",
    # )
    az.plot_posterior(
        trace,
        var_names=["diffDist0_1000", "diffDist0_1000_stds", "diffDist0_1000_effect_size"],
        ref_val=0,
        color="#87ceeb",hdi_prob=0.95
    )
    az.plot_posterior(
        trace,
        var_names=["diffDist0_1250", "diffDist0_1250_stds", "diffDist0_1250_effect_size"],
        ref_val=0,
        color="#87ceeb",hdi_prob=0.95
    )
    az.plot_posterior(
        trace,
        var_names=["diffDist250_500", "diffDist250_500_stds", "diffDist250_500_effect_size"],
        ref_val=0,
        color="#87ceeb",hdi_prob=0.95
    )
    # az.plot_posterior(
    #     trace,
    #     var_names=["diffDist250_750", "diffDist250_750_stds", "diffDist250_750_effect_size"],
    #     ref_val=0,
    #     color="#87ceeb",
    # )
    az.plot_posterior(
        trace,
        var_names=["diffDist250_1000", "diffDist250_1000_stds", "diffDist250_1000_effect_size"],
        ref_val=0,
        color="#87ceeb",hdi_prob=0.95
    )
    az.plot_posterior(
        trace,
        var_names=["diffDist250_1250", "diffDist250_1250_stds", "diffDist250_1250_effect_size"],
        ref_val=0,
        color="#87ceeb",hdi_prob=0.95
    )
    # az.plot_posterior(
    #     trace,
    #     var_names=["diffDist500_750", "diffDist500_750_stds", "diffDist500_750_effect_size"],
    #     ref_val=0,
    #     color="#87ceeb",
    # )
    az.plot_posterior(
        trace,
        var_names=["diffDist500_1000", "diffDist500_1000_stds", "diffDist500_1000_effect_size"],
        ref_val=0,
        color="#87ceeb",hdi_prob=0.95
    )
    az.plot_posterior(
        trace,
        var_names=["diffDist500_1250", "diffDist500_1250_stds", "diffDist500_1250_effect_size"],
        ref_val=0,
        color="#87ceeb",hdi_prob=0.95
    )
    # az.plot_posterior(
    #     trace,
    #     var_names=["diffDist750_1000", "diffDist750_1000_stds", "diffDist750_1000_effect_size"],
    #     ref_val=0,
    #     color="#87ceeb",
    # )
    # az.plot_posterior(
    #     trace,
    #     var_names=["diffDist750_1250", "diffDist750_1250_stds", "diffDist750_1250_effect_size"],
    #     ref_val=0,
    #     color="#87ceeb",
    # )
    az.plot_posterior(
        trace,
        var_names=["diffDistStim0_250", "diffDistStim0_250_stds", "diffDistStim0_250_effect_size"],
        ref_val=0,
        color="#87ceeb",hdi_prob=0.95
    )
    az.plot_posterior(
        trace,
        var_names=["diffDistStim0_750", "diffDistStim0_750_stds", "diffDistStim0_750_effect_size"],
        ref_val=0,
        color="#87ceeb",hdi_prob=0.95
    )
    az.plot_posterior(
        trace,
        var_names=["diffDistStim0_1000", "diffDistStim0_1000_stds", "diffDistStim0_1000_effect_size"],
        ref_val=0,
        color="#87ceeb",hdi_prob=0.95
    )
    az.plot_posterior(
        trace,
        var_names=["diffDistStim0_1250", "diffDistStim0_1250_stds", "diffDistStim0_1250_effect_size"],
        ref_val=0,
        color="#87ceeb",hdi_prob=0.95
    )
    az.plot_posterior(
        trace,
        var_names=["diffDistStim0_1500", "diffDistStim0_1500_stds", "diffDistStim0_1500_effect_size"],
        ref_val=0,
        color="#87ceeb",hdi_prob=0.95
    )
    az.plot_posterior(
        trace,
        var_names=["diffDistStim250_750", "diffDistStim250_750_stds", "diffDistStim250_750_effect_size"],
        ref_val=0,
        color="#87ceeb",hdi_prob=0.95
    )
    az.plot_posterior(
        trace,
        var_names=["diffDistStim250_1000", "diffDistStim250_1000_stds", "diffDistStim250_1000_effect_size"],
        ref_val=0,
        color="#87ceeb",hdi_prob=0.95
    )
    az.plot_posterior(
        trace,
        var_names=["diffDistStim250_1250", "diffDistStim250_1250_stds", "diffDistStim250_1250_effect_size"],
        ref_val=0,
        color="#87ceeb",hdi_prob=0.95
    )
    az.plot_posterior(
        trace,
        var_names=["diffDistStim250_1500", "diffDistStim250_1500_stds", "diffDistStim250_1500_effect_size"],
        ref_val=0,
        color="#87ceeb",hdi_prob=0.95
    )
    az.plot_posterior(
        trace,
        var_names=["diffDistStim750_1000", "diffDistStim750_1000_stds", "diffDistStim750_1000_effect_size"],
        ref_val=0,
        color="#87ceeb",hdi_prob=0.95
    )
    az.plot_posterior(
        trace,
        var_names=["diffDistStim750_1250", "diffDistStim750_1250_stds", "diffDistStim750_1250_effect_size"],
        ref_val=0,
        color="#87ceeb",hdi_prob=0.95
    )
    az.plot_posterior(
        trace,
        var_names=["diffDistStim750_1500", "diffDistStim750_1500_stds", "diffDistStim750_1500_effect_size"],
        ref_val=0,
        color="#87ceeb",hdi_prob=0.95
    )
    az.plot_posterior(
        trace,
        var_names=["diffDistStim1000_1250", "diffDistStim1000_1250_stds", "diffDistStim1000_1250_effect_size"],
        ref_val=0,
        color="#87ceeb",hdi_prob=0.95
    )
    az.plot_posterior(
        trace,
        var_names=["diffDistStim1000_1500", "diffDistStim1000_1500_stds", "diffDistStim1000_1500_effect_size"],
        ref_val=0,
        color="#87ceeb",hdi_prob=0.95
    )
    az.plot_posterior(
        trace,
        var_names=["diffDistStim1250_1500", "diffDistStim1250_1500_stds", "diffDistStim1250_1500_effect_size"],
        ref_val=0,
        color="#87ceeb",hdi_prob=0.95
    )
    plt.show()
    pdb.set_trace()
