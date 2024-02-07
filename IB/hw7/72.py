import os
import sys
import re
import argparse
def grep(pattern, files, ignore_case, max_count, line_number):
    for file in files:
        try:
            with open(file, 'r') as f:
                lines = f.readlines()
                for i, line in enumerate(lines):
                    if ignore_case:
                        match = re.search(pattern, line, re.IGNORECASE)
                    else:
                        match = re.search(pattern, line)
                    if match:
                        if line_number:
                            print(f"{file}:{i+1}:{line.strip()}")
                        else:
                            print(f"{file}:{line.strip()}")
                    if max_count and i+1 >= max_count:
                        break
        except Exception as e:
            print(f"Error reading {file}: {e}", file=sys.stderr)
def main():
    parser = argparse.ArgumentParser(description='Custom Grep Utility')
    parser.add_argument('pattern', help='Pattern to search for')
    parser.add_argument('files', nargs='*', help='Files to search in')
    parser.add_argument('-e', '--regex', action='store_true',
help='Interpret pattern as a regular expression')
    parser.add_argument('-i', '--ignore-case', action='store_true', help='Ignore case distinctions')
    parser.add_argument('-m', '--max-count', type=int, help='Stop after NUM matches')
    parser.add_argument('-n', '--line-number', action='store_true',
help='Prefix each line of output with the 1-based line number within its input file')
    args = parser.parse_args()

    pattern = args.pattern
    if args.regex:
        pattern = re.compile(pattern)
    files = args.files
    ignore_case = args.ignore_case
    max_count = args.max_count
    line_number = args.line_number

    if not files:  # If no files are provided, read from standard input
        for i, line in enumerate(sys.stdin):
            if ignore_case:
                match = re.search(pattern, line, re.IGNORECASE)
            else:
                match = re.search(pattern, line)
            if match:
                if line_number:
                    print(f"{i+1}:{line.strip()}")
                else:
                    print(f"{line.strip()}")
                if max_count and i+1 >= max_count:
                    break
    else:
        grep(pattern, files, ignore_case, max_count, line_number)

if __name__ == "__main__":
    main()