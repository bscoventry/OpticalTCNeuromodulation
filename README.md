# Characterization and closed-loop control of infrared thalamocortical stimulation produces spatially constrained single-unit responses
Source code for Coventry et al Characterization and closed-loop control of infrared thalamocortical stimulation produces spatially constrained single-unit responses. This repository includes all source code for Neural Analysis in both Matlab and Python. https://academic.oup.com/pnasnexus/article/3/2/pgae082/7612543?searchresult=1

# Use
If any code from this repository is used, we kindly ask that this paper is cited: https://academic.oup.com/pnasnexus/article/3/2/pgae082/7612543?searchresult=1

# Bayesian Statistics
To run the Bayesian Inference programs, it is suggested to create a anaconda environment running Python 3.9 (tested version). Other python versions >= 3.6 should work, but not guarenteed. All packages listed in the requirements file should be installed. For each program, ensure specified data file (ie INS_statTable_MKV.csv for Bayesian Heirarchical Linear Regression) is loaded from the current working directory (ie data = pd.read_csv(...)). Running the program will automatically produce posterior plots and decision markers in the form of 95% credible regions. In an anaconda environment, code can be run as:
```
>>>python HeirarchicalLinearRegression_Bayesian.py
```
