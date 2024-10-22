# Create a program to read data from data_01.txt (the file contains two columns of counts), then perform the
# selected arithmetic operation on the data (line by line) and write the result to a new file in the following form:
# number_1 the symbol of the operation (e.g. +) number_2 = the result of the operation.

def add(x, y):
    return x + y

with open("data_01.txt", "r") as file:
    data = file.readlines()
    data = [line.split("\t") for line in data]
    data = [[int(line[0]), int(line[1])] for line in data]
    new_data = [add(line[0], line[1]) for line in data]

    with open("result.txt", "w") as result:
        for i in range(len(data)):
            result.write(f"{new_data[i]}\n")