all:
	@cd compiler; make compiler

debug:
	@cd compiler; make debug

clean:
	$(RM) scc
	@cd compiler; make clean