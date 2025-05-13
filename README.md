# P-Strings Assembly Project

This project implements string manipulation functions in x86-64 assembly language with C integration. It includes a comprehensive test suite to verify all functionality.

## Prerequisites

Before building the project, make sure you have the following installed on your Linux/WSL system:

1. GCC (GNU Compiler Collection)
2. GNU Assembler (part of binutils)
3. Make

You can install these dependencies on Ubuntu/Debian using:

```bash
sudo apt-get update
sudo apt-get install build-essential
```

## Building and Running

1. Clone the repository:
```bash
git clone <repository-url>
cd P-Strings-Assembly-x84-
```

2. Build the project:
```bash
make clean
make
```

3. Run the test suite:
```bash
./testPstringFunc
```

## Test Suite

The test suite (`testPstringFunc.c`) includes tests for all implemented functions:

1. `pstrlen` - Tests string length calculation
2. `replaceChar` - Tests character replacement functionality
3. `pstrijcpy` - Tests string copy with index range
4. `swapCase` - Tests case swapping (upper/lower)
5. `pstrijcmp` - Tests string comparison with index range

Each test will print a success message if passed. For example:
```
Success pstrlen (1/5)
Success replaceChar (2/5)
Success pstrijcpy (3/5)
Success swapCase (4/5)
Success pstrijcmp (5/5)
```

## Project Structure

- `pstring.h` - Header file containing the Pstring structure and function declarations
- `pstring.s` - Assembly implementation of the string manipulation functions (AT&T syntax)
- `testPstringFunc.c` - Main test suite with all test cases
- `Makefile` - Build configuration

## Implementation Details

- The project uses 64-bit assembly (x86-64)
- The Pstring structure is defined with a maximum string length of 255 characters
- All assembly code is written in AT&T syntax (GNU assembler format)
- Functions are implemented in assembly for optimal performance

## Cleaning Up

To clean up the compiled files, run:

```bash
make clean
```

## Author

Created by Evyatar Altman (24/12/22) 