%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern FILE *yyin;
extern FILE *yyout;
extern int yylex();
extern int line_num;
void yyerror(const char *s);    // Function to generate new temporary variables
char* newTemp();                // Function to generate new labels
char* newLabel();
int tempCount = 1;              // Counter for temporary variables
int labelCount = 1;             // Counter for labels

// Global variables to store labels for control structures
char* if_else_end;
char* else_label;
char* loop_start;
char* loop_body;
char* loop_end;
%}

%union {
    char* str;
}

%token <str> ID NUMBER
%token MAKE ADD SUB MUL DIV CHECK ELSE LOOP ARROW LT GT EQ NE LE GE
%type <str> expr condition

%%
program
    : statement_list
    ;

statement_list
    : statement
    | statement_list statement
    ;

statement
    : assignment_stmt ';'
    | operation_stmt ';'
    | conditional_stmt
    | loop_stmt
    ;

assignment_stmt
    : MAKE ID '=' expr {
        fprintf(yyout, "%s = %s\n", $2, $4);
    }
    ;

operation_stmt
    : ADD ID ID ARROW ID {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s + %s\n", temp, $2, $3);
        fprintf(yyout, "%s = %s\n", $5, temp);
    }
    | ADD ID NUMBER ARROW ID {
        char* temp1 = newTemp();
        char* temp2 = newTemp();
        fprintf(yyout, "%s = %s\n", temp1, $3);
        fprintf(yyout, "%s = %s + %s\n", temp2, $2, temp1);
        fprintf(yyout, "%s = %s\n", $5, temp2);
    }
    | SUB ID ID ARROW ID {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s - %s\n", temp, $2, $3);
        fprintf(yyout, "%s = %s\n", $5, temp);
    }
    | SUB ID NUMBER ARROW ID {
        char* temp1 = newTemp();
        char* temp2 = newTemp();
        fprintf(yyout, "%s = %s\n", temp1, $3);
        fprintf(yyout, "%s = %s - %s\n", temp2, $2, temp1);
        fprintf(yyout, "%s = %s\n", $5, temp2);
    }
    | MUL ID ID ARROW ID {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s * %s\n", temp, $2, $3);
        fprintf(yyout, "%s = %s\n", $5, temp);
    }
    | MUL ID NUMBER ARROW ID {
        char* temp1 = newTemp();
        char* temp2 = newTemp();
        fprintf(yyout, "%s = %s\n", temp1, $3);
        fprintf(yyout, "%s = %s * %s\n", temp2, $2, temp1);
        fprintf(yyout, "%s = %s\n", $5, temp2);
    }
    | DIV ID ID ARROW ID {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s / %s\n", temp, $2, $3);
        fprintf(yyout, "%s = %s\n", $5, temp);
    }
    | DIV ID NUMBER ARROW ID {
        char* temp1 = newTemp();
        char* temp2 = newTemp();
        fprintf(yyout, "%s = %s\n", temp1, $3);
        fprintf(yyout, "%s = %s / %s\n", temp2, $2, temp1);
        fprintf(yyout, "%s = %s\n", $5, temp2);
    }
    ;

conditional_stmt
    : CHECK condition {
        char* true_label = newLabel();
        char* false_label = newLabel();
        char* end_label = newLabel();
        
        // Store labels in global variables
        else_label = false_label;
        if_else_end = end_label;
        
        fprintf(yyout, "if %s goto %s\n", $2, true_label);
        fprintf(yyout, "goto %s\n", false_label);
        fprintf(yyout, "%s:\n", true_label);
    } 
    '{' statement_list '}' ELSE {
        fprintf(yyout, "goto %s\n", if_else_end);
        fprintf(yyout, "%s:\n", else_label);
    }
    '{' statement_list '}' {
        fprintf(yyout, "%s:\n", if_else_end);
    }
    ;

loop_stmt
    : LOOP {
        loop_start = newLabel();
        loop_body = newLabel();
        loop_end = newLabel();
        
        fprintf(yyout, "%s:\n", loop_start);
    }
    condition {
        fprintf(yyout, "if %s goto %s\n", $3, loop_body);
        fprintf(yyout, "goto %s\n", loop_end);
        fprintf(yyout, "%s:\n", loop_body);
    }
    '{' statement_list '}' {
        fprintf(yyout, "goto %s\n", loop_start);
        fprintf(yyout, "%s:\n", loop_end);
    }
    ;

condition
    : ID LT ID {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s < %s\n", temp, $1, $3);
        $$ = temp;
    }
    | ID GT ID {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s > %s\n", temp, $1, $3);
        $$ = temp;
    }
    | ID EQ ID {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s == %s\n", temp, $1, $3);
        $$ = temp;
    }
    | ID NE ID {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s != %s\n", temp, $1, $3);
        $$ = temp;
    }
    | ID LE ID {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s <= %s\n", temp, $1, $3);
        $$ = temp;
    }
    | ID GE ID {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s >= %s\n", temp, $1, $3);
        $$ = temp;
    }
    | ID LT NUMBER {
        char* temp1 = newTemp();
        fprintf(yyout, "%s = %s\n", temp1, $3);
        char* temp2 = newTemp();
        fprintf(yyout, "%s = %s < %s\n", temp2, $1, temp1);
        $$ = temp2;
    }
    | ID GT NUMBER {
        char* temp1 = newTemp();
        fprintf(yyout, "%s = %s\n", temp1, $3);
        char* temp2 = newTemp();
        fprintf(yyout, "%s = %s > %s\n", temp2, $1, temp1);
        $$ = temp2;
    }
    | NUMBER GT ID {
        char* temp1 = newTemp();
        fprintf(yyout, "%s = %s\n", temp1, $1);
        char* temp2 = newTemp();
        fprintf(yyout, "%s = %s > %s\n", temp2, temp1, $3);
        $$ = temp2;
    }
    | NUMBER LT ID {
        char* temp1 = newTemp();
        fprintf(yyout, "%s = %s\n", temp1, $1);
        char* temp2 = newTemp();
        fprintf(yyout, "%s = %s < %s\n", temp2, temp1, $3);
        $$ = temp2;
    }
    | ID EQ NUMBER {
        char* temp1 = newTemp();
        fprintf(yyout, "%s = %s\n", temp1, $3);
        char* temp2 = newTemp();
        fprintf(yyout, "%s = %s == %s\n", temp2, $1, temp1);
        $$ = temp2;
    }
    | ID NE NUMBER {
        char* temp1 = newTemp();
        fprintf(yyout, "%s = %s\n", temp1, $3);
        char* temp2 = newTemp();
        fprintf(yyout, "%s = %s != %s\n", temp2, $1, temp1);
        $$ = temp2;
    }
    | ID LE NUMBER {
        char* temp1 = newTemp();
        fprintf(yyout, "%s = %s\n", temp1, $3);
        char* temp2 = newTemp();
        fprintf(yyout, "%s = %s <= %s\n", temp2, $1, temp1);
        $$ = temp2;
    }
    | ID GE NUMBER {
        char* temp1 = newTemp();
        fprintf(yyout, "%s = %s\n", temp1, $3);
        char* temp2 = newTemp();
        fprintf(yyout, "%s = %s >= %s\n", temp2, $1, temp1);
        $$ = temp2;
    }
    ;

expr
    : ID {
        $$ = $1;
    }
    | NUMBER {
        char* temp = newTemp();
        fprintf(yyout, "%s = %s\n", temp, $1);
        $$ = temp;
    }
    ;

%%

char* newTemp() {
    char* buffer = malloc(10);
    sprintf(buffer, "t%d", tempCount++);
    return buffer;
}

char* newLabel() {
    char* buffer = malloc(10);
    sprintf(buffer, "L%d", labelCount++);
    return buffer;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error at line %d: %s\n", line_num, s);
}

int main() {
    yyin = fopen("input.txt", "r");
    yyout = fopen("output.txt", "w");
    
    if (!yyin) {
        fprintf(stderr, "Could not open input.txt\n");
        return 1;
    }
    
    if (!yyout) {
        fprintf(stderr, "Could not create output.txt\n");
        return 1;
    }
    
    yyparse();
    
    fclose(yyin);
    fclose(yyout);
    
    return 0;
}