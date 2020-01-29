import numpy as np
from adaptiveLearnModel import adaptive_learning_test
import sys

def main():
    the_test = adaptive_learning_test()
    CURSOR_UP_ONE = '\x1b[1A'

    while np.sum(the_test.remaining_correct_answers) > 0:
        question_name = the_test.choose_a_question()
        topic_or_question = the_test.choose_topic_or_question(question_name)
        print(topic_or_question)
        if topic_or_question == 'topic':
            the_test.start_showing_question(question_name)

        if topic_or_question == 'question':
            question_text = the_test.get_question_with_shuffle_answers(question_name)
            user_answer = input(question_text + '\n')
            user_answer_text = ('.' + question_text.split(f"{user_answer}.")[1]).split('. ')[1].split('\n')[0]

            if user_answer_text == the_test.question_answers_text[question_name]:

                sys.stdout.write(CURSOR_UP_ONE)
                print("Correct, well done!")
                the_test.update_correct_answers(question_name)
                # input(the_test.Qnt_dict[question_name].explanation)
            else:
                sys.stdout.write(CURSOR_UP_ONE)
                print("Sorry, that is incorrect!\n")
                input(the_test.Qnt_dict[question_name].explanation)

            the_test.update_attempts(question_name)
        else:
            input(the_test.Qnt_dict[question_name].topic)



if __name__ == "__main__":
    main()