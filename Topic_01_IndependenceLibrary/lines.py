def lines_should_be_shorter_than(string: str, max_length: int):
    lines = string.splitlines()
    long_lines = 0
    for lineno, line in enumerate(lines, start=1):
        if len(line) > max_length:
            print(f'Line {lineno} length {len(line)} is over {max_length}.')
            long_lines += 1
    if long_lines == 0:
        print(f'All {len(lines)} lines shorter than {max_length}.')
    else:
        raise AssertionError(f'{long_lines} lines longer than {max_length}.')
