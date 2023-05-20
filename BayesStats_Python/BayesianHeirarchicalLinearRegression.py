#------------------------------------------------------------------------------------------------------------------------
#Author: Brandon S Coventry
# Date: 05/04/22 May the 4th be with you
# Purpose: This easily conducts a heirarchical bayesian linear regression. The goal of this program is to be more "plug
#  and play" where data is specified. This should also be modifyable to include preprocessing functions in case any
#  extra data analyses need to be done.
# Revision History: Based on Code I used for my dissertation. This is the release version
# Dependencies: Generally PyMC3. Need to update to PyMC, but am waiting till a full release. All other dependencies are
# PyMC3 dependencies.
# References: Gelman et al, 2021: http://www.stat.columbia.edu/~gelman/book/BDA3.pdf
#              Betancourt & Girolami (2013) https://arxiv.org/pdf/1312.0906.pdf
#------------------------------------------------------------------------------------------------------------------------
""" Imports Section """
import arviz as az
import matplotlib.pyplot as plt
import numpy as np
import pandas as pd
import pymc3 as pm
import theano
import matplotlib.pyplot as plt
import pdb
from mpl_toolkits.mplot3d import Axes3D
#Import preprocessing function
from MUAPreprocessing import MUAPreprocessing
"""if main statement is necessary in windows if using parallel threads, not necessary in iOS and Linux"""
"""Setup Data Space"""
if __name__ == '__main__':
    #Specify what dataset you'd like to load
    dataset = "sampleNeuralData.csv"
    #Other control variables, tune based on model
    numMCMCSamples = 2000#5000           #Markov Chain Monte Carlo Sample number
    numMCMCBurnIn = 2000#5000            #MCMC burn in samples
    numChains = 2                        #Number of MCMC chains to run. More is better for validation, but computation time increases dramatically as it increases. I find 4 to be a reasonable tradeoff.
    cores = 1                            #Parallel processes in nuts sampler. Only speeds up computation, doesn't affect results.
    targetAcceptProbability = 0.95        #This steers MCMC to create distributions with accept probabilities of >= this value. Set between 0 and 1. Higher values lead to smaller MCMC step sizes, and better deal with difficult posteriors
    postPointEst = 'median'         #Can be 'median' or 'mode'
    showDataFlag = 1                #Set to 0 if you do not want to see a scatter plot of data
    """Data handling happens here!"""
    print(f"Running on PyMC3 v{pm.__version__}")
    color = '#87ceeb'        #Plot color configurations
    az.style.use("arviz-darkgrid")
    dataFull = pd.read_csv(dataset)          #Use pandas to read in CSV file. Change this if using other data file structures
    #[predictor,data,idx_predictor,n_groups_size] = dataPreprocessing(dataFull)            # Optional, use this to write a function to select predictor and response variables
    [predictor,data,idx_predictor,n_groups_size] = MUAPreprocessing(dataFull)
    data = data.astype(theano.config.floatX)
    
    if showDataFlag == 1:
        plt.figure()
        plt.scatter(predictor,data)
        plt.show()
    """Create the Model Here"""
    with pm.Model() as hierarchical_model:
        """
        Hyperpriors have a normal distrubtion on mean with a half normal (no negative variances) on variance
        """
        # Hyperpriors for group nodes
        mu_a = pm.Normal("mu_a", mu=0.0, sigma=1)
        sigma_a = pm.HalfNormal("sigma_a", 10.0)          #Larger variances here to make this relatively noninformative. However, slightly informative priors always give better results than non-informative.
        mu_b = pm.Normal("mu_b", mu=0.0, sigma=1)         #The intuition of these large variances is that we bound less likely events with a non-zero, but very low probability.
        sigma_b = pm.HalfNormal("sigma_b", 10.0)
        
        sigma_nu = pm.HalfNormal("sigma_nu",5.0)
        #Prior Distributions
        # Transformed: transformation with deterministic doesn't intrinsically change the model, but makes sampling in MCMC a bit easier. Betancourt & Girolami (2013)
        nu = pm.Exponential('nu', sigma_nu)
        a_offset = pm.Normal('a_offset', mu=0, sd=1, shape=(n_groups_size))
        a = pm.Deterministic("a", mu_a + a_offset * sigma_a)
        # Intercept for each county, distributed around group mean mu_a
        #b = pm.Normal("b", mu=mu_b, sigma=sigma_b, shape=n_counties)
        b_offset = pm.Normal('b_offset', mu=0, sd=1, shape=(n_groups_size))
        b = pm.Deterministic("b", mu_b + b_offset * sigma_b)
        
        #Likelihood and Model Error
        #Model error
        eps = pm.HalfCauchy("eps", 5.0)
        
        regressionFunction = a[idx_predictor] + b[idx_predictor] * predictor
        
        # Data likelihood
        #Note here, we employ robust regression by using a Student T distribution. Normal regression would use normal. See Gelman et al 2021 for reasons why
        likelihood = pm.StudentT("likelihood",nu=nu, mu=regressionFunction, sigma=eps, observed= data)
    """Run the Model!"""
    with hierarchical_model:
        if __name__ == '__main__':
                step = pm.NUTS()
                hierarchical_trace = pm.sample(numMCMCSamples, tune=numMCMCBurnIn, target_accept=targetAcceptProbability,chains = numChains,cores = 1)
    
    """Now time to plot our results. First start with the Posterior"""
    #Regressions from Posterior
    xval = np.arange(0.5,5)            #Set the range of xAxis
    fig, axis = plt.subplots(1, 1, figsize=(12, 6), sharey=True, sharex=True)
    for ck in range(len(idx_predictor)):
        axis.plot(
            xval,
            hierarchical_trace["a"][ck].mean() + hierarchical_trace["b"][ck].mean() * xval,
            "g",
            alpha=1,
            lw=2.0,
        )
    plt.scatter(predictor,data)
    #Now for Posterior descriptor plots
    intercept = hierarchical_trace['a']
    Energies = hierarchical_trace['b']
    scale = hierarchical_trace['eps']
    f_dict = {'size':16}
    fig, ([ax1, ax2, ax3], [ax4, ax5, ax6]) = plt.subplots(2,3, figsize=(12,6))
    for ax, estimate, title, xlabel in zip(fig.axes,
                                [intercept, Energies, scale],
                                ['Intercept', 'Predictor','Scale'],
                                [r'$a$', r'$\beta$', r'$eps$']):
        pm.plot_posterior(estimate, point_estimate=postPointEst, ax=ax, color=color,hdi_prob=0.95)
        ax.set_title(title, fontdict=f_dict)
        ax.set_xlabel(xlabel, fontdict=f_dict)
    
    pm.traceplot(hierarchical_trace, var_names=["a"])
    
    pm.traceplot(hierarchical_trace, var_names=["b"])

    #Prior plots
    pm.traceplot(hierarchical_trace, var_names=["mu_a", "mu_b", "sigma_a", "sigma_b", "eps"])
    plt.show()
    pdb.set_trace()