%{
#include <ctype.h>
#include<stdio.h>
#include<stdlib.h>
#ifndef YYSTYPE
#define YYSTYPE double
#endif
int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);
%}

%token NUMBER
%token ADD 
%token SUB
%token MUL
%token DIV
%token LEF
%token RIG
%left ADD SUB
%left MUL DIV
%right UMINUS

%%

lines : lines expr ';'{ printf("%f\n", $2); }
      | lines ';'
      |
      ;

expr  : expr ADD expr{ $$ = $1 + $3; }
      | expr SUB expr{ $$ = $1 - $3; }
      | expr MUL expr{ $$ = $1 * $3; }
      | expr DIV expr{ $$ = $1 / $3; }
      | LEF expr RIG{$$ = $2; }
      | SUB expr %prec UMINUS{$$ = -$2;}
      | NUMBER{ $$ = $1; }
      ;
%%

// program section

int yylex()
{
 // place your token retrieving code here
 int t;
  while (1) {
   t = getchar();
   if (t == ' ' || t == '\t' || t == '\n') {//当时空格、制表符、回车换行时
    //do nothing 
   }
   else if(isdigit(t)) {//当是多位十进制整数时
    yylval = 0;
    while (isdigit(t)) {
     yylval = yylval * 10 + t - '0';
     t = getchar();
    }
    ungetc(t, stdin);
    return NUMBER;
   }
   else if(t == '+')
    return ADD;
   else if(t == '-')
    return SUB;
   else if(t == '*')
    return MUL;
   else if(t == '/')
    return DIV;
   else if(t == '(')
    return LEF;
   else if(t == ')')
    return RIG;
  else {
    return t;
   }
  }
}
int main(void)
{
 yyin = stdin;
 do {
  yyparse();
 } while (!feof(yyin));
 return 0;
}
void yyerror(const char* s) {
 fprintf(stderr, "Parse error:%s\n", s);
 exit(1);
}