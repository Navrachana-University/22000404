README.txt
==========

Project Title:
--------------
**BlipLang Compiler using FLEX and BISON**

Description:
------------
This project is a simple compiler for a custom-designed language called **BlipLang**. The compiler is built using **FLEX** (Fast Lexical Analyzer) and **BISON** (GNU parser generator). The language features C-style syntax and supports basic variable assignments, arithmetic operations, conditionals, and loops. The compiler processes a source file written in BlipLang and generates intermediate code (three-address code style) as output.

BlipLang is designed to introduce beginners to compiler design concepts such as lexical analysis, parsing, intermediate code generation, control structures, and temporary variable management.

Language Syntax Overview:
-------------------------
BlipLang includes the following features:
- Variable declaration and initialization using `make`
- Arithmetic operations: `add`, `sub`, `mul`, `div`
- Assignment via the `->` operator
- Conditional branching using `check` and `else`
- Loops using `loop` and conditions with `<`, `>`, `==`, `!=`, `<=`, `>=`

Example Input (`input.txt`):
----------------------------
make x = 5;
make y = 10;
add x y -> z;
sub x y -> w;
mul x y -> v;
div x y -> u;
check z > 10 {
sub z 1 -> z;
} else {
add z 1 -> z;
}
loop z < 20 {
add z 1 -> z;
}


How it Works:
-------------
1. **Lexical Analysis** (in `.l` file):
   - Uses FLEX to tokenize keywords like `make`, `add`, `sub`, `check`, etc.
   - Recognizes identifiers, numbers, operators, and symbols.
   - Skips whitespaces and tracks line numbers for debugging.

2. **Parsing and Intermediate Code Generation** (in `.y` file):
   - Uses BISON to define the grammar rules and parsing structure.
   - Translates BlipLang statements into intermediate three-address code.
   - Supports temporary variable generation and label handling for control flow.
   - Outputs generated code to a file using `fprintf`.

Compilation Instructions:
-------------------------
To compile the project run the following commands in a terminal:
1) flex bliplang.l
2) bison -d bliplang.y
3) gcc lex.yy.c bliplang.tab.c -o bliplang
4) bliplang.exe < input.txt


Files:
------
- `bliplang.l` - FLEX file for lexical analysis
- `bliplang.y` - BISON file for syntax analysis and code generation
- `input.txt` - Sample input in BlipLang
- `output.txt` - Generated intermediate code
- `bliplang.tab.h`, `bliplang.tab.c`, `lex.yy.c` - Generated during compilation

Author:
-------
Harsh Patel
