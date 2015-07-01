LEX = lex
YACC = yacc
YFLAGS = -d -v
CC = cc
CFLAGS = -ll
OBJECTS = test.o

compiler:
	@echo "Compiling YACC..."
	@$(YACC) $(YFLAGS) subjectivec.y
	@echo "Compiling LEX..."
	@$(LEX) subjectivec.l
	@echo "Creating compiler..."
	@$(CC) y.tab.c lex.yy.c -o scc $(CFLAGS)
	@mv ./scc ../.

debug:
	@echo "Compiling YACC..."
	@$(YACC) $(YFLAGS) subjectivec.y
	@echo "Compiling LEX..."
	@$(LEX) -d subjectivec.l
	@echo "Creating compiler..."
	@$(CC) y.tab.c lex.yy.c -o scc $(CFLAGS)
	@mv ./scc ../.

clean:
	$(RM) lex.yy.c y.tab.c y.tab.h y.output
