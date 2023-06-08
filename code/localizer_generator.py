import random
import pandas as pd

# Generate numbers with 3 digits
three_digit_numbers = []
for i in range(20):
    number = ''.join([str(random.randint(0, 9)) for x in range(3)])
    three_digit_numbers.append(number)

# Generate numbers with 6 digits
six_digit_numbers = []
for i in range(20):
    number = ''.join([str(random.randint(0, 9)) for x in range(6)])
    six_digit_numbers.append(number)

# Generate numbers with 9 digits
nine_digit_numbers = []
for i in range(20):
    number = ''.join([str(random.randint(0, 9)) for x in range(9)])
    nine_digit_numbers.append(number)

# Combine all numbers into a single list
all_numbers = three_digit_numbers + six_digit_numbers + nine_digit_numbers

# Randomize the order
random.shuffle(all_numbers)

# Create a dataframe
data = {'Numbers': all_numbers}
df = pd.DataFrame(data)

# Print the dataframe
print(df)

# SAVE TRIALLIST IN CORRECT FOLDER
path = '../triallists/number-localizer.csv'
df.to_csv (path, index = False)
