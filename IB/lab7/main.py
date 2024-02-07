import sys
import string_generator
def main():
    length = int(sys.argv[1])
    num_strings = int(sys.argv[2])
    strings = string_generator.generate_strings(length, num_strings)
    for s in strings:
        print(s)
if __name__ == "__main__":
    main()