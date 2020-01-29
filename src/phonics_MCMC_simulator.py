import numpy as np
import time
import pandas as pd
from joblib import parallel_backend
from joblib import Parallel, delayed
import tqdm

class phonics_MCMC_simulator():

    def __init__(self, number_of_trials, n_jobs = 1):

        self.number_of_trials = number_of_trials
        self.n_jobs = n_jobs

        print("loading data files...")
        self.df_wrong_probs = self.load_data('../data/wrong_probs.csv')
        self.df_correct_probs = self.load_data('../data/correct_probs.csv')
        self.df_question_probs = self.load_data('../data/question_probs.csv')

        print("simulating...")
        self.generate_phonics_test_data()

        print("saving output...")
        self._dump_data()

    def _dump_data(self):
        self.dfT.to_csv(f'../data/phonics_MCMC_simulation_data_{int(np.round(time.time(), 0))}.csv', index = False)

    def load_data(self, file):
        """ Simple function to load data straight from a table in redshift or a csv """

        if file[-4:] == '.csv':
            return pd.read_csv(file)
        else:
            raise ValueError(f"file {file} not a csv")

    def generate_phonics_test_data(self):

        self.dfT = self._generate_phonics_test_data(self.number_of_trials)

    def _choose_a_question(self):
        p = self.df_question_probs['prob_of_showing']
        return np.random.choice(a=self.df_question_probs['answer'],
                                p=p / np.sum(p))

    def _was_it_answerred_correctly(self, question):
        p = float(self.df_correct_probs.loc[self.df_correct_probs['correct_answer'] == question, '% correct']) / 100
        return np.random.choice([True, False], p=[p, 1 - p])

    def _choose_3_other_options(self):
        p = self.df_wrong_probs.loc[self.df_wrong_probs['is_wrong'], 'prob_of_showing'].values
        return list(np.random.choice(a=list(self.df_wrong_probs.loc[self.df_wrong_probs['is_wrong'], 'answer']),
                                     p=p / np.sum(p),
                                     size=3))

    def _choose_incorrect_answer(self, wrong_options):
        dfp = self.df_wrong_probs.loc[self.df_wrong_probs['answer'].isin(wrong_options),
                                      ['answer', '% wrong']]
        p = dfp['% wrong'].values
        return np.random.choice(a=dfp['answer'], p=p / np.sum(p))

    def _get_an_answer(question):
        if self._was_it_answerred_correctly(self, question):
            return question
        else:
            wrong_options = self._choose_3_other_options()
            return self._choose_incorrect_answer(wrong_options)

    def _generate_single_phonics_test_data(self):

        question = self._choose_a_question()
        wrong_options = self._choose_3_other_options()

        if self._was_it_answerred_correctly(question):
            answer = question
        else:
            answer = self._choose_incorrect_answer(wrong_options)

        self.progress.update(1)
        return [question] + wrong_options + [answer]


    def _generate_phonics_test_data(self, number_of_trials):

        tic = time.time()

        with tqdm.tqdm(total=number_of_trials) as self.progress:
            with parallel_backend('threading', n_jobs=self.n_jobs):
                parallel_output = Parallel()(
                    delayed(self._generate_single_phonics_test_data)() for i in range(number_of_trials))

        df = pd.DataFrame(columns=[f'option{i}' for i in range(1, 5)] + ['answer'],
                          index=range(number_of_trials),
                          data=parallel_output)

        print(f"Took {np.round(time.time() - tic,3)} seconds running {number_of_trials} trials across {self.n_jobs} cores")

        return df