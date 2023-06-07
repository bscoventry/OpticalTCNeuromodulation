#------------------------------------------------------------------------------------------------------------------------
#Author: Brandon S Coventry
# Date: 08/23/2022
# Purpose: This program is a modified port of my previous Model Comparisons, updated for pymc (v4)
# Revision History: Based on Code I used for my dissertation. This is the release version
# Dependencies: PyMC as well as all PyMC dependencies.
# References: Gelman et al, 2021: http://www.stat.columbia.edu/~gelman/book/BDA3.pdf
#             Kruske Doing Bayesian Data Analysis Text
#              Betancourt & Girolami (2013) https://arxiv.org/pdf/1312.0906.pdf
#------------------------------------------------------------------------------------------------------------------------
import arviz as az
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import pymc as pm
import aesara
import matplotlib.pyplot as plt
import pdb
az.style.use("arviz-darkgrid")
if __name__ == '__main__':
    tStudT1Log = az.from_netcdf('HierModel_Var1_StudT_PerPulseScaled.netcdf')
    tStudT0_5Log = az.from_netcdf('HierModel_Var0_5_StudT_PerPulseScaled.netcdf')
    tStudT5Log = az.from_netcdf('HierModel_Var5_StudentT_PerPulseScaled_SemilogT.netcdf')
    tStudT10Log = az.from_netcdf('HierModel_Var10_StudT_PerPulseScaled.netcdf')
    tStudT25Log = az.from_netcdf('HierModel_Var25_StudT_PerPulseScaled.netcdf')
    tStudT100Log = az.from_netcdf('HierModel_Var100_StudT_PerPulseScaled.netcdf')
    tStudT1SemiLog = az.from_netcdf('HierModel_Var1_StudentT_PerPulseScaled_Semilog.netcdf')
    tStudT0_5SemiLog = az.from_netcdf('HierModel_Var0_5_StudentT_PerPulseScaled_Semilog.netcdf')
    tStudT5SemiLog = az.from_netcdf('HierModel_Var5_StudentT_PerPulseScaled_Semilog.netcdf')
    tStudT10SemiLog = az.from_netcdf('HierModel_Var10_StudentT_PerPulseScaled_Semilog.netcdf')
    tNorm1 = az.from_netcdf('HierModel_Var1_Normal_PerPulseScaled_Nonlog.netcdf')
    tNorm0_5 = az.from_netcdf('HierModel_Var0_5_Normal_PerPulseScaled_Nonlog.netcdf')
    tNorm10 = az.from_netcdf('HierModel_Var10_Normal_PerPulseScaled_Nonlog.netcdf')
    tStudT0_5 = az.from_netcdf('HierModel_Var0_5_StudT_PerPulseScaled_Nonlog.netcdf')
    tStudT1 = az.from_netcdf('HierModel_Var1_StudT_PerPulseScaled_Nonlog.netcdf')
    tStudT5 = az.from_netcdf('HierModel_Var1_StudT_PerPulseScaled_Nonlog.netcdf')
    tNorm1Log = az.from_netcdf('HierModel_Var1_Normal_PerPulseScaled.netcdf')
    tNorm10Log = az.from_netcdf('HierModel_Var10_Normal_PerPulseScaled.netcdf')
    tNorm5Log = az.from_netcdf('HierModel_Var5_Normal_PerPulseScaled.netcdf')
    tNorm0_5Log = az.from_netcdf('HierModel_Var0_5_Normal_PerPulseScaled.netcdf')
    
    compareDictionary = {"StudentT_1": tStudT1,"StudentT_0_5":tStudT0_5,"StudentT5":tStudT0_5,"Normal_1":tNorm1,"Normal_0_5":tNorm0_5,"Normal_10":tNorm10,"Normal_Log_1":tNorm1Log,"Normal_Log_10":tNorm10Log,"StudentT_Log_1":tStudT1Log,"StudentT_Log_0_5":tStudT0_5Log,"StudentT_Log_10":tStudT10Log,"StudentT_Log_5":tStudT5Log,"StudentT_Log_25":tStudT25Log,"StudentT_Log_100":tStudT100Log,"StudentT_Semilog_1":tStudT1SemiLog,"StudentT_Semilog_10":tStudT10SemiLog,"StudentT_Semilog_0_5":tStudT0_5SemiLog,"StudentT_Semilog_5":tStudT5SemiLog,"Normal_Log_5":tNorm5Log,"Normal_Log_0_5":tNorm0_5Log}
    compareFrame = az.compare(compareDictionary,method='BB-pseudo-BMA',ic = 'loo',alpha=1)
    az.plot_compare(compareFrame)
    az.plot_energy(tStudT5Log,bfmi=0)
    az.summary(tStudT5Log)
    plt.show()
    pdb.set_trace()