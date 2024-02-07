import re

class Token:
    def __init__(self, value, position, line, column):
        self.value = value
        self.position = position
        self.line = line
        self.column = column

def tokenize(text):
    tokens = []
    lines = text.split('\n')
    position = 0

    for i, line in enumerate(lines):
        words = re.findall(r"[\w']+|[.,!?;]", line)
        column = 0
        for word in words:
            token = Token(word, position, i+1, column+1)
            tokens.append(token)
            position += len(word) + 1
            column += len(word) + 1

    return tokens
def load_dictionary(file_path):
    with open(file_path, 'r') as file:
        dictionary_text = file.read()
        return set(re.findall(r"[\w']+", dictionary_text))

def spell_check(dictionary_file, text_file):
    dictionary = load_dictionary(dictionary_file)

    with open(text_file, 'r') as file:
        text = file.read()
        tokens = tokenize(text)

        misspelled = []
        for token in tokens:
            if token.value not in dictionary:
                misspelled.append((token.value, token.line, token.column))

        for word, line, column in misspelled:
            print(f"{line}, {column}  {word}", end=' ')

if __name__ == "__main__":
    import sys
    if len(sys.argv) != 3:
        print("Usage: speller.py <dictionary_file> <text_file>")
    else:
        spell_check(sys.argv[1], sys.argv[2])