import numpy as np
from random import shuffle

class adaptive_learning_test():

    def __init__(self):

        self.Q1 = """
        What is the hypotenuse of a right angled triangle?
            A. The longest edge
            B. The smalled angle
            C. The shortest edge
            D. The area of the triangle
            """

        self.Q2 = """
        What is the area of a circle of radius 1?
            A. 2π
            B. 0.5π
            C. π
            D. π^2
            """

        self.Q3 = """
        Which is largest?
            A. π
            B. √10
            C. 1.8^2
            D. e
            """

        self.answer_letter_to_question_dict = {'A': 'The longest edge',
                                               'B': 'The smalled angle',
                                               'C': 'The shortest edge',
                                               'D': 'The area of the triangle'}

        self.question_answers = {'Q1': 'A',
                                 'Q2': 'C',
                                 'Q3': 'B'}

        self.question_answers_text = {'Q1': 'The longest edge',
                                      'Q2': 'π',
                                      'Q3': '√10'}

        self.question_ids = {'Q1': 0,
                             'Q2': 1,
                             'Q3': 2}

        self.question_names = ['Q1', 'Q2', 'Q3']
        self.question_dict = {'Q1': self.Q1,
                              'Q2': self.Q2,
                              'Q3': self.Q3}

        self.total_correct_answers = 2
        self.correct_answers = np.array([0, 0, 0])
        self.remaining_correct_answers = self.total_correct_answers - self.correct_answers
        self.p = self.remaining_correct_answers / np.sum(self.remaining_correct_answers)

        self.answer_options = {}
        self.questions_blank_answers = {}
        for question_name in self.question_names:
            self.get_multi_choice_options(question_name)

    def update_correct_answers(self, question_name):
        self.correct_answers[self.question_ids[question_name]] += 1
        self.remaining_correct_answers = self.total_correct_answers - self.correct_answers

        if np.sum(self.remaining_correct_answers) > 0:
            self.p = self.remaining_correct_answers / np.sum(self.remaining_correct_answers)

    def choose_a_question(self):
        return np.random.choice(a=self.question_names, p=self.p)

    def get_a_question_text(self, question_name):
        return self.question_dict[question_name]

    def get_multi_choice_options(self, question_name):
        question_lines = [line for line in self.question_dict[question_name].split('\n') if line != '']

        self.answer_options[question_name] = [line.strip()[3:] for line in question_lines[1:] if line.strip() != '']
        self.questions_blank_answers[question_name] = self.question_dict[question_name]

        question_letters = ['A', 'B', 'C', 'D']
        for option_id, option_text in enumerate(self.answer_options[question_name]):
            self.questions_blank_answers[question_name] = self.questions_blank_answers[question_name].replace(
                question_letters[option_id] + '. ' + option_text,
                question_letters[option_id] + '. ' + f'option{option_id}')

    def get_question_with_shuffle_answers(self, question_name):
        options = self.answer_options[question_name]
        shuffle(options)

        random_question_text = self.questions_blank_answers[question_name]

        for option_id, option_text in enumerate(options):
            random_question_text = random_question_text.replace(f"option{option_id}", option_text)

        return random_question_text