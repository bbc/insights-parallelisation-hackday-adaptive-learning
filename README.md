# adaptive-learning-model
An adaptive learning model for Bitesize to possibly replace Cerego with something built in-house

## How to Run
In ther terminal cd into the src folder and then type the following
```
python adaptive-learn.py
```
...and enjoy!

# generate_phonics_data.p
Used to simulate users playing the phonics tests - We don't have nearly enough data to give good coverage of all possible versions of the tests (~650m possible combinations in the multiple choice test). We use aggregated level stats for how frequently a question is answered incorrectly and assume that this is independent of the other 3 words chosen. 

## How to Run
In ther terminal cd into the src folder and then type the following
```
python generate_phonics_data.py --number_of_trials 1000 --n_jobs 2
```
number_of_trials: number of questions that we are simulating
n_jobs: number of cores to parallelise over

## Output
The output of the simulation is saved in a csv in the data folder: 
```
phonics_MCMC_simulation_data_{int(np.round(time.time(), 0))}.csv 
```
Note that this does not overwrite previous simulations but creates a new file. Therefore, make sure you delete data files if you don't need them.
