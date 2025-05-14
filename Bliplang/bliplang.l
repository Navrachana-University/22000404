%{
#include "bliplang.tab.h"
#include <string.h>
int line_num = 1;
%}

%%
"make"        { return MAKE; }
"add"         { return ADD; }
"sub"         { return SUB; }
"mul"         { return MUL; }
"div"         { return DIV; }
"check"       { return CHECK; }
"else"        { return ELSE; }
"loop"        { return LOOP; }
"->"          { return ARROW; }
"<"           { return LT; }
">"           { return GT; }
"=="          { return EQ; }
"!="          { return NE; }
"<="          { return LE; }
">="          { return GE; }
"{"           { return '{'; }
"}"           { return '}'; }
";"           { return ';'; }
"="           { return '='; }
[0-9]+        { yylval.str = strdup(yytext); return NUMBER; }
[a-zA-Z][a-zA-Z0-9]*  { yylval.str = strdup(yytext); return ID; }
[ \t]         ;   // skip whitespace
\n            { line_num++; }  
.             { printf("Unknown character: %s\n", yytext); }
%%

int yywrap() {
    return 1;
}