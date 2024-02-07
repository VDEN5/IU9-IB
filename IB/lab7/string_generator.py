import random
import string
def generate_strings(length, num_strings):
    valid_chars = string.ascii_letters + string.digits + string.punctuation
    result = []
    for _ in range(num_strings):
        new_string = ''.join(random.choice(valid_chars) for _ in range(length))
        result.append(new_string)
    return result
