import sys
import argparse
import os
def wc(files, count_bytes, count_chars, count_words, count_lines):
    total_bytes = 0
    total_chars = 0
    total_words = 0
    total_lines = 0
    for file in files:
        try:
            with open(file, 'r') as f:
                content = f.read()
                file_bytes = os.path.getsize(file)
                file_chars = len(content)
                file_words = len(content.split())
                file_lines = content.count('\n')                
                if count_bytes:
                    print(f"{file_bytes}", end=' ')
                if count_chars:
                    print(f"{file_chars}", end=' ')
                if count_words:
                    print(f"{file_words}", end=' ')
                if count_lines:
                    print(f"{file_lines}", end=' ')
                print(f"{file}")
                total_bytes += file_bytes
                total_chars += file_chars
                total_words += file_words
                total_lines += file_lines
        except Exception as e:
            print(f"Error reading {file}: {e}", file=sys.stderr)
    if len(files) > 1:
        if count_bytes:
            print(f"{total_bytes}", end=' ')
        if count_chars:
            print(f"{total_chars}", end=' ')
        if count_words:
            print(f"{total_words}", end=' ')
        if count_lines:
            print(f"{total_lines}", end=' ')
        print("total")
def main():
    parser = argparse.ArgumentParser(description='Custom Word Count Utility')
    parser.add_argument('files', nargs='*', help='Files to process')
    parser.add_argument('-c', '--bytes', action='store_true', help='Print the byte counts')
    parser.add_argument('-m', '--chars', action='store_true', help='Print the character counts')
    parser.add_argument('-w', '--words', action='store_true', help='Print the word counts')
    parser.add_argument('-l', '--lines', action='store_true', help='Print the newline counts')
    args = parser.parse_args()
    files = args.files
    count_bytes = args.bytes
    count_chars = args.chars
    count_words = args.words
    count_lines = args.lines
    if not files:
        content = sys.stdin.read()
        file_bytes = len(content.encode('utf-8'))
        file_chars = len(content)
        file_words = len(content.split())
        file_lines = content.count('\n')
        if count_bytes:
            print(f"{file_bytes}", end=' ')
        if count_chars:
            print(f"{file_chars}", end=' ')
        if count_words:
            print(f"{file_words}", end=' ')
        if count_lines:
            print(f"{file_lines}", end=' ')
        print("stdin")
    else:
        wc(files, count_bytes, count_chars, count_words, count_lines)
if __name__ == "__main__":
    main()