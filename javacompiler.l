%{
#include "headerfiles.h"
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <math.h>
#include <string.h>
int lineNumber=1; 
int importCount = 0;
int staticCount = 0;
int classCount = 0;
int voidCount = 0;
int eofCount = 0;
int lineInit=-1; 
int errorCount = 0; 
int wordCount = 0;
int printlnCount = 0;
int otherTokensCount= 0;
int tokenCount = 0;
int publicCount = 0;
int elseCount = 0;
char str_buf[MAX_STR_CONST]; 
char* str_buf_ptr; 
extern int yylval;
void yyerror(char *message, int type);
void TPRINT(int token_id);
%}
%option noyywrap
%option yylineno
%x STATE_COMMENT
%x STATE_INLINE_COMMENT
%x STATE_STRING
LETTER [a-zA-Z]
DIGIT [0-9]
BINDIGIT [01]
OCTDIGIT [0-7]
HEXDIGIT [0-9A-F]
NZDIGIT [1-9]{DIGIT}*
EXPONENT E[+-]?(0|{NZDIGIT})
ALPHANUM ({LETTER}|{DIGIT})
ALPHANUM_ ({ALPHANUM}|_)
WHITESPACE [ \t]
%%


"import" {TPRINT(T_IMPORT); return T_IMPORT;}
"public" {TPRINT(T_PUBLIC); return T_PUBLIC;}
"class" {TPRINT(T_CLASS); return T_CLASS;}
"static" {TPRINT(T_STATIC); return T_STATIC;}
"if" {TPRINT(T_IF);  return T_IF;}
"else" {TPRINT(T_ELSE); return T_ELSE;}
"void" {TPRINT(T_VOID); return T_VOID;}
"System.out.println" {TPRINT(T_PRINTLN); return T_PRINTLN;}


<INITIAL><<EOF>> {TPRINT(T_EOF); return T_EOF;}
<STATE_STRING>\n {yyerror("UNRECOGNIZED STRING INPUT", 1); return 0;}

%%
int main(int argc, char *argv[]){
	int token;
	double staticPer;
	double publicPer;
	double elsePer;
	double importPer;
	double classPer;
	double voidPer;
	double printlnPer;
	double otherTokensPer;
	if(argc > 1){
		yyin = fopen(argv[1], "r");
	
		if (yyin == NULL){
			perror ("FILE NOT FOUND"); return -1;
		}
	}
	do{
		token = yylex();
		tokenCount++;
		switch (token){
			case 14:
				publicCount++;
				break;
			case 10:
				elseCount++;
				break;
			case 44:
				printlnCount++;
				break;
			case 11:
				importCount++;
				break;
			case 29:
				classCount++;
				break;
			case 27:
				staticCount++;
				break;
			case 33:
				voidCount++;
				break;
			default:
				otherTokensCount++;
				break;
		}
		
	}while(token != T_EOF);
	if(errorCount > 0){
		printf("PROGRAM ANALYZED UNSUCCESSFULL | %d ERRORS\n", errorCount);
	}else{
		printf("PROGRAM ANALYZED SUCCESSFULLY\n");
	}	
	fclose(yyin);
	printf("%d\n",tokenCount);
	staticPer = ((double)staticCount / (double)tokenCount) * 100;
	publicPer = ((double)publicCount / (double)tokenCount) * 100;
	elsePer = ((double)elseCount / (double)tokenCount) * 100;
	importPer = ((double)importCount / (double)tokenCount) * 100;
	classPer = ((double)classCount / (double)tokenCount) * 100;
	voidPer = ((double)voidCount / (double)tokenCount) * 100;
	printlnPer = ((double)printlnCount / (double)tokenCount) * 100;
	otherTokensPer = ((double)otherTokensCount / (double)tokenCount) * 100;
	printf("---------------------\n");
	printf("STATIC FOUND: %d TIMES\n",staticCount);
	printf("PUBLIC FOUND: %d TIMES\n",publicCount);
	printf("ELSE FOUND: %d TIMES\n",elseCount);
	printf("IMPORT FOUND: %d TIMES\n",importCount);
	printf("CLASS FOUND: %d TIMES\n",classCount);
	printf("VOID FOUND: %d TIMES\n",voidCount);
	printf("SYSTEM.OUT.PRINTLN FOUND: %d TIMES\n",printlnCount);
	printf("OTHER TOKENS FOUND: %d TIMES\n",otherTokensCount);
	printf("---------------------\n");
	printf("TOTTALY RECOGNIZED TOKENS: %d \n", tokenCount);
	printf("STATIC TOKEN HAS: %.2f %% OF RECOGNIZED TOKENS \n", staticPer);
	printf("PUBLIC TOKEN HAS: %.2f %% OF RECOGNIZED TOKENS \n", publicPer);
	printf("ELSE TOKEN HAS: %.2f %% OF RECOGNIZED TOKENS \n", elsePer);
	printf("IMPORT TOKEN HAS: %.2f %% OF RECOGNIZED TOKENS \n", importPer);
	printf("CLASS TOKEN HAS: %.2f %% OF RECOGNIZED TOKENS \n", classPer);
	printf("VOID TOKEN HAS: %.2f %% OF RECOGNIZED TOKENS \n", voidPer);
	printf("SYSTEM.OUT.PRINTLN TOKEN HAS: %.2f %% OF RECOGNIZED TOKENS \n", printlnPer);
	printf("OTHER TOKENS HAVE: %.2f %% OF RECOGNIZED TOKENS \n", otherTokensPer);
	yyterminate();
}

void yyerror(char *message, int type)
{
	errorCount++;
	if(type==0){
		printf("!!! ERROR AT LINE %d CAUSED BY %s: %s\n", lineNumber, yytext, message);
	}
	else if(type==1){
		*str_buf_ptr = '\0';
		printf("!!! ERROR AT LINE %d NEAR \"%s\": %s\n", lineNumber, str_buf, message);
	}
	if(MAX_ERRORS <= 0) return;
	if(errorCount == MAX_ERRORS){
	printf("MAX ERRORS DETECTED\n");
	exit(-1);
}}


void TPRINT(int token_id){
	if(FLEX_DEBUG && SHOW_TOKENS)
	{
		printf("TOKEN FOUND: %s | DEFINE:%d | LINE: %d\n", yytext, token_id, lineNumber);
	}
}

