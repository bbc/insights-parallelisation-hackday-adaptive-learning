import numpy as np
from adaptive_learning_model import adaptive_learning_test

if __name__ == "__main__":

    the_test = adaptive_learning_test()

    while np.sum(the_test.remaining_correct_answers) > 0:
        question_name = the_test.choose_a_question()
        question_text = the_test.get_question_with_shuffle_answers(question_name)
        user_answer = input(question_text + '\n')
        user_answer_text = question_text.split(user_answer)[1].split('. ')[1].split('\n')[0]

        if user_answer_text == the_test.question_answers_text[question_name]:

            print("Correct, well done!")
            the_test.update_correct_answers(question_name)
        else:
            print("Sorry, that is incorrect!")