%{

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define EXTRA_SPACE 1024

int yydebug = 1;
extern FILE *yyin;
char* filename;

void yyerror(char *);
int yylex(void);
void createFile(char*, char*, char*);

%}


%start file

%union { char *str; };

%type <str> file classList mainStmt classStmt block ifStmt whileStmt dowhileStmt decClassVarList decClassVar decMethodList decMethod paramList
%type <str> params sentenceList sentence decVar type decParamList decParams assignStmt printStmt callMethod returnStmt elseStmt expression op number
%type <str> atoiStmt shiftRed1 shiftRed2 shiftRed3 shiftRed4 shiftRed5

%token <str> INTEGER
%token <str> DECIMAL
%token <str> IF
%token <str> ELSE
%token <str> TRUE
%token <str> FALSE
%token <str> WHILE
%token <str> DO
%token <str> BOOLEAN
%token <str> INT
%token <str> CHAR
%token <str> FLOAT
%token <str> STRING
%token <str> CLASS
%token <str> OBJECT
%token <str> TEXT
%token <str> RETURN
%token <str> MAIN
%token <str> VOID
%token <str> NEW
%token <str> PRINT
%token <srt> ATOI


%left '>' '<' '='
%left '-' '+'
%left '%'
%left '*' '/'
%left '&' '|'
%left OP
%left '!'
%left '('

%%

file:
        classList mainStmt decMethodList
        {
            createFile($1, $2, $3);
        }
        ;

mainStmt:
        MAIN '(' STRING '[' ']' TEXT ')' '{' block '}'
        {
            $$ = (char*)calloc(sizeof($3) + sizeof($6) + sizeof($9) + EXTRA_SPACE, 1);
            sprintf($$, "public static void main(String[] %s) {\n%s }\n\n", $6, $9);
            free($9);
        }
        ;

classList:
        classStmt classList
        {
            $$ = (char*)calloc(sizeof($1) + sizeof($2) + EXTRA_SPACE, 1);
            sprintf($$, "%s %s", $1, $2);
            free($1); free($2);
        }
        |
        {
            $$ = (char*)calloc(EXTRA_SPACE, 1);
        }
        ;

classStmt:
        CLASS TEXT '{' decClassVarList decMethodList '}'
        {
            $$ = (char*)calloc(sizeof($4) + sizeof($5) + EXTRA_SPACE, 1);
            sprintf($$, "%s %s {\n%s %s }\n\n", "class ", $2, $4, $5);
            free($4); free($5);
        }
        ;

decClassVarList:
        decClassVarList decClassVar
        {
            $$ = (char*)calloc(sizeof($1) + sizeof($2) + EXTRA_SPACE, 1);
            sprintf($$, "%s %s", $1, $2);
            free($1); free($2);
        }
        |
        {
            $$ = (char*)calloc(EXTRA_SPACE, 1);
        }
        ;

decClassVar:
        type TEXT shiftRed1
        {
            $$ = (char*)calloc(sizeof($1) + sizeof($3) + EXTRA_SPACE, 1);
            sprintf($$, "public static %s %s%s\n", $1, $2, $3);
            free($1); free($3);
        }
        | STRING TEXT '=' shiftRed5
        {
            $$ = (char*)calloc(sizeof($4) + EXTRA_SPACE, 1);
            sprintf($$, "String %s = %s\n", $2, $4);
            free($4);
        }
        | OBJECT TEXT TEXT '=' NEW TEXT ';'
        {
            $$ = (char*)calloc(sizeof($1) + EXTRA_SPACE, 1);
            sprintf($$, "public %s %s = new %s();", $1, $2, $5);
        }
        ;

shiftRed1:
        ';'
        {
            $$ = (char*)calloc(EXTRA_SPACE, 1);
            strcpy($$, ";");
        }
        | '=' expression ';'
        {
            $$ = (char*)calloc(sizeof($2) + EXTRA_SPACE, 1);
            sprintf($$, " = %s;", $2);
            free($2);
        }
        ;

type:
        INT
        {
            $$ = (char*)calloc(EXTRA_SPACE, 1);
            strcpy($$, "int");
        }
        | FLOAT
        {
            $$ = (char*)calloc(EXTRA_SPACE, 1);
            strcpy($$, "double");
        }
        | CHAR
        {
            $$ = (char*)calloc(EXTRA_SPACE, 1);
            strcpy($$, "char");
        }
        | BOOLEAN
        {
            $$ = (char*)calloc(EXTRA_SPACE, 1);
            strcpy($$, "boolean");
        }
        | type '[' ']'
        {
            $$ = (char*)calloc(sizeof($1) + EXTRA_SPACE, 1);
            sprintf($$, "%s[]", $1);
            free($1);
        }
        ;

decMethodList:
        decMethod decMethodList
        {
            $$ = (char*)calloc(sizeof($1) + sizeof($2) + EXTRA_SPACE, 1);
            sprintf($$, "%s %s", $1, $2);
            free($1); free($2);
        }
        |
        {
            $$ = (char*)calloc(EXTRA_SPACE, 1);
        }
        ;

decMethod:
        type TEXT '(' decParamList ')' '{' block '}'
        {
            $$ = (char*)calloc(sizeof($4) + sizeof($7) + EXTRA_SPACE, 1);
            sprintf($$, "public static %s %s(%s) {\n%s }\n\n", $1, $2, $4, $7);
            free($1); free($4); free($7);
        }
        | STRING TEXT '(' decParamList ')' '{' block '}'
        {
            $$ = (char*)calloc(sizeof($4) + sizeof($7) + EXTRA_SPACE, 1);
            sprintf($$, "public static String %s(%s) {\n%s }\n\n", $2, $4, $7);
            free($4); free($7);
        }
        | TEXT '(' decParamList ')' '{' block '}'
        {
            $$ = (char*)calloc(sizeof($3) + sizeof($6) + EXTRA_SPACE, 1);
            sprintf($$, "public static void %s(%s) {\n%s }\n\n", $1, $3, $6);
            free($3); free($6);
        }
        ;

decParamList:
        decParams
        {
            $$ = $1;
        }
        |
        {
            $$ = (char*)calloc(EXTRA_SPACE, 1);
            strcpy($$, "");
        }
        ;

decParams:
        type TEXT shiftRed2
        {
            $$ = (char*)calloc(sizeof($1) + sizeof($3) + EXTRA_SPACE, 1);
            sprintf($$, "%s %s%s", $1, $2, $3);
            free($1); free($3);
        }
        | STRING TEXT shiftRed2
        {
            $$ = (char*)calloc(sizeof($1) + sizeof($3) + EXTRA_SPACE, 1);
            sprintf($$, "String %s%s", $2, $3);
            free($3);
        }
        ;

shiftRed2:
        ',' decParams
        {
            $$ = (char*)calloc(sizeof($2) + EXTRA_SPACE, 1);
            sprintf($$, ", %s", $2);
            free($2);
        }
        |
        {
            $$ = (char*)calloc(EXTRA_SPACE, 1);
        }
        ;

block:
        sentenceList
        {
            $$ = (char*)calloc(sizeof($1) + EXTRA_SPACE, 1);
            sprintf($$, "%s", $1);
            free($1);
        }
        ;

sentenceList:
        sentenceList sentence
        {
            $$ = (char*)calloc(sizeof($1) + sizeof($2) + EXTRA_SPACE, 1);
            sprintf($$, "%s %s", $1, $2);
            free($1); free($2);
        }
        |
        {
            $$ = (char*)calloc(EXTRA_SPACE, 1);
        }
        ;

sentence:
        ifStmt
        {
            $$ = $1;
        }
        | whileStmt
        {
            $$ = $1;
        }
        | dowhileStmt
        {
            $$ = $1;
        }
        | assignStmt
        {
            $$ = $1;
        }
        | callMethod ';'
        {
            $$ = (char*)calloc(sizeof($1) + EXTRA_SPACE, 1);
            sprintf($$, "%s;\n", $1);
            free($1);
        }
        | returnStmt
        {
            $$ = $1;
        }
        | decVar
        {
            $$ = $1;
        }
        | printStmt
        {
            $$ = $1;
        }
        ;

decVar:
        type TEXT shiftRed1
        {
            $$ = (char*)calloc(sizeof($1) + sizeof($3) + EXTRA_SPACE, 1);
            sprintf($$, "%s %s%s\n", $1, $2, $3);
            free($1); free($3);
        }
        | STRING TEXT '=' shiftRed5
        {
            $$ = (char*)calloc(sizeof($4) + EXTRA_SPACE, 1);
            sprintf($$, "String %s = %s\n", $2, $4);
            free($4);
        }
        | OBJECT TEXT TEXT '=' NEW TEXT ';'
        {
            $$ = (char*)calloc(sizeof($1) + EXTRA_SPACE, 1);
            sprintf($$, "%s %s = new %s();\n", $2, $3, $6);
        }
        ;

shiftRed5:
        '"' TEXT '"' ';'
        {
            $$ = (char*)calloc(EXTRA_SPACE, 1);
            sprintf($$, "\"%s\";", $2);
        }
        | callMethod ';'
        {
            $$ = (char*)calloc(sizeof($1) + EXTRA_SPACE, 1);
            sprintf($$, "%s;", $1);
            free($1);
        }
        ;

printStmt:
        PRINT '(' expression ')' ';'
        {
            $$ = (char*)calloc(sizeof($1) + sizeof($3) + EXTRA_SPACE, 1);
            sprintf($$, "System.out.println(%s);\n", $3);
            free($3);
        }
        ;

assignStmt:
        TEXT '=' expression ';'
        {
            $$ = (char*)calloc(sizeof($1) + sizeof($3) + EXTRA_SPACE, 1);
            sprintf($$, "%s = %s;\n", $1, $3);
            free($3);
        }
        | TEXT '[' INTEGER ']' '=' expression ';'
        {
            $$ = (char*)calloc(sizeof($1) + sizeof($3) + sizeof($6) + EXTRA_SPACE, 1);
            sprintf($$, "%s[%s] = %s;\n", $1, $3, $6);
            free($3);
        }
        ;

number:
    INTEGER
    {
        $$ = (char*)calloc(sizeof($1) + EXTRA_SPACE, 1);
        sprintf($$, "%s", $1);
        free($1);
    }
    |
    DECIMAL
    {
        $$ = (char*)calloc(sizeof($1) + EXTRA_SPACE, 1);
        sprintf($$, "%s", $1);
        free($1);
    }
    ;

expression:
        callMethod
        {
            $$ = $1;
        }
        | TEXT
        {
            $$ = (char*)calloc(EXTRA_SPACE, 1);
            strcpy($$, $1);
        }
        | number
        {
            $$ = (char*)calloc(sizeof($1) + EXTRA_SPACE, 1);
            sprintf($$, "%s", $1);
            free($1);
        }
        | expression op expression %prec OP
        {
            $$ = (char*)calloc(sizeof($1) + sizeof($2) + sizeof($3) + EXTRA_SPACE, 1);
            sprintf($$, " (%s)%s(%s) ", $1, $2, $3);
            free($1); free($2); free($3);
        }
        | TRUE
        {
            $$ = (char*)calloc(EXTRA_SPACE, 1);
            strcpy($$, "true");
        }
        | FALSE
        {
            $$ = (char*)calloc(EXTRA_SPACE, 1);
            strcpy($$, "false");
        }
        | '(' expression ')'
        {
            $$ = (char*)calloc(sizeof($2) + EXTRA_SPACE, 1);
            sprintf($$, "(%s)", $2);
            free($2);
        }
        | '"' expression '"'
        {
            $$ = (char*)calloc(sizeof($2) + EXTRA_SPACE, 1);
            sprintf($$, "\"%s\"", $2);
            free($2);
        }
        | atoiStmt
        {
            $$ = $1;
        }
        | TEXT '[' INTEGER ']'
        {
            $$ = (char*)calloc(sizeof($1) + sizeof($3) + EXTRA_SPACE, 1);
            sprintf($$, "%s[%s]", $1, $3);
        }
        | '!' expression
        {
            $$ = (char*)calloc(sizeof($2) + EXTRA_SPACE, 1);
            sprintf($$, "!(%s)", $2);
            free($2);
        }
        ;

atoiStmt:
        ATOI '(' expression ')'
        {
            $$ = (char*)calloc(sizeof($3) + EXTRA_SPACE, 1);
            sprintf($$, "Integer.parseInt(%s)", $3);
            free($3);
        }
        ;

callMethod:
        TEXT '.' TEXT '(' paramList ')'
        {
            $$ = (char*)calloc(sizeof($5) + EXTRA_SPACE, 1);
            sprintf($$, "%s.%s(%s)", $1, $3, $5);
            free($5);
        }
        | TEXT '(' paramList ')'
        {
            $$ = (char*)calloc(sizeof($1) + sizeof($3) + EXTRA_SPACE, 1);
            sprintf($$, "%s(%s)", $1, $3);
            free($3);
        }
        ;

paramList:
        params
        {
            $$ = $1;
        }
        |
        {
            $$ = (char*)calloc(EXTRA_SPACE, 1);
            strcpy($$, "");
        }
        ;

params:
        expression shiftRed4
        {
            $$ = (char*)calloc(sizeof($1) + sizeof($2) + EXTRA_SPACE, 1);
            sprintf($$, "%s%s", $1, $2);
            free($2);
        }
        ;

shiftRed4:
        ',' params
        {
            $$ = (char*)calloc(sizeof($2) + EXTRA_SPACE, 1);
            sprintf($$, ", %s", $2);
            free($2);
        }
        |
        {
            $$ = (char*)calloc(EXTRA_SPACE, 1);
        }
        ;

returnStmt:
        RETURN shiftRed3
        {
            $$ = (char*)calloc(sizeof($2) + EXTRA_SPACE, 1);
            sprintf($$, "return%s\n", $2);
            free($2);
        }
        ;

shiftRed3:
        ';'
        {
            $$ = (char*)calloc(EXTRA_SPACE, 1);
            strcpy($$, ";");
        }
        | expression ';'
        {
            $$ = (char*)calloc(sizeof($1) + EXTRA_SPACE, 1);
            sprintf($$, " %s;", $1);
            free($1);
        }
        ;

ifStmt:
        IF '(' expression ')' '{' block '}' elseStmt
        {
            $$ = (char*)calloc(sizeof($3) + sizeof($6) + sizeof($8) + EXTRA_SPACE, 1);
            sprintf($$, "if( %s ){\n%s } %s\n", $3, $6, $8);
            free($3); free($6); free($8);
        }
        ;


elseStmt:
        ELSE '{' block '}'
        {
            $$ = (char*)calloc(sizeof($3) + EXTRA_SPACE, 1);
            sprintf($$, "else {\n%s }", $3);
            free($3);
        }
        |
        {
            $$ = (char*)calloc(EXTRA_SPACE,1);
        }
        ;

whileStmt:
        WHILE '(' expression ')' '{' block '}'
        {
            $$ = (char*)calloc(sizeof($3) + sizeof($6) + EXTRA_SPACE, 1);
            sprintf($$, "while( %s ){\n%s }\n", $3, $6);
            free($3); free($6);
        }
        ;

dowhileStmt:
        DO '{' block '}' WHILE '(' expression ')'
        {
            $$ = (char*)calloc(sizeof($3) + sizeof($7) + EXTRA_SPACE, 1);
            sprintf($$, "do{\n%s } while( %s );\n", $3, $7);
            free($3); free($7);
        }
        ;

op:
        '&' '&'
        {
            $$ = (char*)calloc(EXTRA_SPACE,1);
            strcpy($$, "&&");
        }
        | '|' '|'
        {
            $$ = (char*)calloc(EXTRA_SPACE,1);
            strcpy($$, "||");
        }
        | '='
        {
            $$ = (char*)calloc(EXTRA_SPACE,1);
            sprintf($$, "=");
        }
        | '=' '='
        {
            $$ = (char*)calloc(EXTRA_SPACE,1);
            sprintf($$, "==");
        }
        | '=' '=' '='
        {
            $$ = (char*)calloc(EXTRA_SPACE,1);
            sprintf($$, ".equals");
        }
        | '+'
        {
            $$ = (char*)calloc(EXTRA_SPACE,1);
            strcpy($$, "+");
        }
        | '-'
        {
            $$ = (char*)calloc(EXTRA_SPACE,1);
            strcpy($$, "-");
        }
        | '/'
        {
            $$ = (char*)calloc(EXTRA_SPACE,1);
            strcpy($$, "/");
        }
        | '*'
        {
            $$ = (char*)calloc(EXTRA_SPACE,1);
            strcpy($$, "*");
        }
        | '%'
        {
            $$ = (char*)calloc(EXTRA_SPACE,1);
            strcpy($$, "%");
        }
        | '!' '='
        {
            $$ = (char*)calloc(EXTRA_SPACE,1);
            sprintf($$, "!=");
        }
        | '>'
        {
            $$ = (char*)calloc(EXTRA_SPACE,1);
            sprintf($$, ">");
        }
        | '>' '='
        {
            $$ = (char*)calloc(EXTRA_SPACE,1);
            sprintf($$, ">=");
        }
        | '<'
        {
            $$ = (char*)calloc(EXTRA_SPACE,1);
            sprintf($$, "<");
        }
        | '<' '='
        {
            $$ = (char*)calloc(EXTRA_SPACE,1);
            sprintf($$, "<=");
        }
        ;

%%

int main(int argc, char *argv[]) {
    if(argc>0){
        yyin = fopen(argv[1], "r");
        if(argv[2]!=0){
            filename = argv[2];
        }else{
            filename = "My_Subjective_C_Program";
        }
    }
    else{
        yyin = stdin;
        filename = "My_Subjective_C_Program";
    }
    yyparse();
    if(argc>0){
        fclose(yyin);
    }
    return 0;
}

void createFile(char* class, char* main, char* otherMethods){
    int filename_size = 50;
    char *block, *command;
    char *fil, *filjava, *filclass, *filjar;

    block = (char*)calloc(sizeof(class) + sizeof(main) + sizeof(otherMethods) + EXTRA_SPACE, 1);
    command = (char*)calloc(EXTRA_SPACE, 1);

    fil = (char*)calloc(filename_size, 1);
    filjava = (char*)calloc(filename_size, 1);
    filjar = (char*)calloc(filename_size, 1);

    FILE *fp;

    filename[0] = toupper(filename[0]);

    strcpy(fil, filename);
    strcpy(filjava, filename);
    strcpy(filjar, filename);

    strcat(filjava, ".java");
    strcat(filjar, ".jar");

    strcat(block, class);
    strcat(block, "public class ");
    strcat(block, filename);
    strcat(block, " {\n\n");
    strcat(block, main);
    strcat(block, otherMethods);
    strcat(block, "}");

    fp = fopen(filjava, "w+");
    fputs(block, fp);
    fclose(fp);

    /* Compile and create jar file */
    sprintf(command, "javac -g %s", filjava);
    system(command);
    // Indent Java file
    sprintf(command, "java -classpath drjava.jar edu.rice.cs.drjava.IndentFiles %s", filjava);
    system(command);
    sprintf(command, "jar cfe %s %s *.class", filjar, fil);
    system(command);
    /* Remove unnecessary generated files */
    sprintf(command, "rm *.class");
    system(command);
    /* Execute generated jar */
    //sprintf(command, "java -jar %s", filjar);
    //system(command);

    free(block);
    free(command);
    free(fil);
    free(filjava);
    free(filjar);
    free(class);
    free(main);
    free(otherMethods);
    return;
}
