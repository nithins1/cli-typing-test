import os
import random
import time
from termcolor import colored

TIME_LIMIT = 60 # Seconds
CHARS_PER_WORD = 5
width, height = os.get_terminal_size()
width = min(width, 80)

input(colored("""##### Typing Speed Test! #####\n"""
              """##### By: Nithin Singhal #####\n"""
              """### Press 'Enter' to start ###\n""", "blue"))

with open("commonwords.txt", "r") as f:
    words_list = f.read().split()
f.close()

def randWord():
    return words_list[random.randint(0, len(words_list) - 1)]

mispelled_words = []
correct_words_typed = 0
total_words_printed = 0
total_words_typed = 0
total_chars_typed = 0

t_start = time.time()
while time.time() < t_start + TIME_LIMIT:
    line_length = 0
    line = ""
    print("  ", end="")
    while True:
        word = randWord() + " "
        # Prevent duplicate words from appearing in line
        while word in line:
            word = randWord() + " "

        # Stop adding words when line becomes too long
        if line_length + len(word) >= width - 1:
            break

        line += word
        line_length += len(word)
    print(colored(line, "cyan"), end="\r")
    input_line = input("> ")
    print()

    total_chars_typed += len(input_line)

    line = line.split()
    input_line = input_line.split()
    total_words_printed += len(line)
    total_words_typed += len(input_line)

    for word in line:
        if word in input_line:
            correct_words_typed += 1
        else:
            mispelled_words.append(word)

t_end = time.time()
time_taken = t_end - t_start
print(colored("Time taken: " + "{:.2f}s".format(time_taken), "green"))
print(colored("Mispelled words:", "red"), end="")
if mispelled_words:
    for word in mispelled_words:
        print(colored(" " + word, "red"), end="")
    print()
else:
    print(colored(" None!", "green"))

print(colored("Accuracy: " + "{0:.2f}%".format(correct_words_typed / total_words_printed * 100), "blue"))
print(colored("Words Per Minute (WPM): " + "{:.2f}".format(total_chars_typed / CHARS_PER_WORD / (time_taken / 60)), "blue"))
print(colored("Characters Per Second (CPS): " + "{:.2f}".format(total_chars_typed / time_taken), "blue"))
