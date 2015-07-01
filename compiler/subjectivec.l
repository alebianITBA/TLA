%{
#include <stdlib.h>
#include "y.tab.h"
void yyerror(char *);
#undef ECHO
#define ECHO printf ("[%s]\n", yytext)
%}

%%

[-+]?[0-9]+  	{
                yylval.str = strdup(yytext);
           		  return INTEGER;
        	    }
[-+]?[0-9]+\.?[0-9]+    {
                          yylval.str = strdup(yytext);
                          return DECIMAL;
                        }

if 			  { return IF; }

else 		  { return ELSE; }

while		  { return WHILE; }

do			  { return DO; }

int 		  { return INT; }

char 		  { return CHAR; }

String 		{ return STRING; }

boolean   { return BOOLEAN; }

float 		{ return FLOAT; }

True		  { return TRUE; }

False		  { return FALSE; }

Object 		{ return OBJECT; }

Class 		{ return CLASS; }

main 		  { return MAIN; }

return 		{ return RETURN; }

void 		  { return VOID; }

new 		  { return NEW; }

print 		{ return PRINT; }

atoi      { return ATOI; }

[a-zA-Z]+ 	{
				      yylval.str = strdup(yytext);
				      return TEXT;
			      }

[-+/*(){};><=!&|,^'"%.\[\]]   { return *yytext; }

[ \t\n] ;

.  yyerror("Invalid character.");

%%

int yywrap(void) {
  return 1;
}

void yyerror(char *s) {
  fprintf(stderr, "%s\n", s);
}
