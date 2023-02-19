#!/usr/bin/env python3
import os
import re


def get_file_list():
    files = [file for file in os.listdir() if re.findall('[AaMm][KkPpVv][4IiVv]', file)]

    return files


def rename_files(files):
    for file in files:
        file_name, file_ext = os.path.splitext(file)

        try:
            new_name = str(re.findall('[Ss][0-9][0-9][Ee][0-9][0-9]', file_name)[0]).upper() + file_ext.lower()

            if file == new_name:
                print(f'{file}: file has already been renamed')
            else:
                print(f'renamed: {new_name}')

                os.rename(file, new_name)
        except IndexError:
            print('error: no files to rename')
            exit(1)


def main():
    files = get_file_list()

    if len(files) < 1:
        exit(1)
    else:
        rename_files(files)


if __name__ == '__main__':
    main()
