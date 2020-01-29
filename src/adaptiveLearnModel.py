import numpy as np
from random import shuffle
from collections import namedtuple

class adaptive_learning_test():

    def __init__(self):

        self.topic1 = """
        inequality signs
        A term to describe the following symbols: < less than, > greater than, ≤ less than or equal to, ≥ greater than or equal to.
        """
        self.Q1 = """
        A term to describe the following symbols: < less than, > greater than, ≤ less than or equal to, ≥ greater than or equal to.
            A. difference signs
            B. equivalent signs
            C. operation signs
            D. inequality signs"""
        self.explanation1 = """
        EXPLANATION:
        inequality signs
        A term to describe the following symbols: < less than, > greater than, ≤ less than or equal to, ≥ greater than or equal to.
        """

        self.topic2 = """
        index number
        Another term to describe the power of a number. (A number that is mutiplied by itself one or more times is written to a power.)
        """
        self.Q2 = """
        Another term to describe the power of a number. (A number that is mutiplied by itself one or more times is written to a power.)
            A. standard form
            B. data value
            C. variable
            D. index number
            """
        self.explanation2 = """
        EXPLANATION:
        index number
        Another term to describe the power of a number. (A number that is mutiplied by itself one or more times is written to a power.)
        """

        self.topic3 = """
        place value
        The value of the position of a digit in a number.
        """
        self.Q3 = """
        In the number 3,462, what is the value of the 6?
            A. 6 tens
            B. 6 hundreds
            C. 60
            D. 6 tenths
            """
        self.explanation3 = """
        EXPLANATION:
        The value 6 is in the Tens column, therefore it has the value 60.

        6 tenths would be written as 0.6

        6 hundreds would be written as 600

        6 tens gives only the column value and not the numerical value."""

        self.Q4 = """
        Put these numbers in size order, starting with the smallest: -7, -9, 3, -1.
            A. -9, -7, -1, 3
            B. -9, -7, 3, -1
            C. -1, 3, -7, -9
            D. 3, -1, -7, -9
            """
        self.explanation4 = """
        Explanation
        When comparing values we often think of temperature.
        
        -9 degrees would feel colder than -7
        
        -9 and 9 are very different numbers so we do not ignore the negative signs.
        
        -1 is not smaller than -7. -7 degrees would feel much colder so -1 is the bigger value."""

        self.Q5 = """
        Put the correct symbol in place: 47 ___ 36.
            A. >
            B. <
            C. =
            D. ≤
            """
        self.explanation5 = """
        Explanation
        When comparing numbers we read from left to right.

        47 is greater than 36 so

        47 > 36"""

        self.Q6 = """
        What is 344 ÷ 8?
            A. 40
            B. 43
            C. 40.5
            D. 4 remainder 3
            """
        self.explanation6 = """
        Explanation
        8 x 10 = 80
        
        344 - 320 (4 x 10 x 8 = 320) = 24
        
        344 - 320 (40 x 8 = 320) = 24
        
        24 / 8 = 3
        
        40 + 3 = 43 so there are 43 lots of 8 in 344
        """

        self.Q7 = """
        What is 27 × 6?
            A. 180
            B. 162
            C. 122
            D. 262
            """
        self.explanation7 = """
        Explanation
        When we break it down:
        27 x 6
        20 x 6 = 120 7 x 6 = 42
        and 120 + 42 = 162
        """

        self.Q8 = """
        What is 3 + 2 × 4?
            A. 11
            B. 20
            C. 24
            D. 9
            """
        self.explantion8 = """
        Explanation
        Using BIDMAS we Multiply before we Add
        So 3 + 2 x 4
        2 x 4 = 8
        3 + 8 = 11
        """

        self.topic9 = """
        place value
        The value of the position of a digit in a number.
        """
        self.Q9 = """
        The value of the position of a digit in a number.
            A. tenths
            B. hundreds
            C. decimal number
            D. place value
            """

        self.topic10 = """
        divisor
        The number by which another number is divided.
        """
        self.Q10 = """
        The number by which another number is divided.
            A. multiple
            B. power
            C. denominator
            D. divisor
            """

        self.Q10 = """
        What is 4 + -2?
            A. 2
            B. -2
            C. 6
            D. -6
            """
        self.explanation10 = """
        Explanation
        4 + - 2 can be re-written as 4 - 2 = 2
        """

        self.Q11 = """
        What is the number three million, four hundred and fifty one thousand and seventy three in figures?
            A. 34,005,173
            B. 34,510,073
            C. 345,173
            D. 3,451,073
            """
        self.explanation11 = """
        Explanation
        When comparing the numbers the first 3 in 3,451,073 is in the millions column. 
        The question states three million at the start making 3,451,073 the correct answer.
        The first 3 in 345,173 is in the Hundreds of Thousands column.
        The first 3 in 34,005,173 is in the Tens of Millions column.
        """

        self.topic11 = """
        Power
        A word to describe how many times a number has been multiplied by itself. (Another word for this is index.)
        """
        self.Q12 = """
        A word to describe how many times a number has been multiplied by itself. (Another word for this is index.)
        A. Product
        B. Factor
        C. Power
        D. Mean
        """

        self.Q12 = """
        What is 47 + 233
        A. 280
        B. 270
        C. 2377
        D. 703"""
        self.explanation12 = """
        Explanation
        47 + 233 can be written as 40 + 7 + 200 + 30 + 3 = 200 + 40 + 30 + 3 + 7
        
        = 200 + 70 + 10
        
        = 280
        
        2,377 and 703 are far too big. We can estimate to see this.
        
        47 is approximately 50
        
        233 is approximately 200
        
        200 + 50 = 250 So the answer should be approximately 250.
        
        2,377 is much bigger."""

        Features = namedtuple('Features', ['topic', 'question', 'explanation'])
        self.Q1nt = Features(topic = self.topic1,
                             question = self.Q1,
                             explanation = self.explanation1)
        self.Q2nt = Features(topic=self.topic2,
                             question=self.Q2,
                             explanation=self.explanation2)
        self.Q3nt = Features(topic=self.topic3,
                             question=self.Q3,
                             explanation=self.explanation3)
        self.Qnt_dict = {'Q1': self.Q1nt,
                         'Q2': self.Q2nt,
                         'Q3': self.Q3nt}

        self.question_names = ['Q1', 'Q2', 'Q3']
        self.question_ids = {'Q1': 0,
                             'Q2': 1,
                             'Q3': 2}
        self.question_dict = {'Q1': self.Q1,
                              'Q2': self.Q2,
                              'Q3': self.Q3}


        self.question_answers = {'Q1': 'D',
                                 'Q2': 'D',
                                 'Q3': 'C'}
        self.question_answers_text = {}
        self._get_text_answers()
        # self.question_answers_text = {'Q1': 'The longest edge',
        #                               'Q2': 'π',
        #                               'Q3': '1.8^2'}




        self.total_correct_answers = 5
        self.correct_answers = np.array([0, 0, 0])
        self.remaining_correct_answers = self.total_correct_answers - self.correct_answers
        self.p = self.remaining_correct_answers / np.sum(self.remaining_correct_answers)

        # initial topic vs question
        self.topic_initial_probability = 1.
        self.topic_default_probability = 0.2
        self.topic_buffer_threshold = [0.05, 0.95]
        self.attempts = np.array([0, 0, 0])
        self.is_topic_shown = np.array([0, 0, 0])
        self.tp = np.array([1., 1., 1.]) * self.topic_initial_probability

        self.answer_options = {}
        self.questions_blank_answers = {}
        for question_name in self.question_names:
            self.get_multi_choice_options(question_name)

    def _get_text_answers(self):
        for question_name in self.question_names:
            question_lines = [line.strip() for line in self.question_dict[question_name].split('\n') if line.strip() != '']
            self.question_answers_text[question_name] = [line[3:] for line in question_lines if line[0] == self.question_answers[question_name]][0]

    def update_correct_answers(self, question_name):
        self.correct_answers[self.question_ids[question_name]] += 1
        self.remaining_correct_answers = self.total_correct_answers - self.correct_answers

        if np.sum(self.remaining_correct_answers) > 0:
            self.p = self.remaining_correct_answers / np.sum(self.remaining_correct_answers)


    def update_attempts(self, question_name):
        " Change the relative probability of showing the topic vs question "
        self.attempts[self.question_ids[question_name]] += 1

        # if self.attempts[self.question_ids[question_name]] > 0:
        attempts = self.attempts[self.question_ids[question_name]]
        corrects = self.correct_answers[self.question_ids[question_name]]

        wrong_frac = (attempts - corrects) / attempts
        # rescale to in interval self.topic_buffer_threshold
        tp1 = self.topic_buffer_threshold[0]
        dtp = self.topic_buffer_threshold[1] - self.topic_buffer_threshold[0]
        self.tp[self.question_ids[question_name]] = (tp1 + wrong_frac * dtp)
        print(self.attempts, self.correct_answers, self.tp)

    def start_showing_question(self, question_name):
        " Set probability of showing the topic (vs question) to default value once we have shown the topic once"
        self.is_topic_shown[self.question_ids[question_name]] += 1
        if self.is_topic_shown[self.question_ids[question_name]] == 1:
            self.tp[self.question_ids[question_name]] = self.topic_default_probability

    def choose_topic_or_question(self, question_name):
        tp = self.tp[self.question_ids[question_name]]
        return np.random.choice(a=['question', 'topic'],
                                p=[1-tp, tp])

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