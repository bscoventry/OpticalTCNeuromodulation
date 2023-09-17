import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
import pymc as pm
import aesara.tensor as tt
import warnings
import pdb
warnings.filterwarnings("ignore", category=FutureWarning)
import arviz as az
from scipy.special import expit
from matplotlib import gridspec
from IPython.display import Image
plt.style.use('seaborn-white')

color = '#87ceeb'
if __name__ == '__main__':
    f_dict = {'size':16}
    df1 = pd.read_csv('INS_statTable_MKVII_UseForClasses.csv', dtype={'ClassVar':'category'})
    #df1['Xenergy'] = np.log(df1['Xenergy']+0.1)
    #df1['XISI'] = np.log(df1['XISI']+0.1)
    X = df1[['Xenergy', 'XISI']]
    meanx = X.mean().values
    scalex = X.std().values
    zX = ((X-meanx)/scalex).values
    
    # Number of categories
    n_cat = df1.ClassVar.cat.categories.size
    # Number of dimensions for X
    zX_dim =zX.shape[1]
    
    with pm.Model() as model_softmax:
        # priors for categories 2-4, excluding reference category 1 which is set to zero below.
        zbeta0_ = pm.Normal('zbeta0_', mu=0, sigma=1, shape=n_cat-1)
        zbeta_ = pm.Normal('zbeta_', mu=0, sigma = 1, shape=(zX_dim, n_cat-1))
        
        # add prior values zero (intercept, predictors) for reference category 1.
        zbeta0 = pm.Deterministic('zbeta0', tt.concatenate([[0], zbeta0_]))
        zbeta = pm.Deterministic('zbeta', tt.concatenate([tt.zeros((2, 1)), zbeta_], axis=1))

        mu = zbeta0 + pm.math.dot(zX, zbeta)
        
        # Theano softmax function
        p = pm.Deterministic('p', tt.nnet.basic.softmax(mu))
        
        y = pm.Categorical('y', p=p, observed=df1.ClassVar.cat.codes.values)

    pm.model_to_graphviz(model_softmax)
    pdb.set_trace()
    with model_softmax:
        if __name__ == '__main__':
            trace1 = pm.sample(5000, tune=5000, target_accept=0.995,chains = 4)
    
    az.plot_trace(trace1, ['zbeta0', 'zbeta'])
    with model_softmax:
        if __name__ == '__main__':
            ppc = pm.sample_posterior_predictive(trace1, random_seed=7)
    az.to_netcdf(trace1,filename='MultiNomModel_Var1_MKIII.netcdf')
    az.to_netcdf(ppc,filename='MultiNomModel_Var1_ppc_MKIII.netcdf')
    pdb.set_trace()
    zbeta0 = trace1.posterior['zbeta0_']
    zbeta = trace1.posterior['zbeta_']
    
    beta0 = zbeta0 - np.sum(zbeta*(np.tile(meanx, (n_cat,1))/np.tile(scalex, (n_cat,1))).T, axis=1)
    beta = np.divide(zbeta, np.tile(scalex, (n_cat,1)).T)
    estimates1 = np.insert(beta, 0, beta0, axis=1)
    plt.figure(figsize=(15,15))
    for outcome in df1.ClassVar.cat.categories:
        plt.scatter(df1[df1.ClassVar == outcome].Xenergy, df1[df1.ClassVar == outcome].XISI, s=100, marker='${}$'.format(outcome))
    plt.xlabel('$Energy$')
    plt.ylabel('$ISI$')
    
    plt.gca().set_aspect('equal')
    pdb.set_trace()
