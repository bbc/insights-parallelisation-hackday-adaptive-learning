from phonics_MCMC_simulator import phonics_MCMC_simulator
from argparse import ArgumentParser, RawTextHelpFormatter
import time


def main():
    parser = ArgumentParser(formatter_class=RawTextHelpFormatter)
    parser.add_argument(
        '--number_of_trials',
        default = 1000,
        help="""number of trials to perform in MCMC simulator"""
    )
    args = parser.parse_args()
    tic = time.time()
    phonics_MCMC_simulator(number_of_trials = int(args.number_of_trials))

if __name__ == "__main__":
    main()
