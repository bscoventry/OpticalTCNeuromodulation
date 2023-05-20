#------------------------------------------------------------------------------------------------------------------------------------------------
# Author: Brandon S Coventry             Date: 4/14/21           Refactor from previous INS Bayesian Linear Regression
# Purpose: Bayesian partial-pooled linear regression models for INS studies
# Revision History: N/A
#------------------------------------------------------------------------------------------------------------------------------------------------
import arviz as az
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import pymc3 as pm
import theano
import matplotlib.pyplot as plt
import pdb
from mpl_toolkits.mplot3d import Axes3D
import json
import pickle # python3
import seaborn as sns
if __name__ == '__main__':
    print(f"Running on PyMC3 v{pm.__version__}")
    color = '#87ceeb'
    az.style.use("arviz-darkgrid")
    #data = pd.read_csv('https://github.com/pymc-devs/pymc3/raw/master/pymc3/examples/data/radon.csv')
    
    data = pd.read_csv("INS_statTable.csv")
    classes = pd.read_csv('INS_statTable_MKIV_UseForClasses.csv')
    data['classes'] = classes['Class']
    data1 = data.loc[data['Is_Responsive'] == 1]
    data1.reset_index(drop=True, inplace = True)
    data2 = data1.loc[data1['Number_of_Pulses']>1]
    data2.reset_index(drop=True, inplace = True)
    
    data3 = data2.loc[data2['Max_Z_Score']>0]
    data3.reset_index(drop=True, inplace = True)
    #data4 = data3.loc[data3['Max_Z_Score']>0]
    #data4.reset_index(drop=True, inplace = True)
    #data4 = data3.loc[data3['Max_Z_Score']<=20]
    #data4.reset_index(drop=True, inplace = True)
    data4 = data3.loc[data3['classes']!='NR']
    data4.reset_index(drop=True, inplace = True)

    data = data4

    response_class = data["classes"]
    classes = ['offset','OnSus+ inhib','OnSus','Sus+inhib','Sus','Onset','Onset+ inhib']
    classVec = np.zeros((len(response_class),))
    missedClass = []
    for ck in range(len(response_class)):
        curResp = response_class[ck]
        if curResp == classes[0]:
            classVec[ck] = 0
        elif curResp == classes[1]:
            classVec[ck] = 1
        elif curResp == classes[2]:
            classVec[ck] = 2
        elif curResp == classes[3]:
            classVec[ck] = 3
        elif curResp == classes[4]:
            classVec[ck] = 4
        elif curResp == classes[5]:
            classVec[ck] = 5
        elif curResp == classes[6]:
            classVec[ck] = 6
        else:
            missedClass.append(curResp)
    #MaxZ = np.log(MaxZ+1)
    
    
    # data.reset_index(inplace = True)
    # data = data.loc[data['ISI'] < 50]
    # data.reset_index(inplace = True)
    # pdb.set_trace()
    #data = data.iloc[1:5000,:]
    # Model for Max firing Rate
    RANDOM_SEED = 7
    # animal_codes = np.unique(data.animal_code)
    # animal_codes_map = np.arange(0,len(animal_codes))
    # newCodes = np.zeros((len(data.animal_code)),dtype=int)
    # for ck in range(len(data.animal_code)):
    #     curCode = data.animal_code[ck]
    #     newCode = np.where(curCode == animal_codes)
    #     newCode = newCode[0][0]
    #     newCodes[ck] = int(newCode)
    # data.animal_code = newCodes
    # animal_code_idx = data.animal_code.values
    XDist = data.ISI.values
    XDist = np.log(XDist+1)
    XPW = data.Pulse_Width.values
    Xenergy = data.Energy.values
    lenData = len(Xenergy)
    XenergyPerPulse = np.zeros((lenData,))
    for ck in range(lenData):
        
        XenergyPerPulse[ck] = Xenergy[ck]/XPW[ck]
        if XenergyPerPulse[ck] < 0:
            XenergyPerPulse[ck] = 0
    XenergyPerPulse = np.log(XenergyPerPulse+1)
    Xenergy = np.log(data.Energy.values+1)
    
    #Xenergy1 = data1.Energy.values
    #Xenergy0 = data0.Energy.values
    n_cat = len(classes)
    X = [Xenergy,XDist]
    zX_dim =np.shape(X)[1]
    #plt.zlabel('Z_Score')
    
    
    #Okay, let's create our model.
    with pm.Model() as MultiNomClass:
        beta = pm.Normal('beta', mu=0, sigma=1, shape=(2,n_cat))
        beta2 = pm.Normal('beta2', mu=0, sigma=1, shape=(2,n_cat))
        alpha = pm.Normal('alpha', mu=0, sigma=1, shape=n_cat)
        mu = alpha + pm.math.dot(X, beta)
        softMax = pm.Deterministic('softMax', theano.tensor.nnet.softmax(mu))
        classPred = pm.Categorical('classPred', p=softMax, observed=classVec)
    
    with MultiNomClass:
        if __name__ == '__main__':
                step = pm.NUTS()
                trace = pm.sample(5000, tune=5000, target_accept=0.95,chains = 4)
    pm.traceplot(trace, var_names=["alpha"])
    
    pm.traceplot(trace, var_names=["beta1"])

    pm.traceplot(trace, var_names=["beta2"])

    pdb.set_trace()
    az.to_netcdf(trace,filename='Multinom_Var1_Semilog.netcdf')