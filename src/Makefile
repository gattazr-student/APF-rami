# Makefile
EXECUTABLES=main
EXECUTABLES_TST=tests_me tests_dico

MODULES=regle
CMIS=$(foreach lib, $(MODULES), $(addprefix $(lib),.cmi))
MLIS=$(foreach lib, $(MODULES), $(addprefix $(lib),.mli))

LIBS=multiEnsemble dictionnaire rummikub rami jeu
CMOS=$(foreach lib, $(LIBS), $(addprefix $(lib),.cmo))

# ENVIRONMENT
OCAMLC=ocamlc

# BUILD RULES
all: $(EXECUTABLES)

%: $(CMOS) %.cmo $(MLIS)
	$(OCAMLC) -o $@ $^

main.cmo: main.ml
	$(OCAMLC) -c $<

# Dependencies
multiEnsemble.cmo: multiEnsemble.ml multiEnsemble.cmi
	$(OCAMLC) -c $<
multiEnsemble.cmi: multiEnsemble.mli
	$(OCAMLC) -c $<

dictionnaire.cmo: dictionnaire.ml dictionnaire.cmi
	$(OCAMLC) -pp camlp4o.opt -c $<
dictionnaire.cmi: dictionnaire.mli
	$(OCAMLC) -c $<

rummikub.cmo: rummikub.ml rummikub.cmi
	$(OCAMLC) -c $<
rummikub.cmi: rummikub.mli multiEnsemble.cmi regle.cmi
	$(OCAMLC) -c $<

rami.cmo: rami.ml rami.cmi
	$(OCAMLC) -c $<
rami.cmi: rami.mli multiEnsemble.cmi regle.cmi
	$(OCAMLC) -c $<

regle.cmi: regle.mli
	$(OCAMLC) -c $<

jeu.cmo: jeu.ml jeu.cmi regle.cmi
	$(OCAMLC) -c $<
jeu.cmi: jeu.mli
	$(OCAMLC) -c $<


# building tests
test: $(EXECUTABLES_TST)

tests_me.cmo: tests_me.ml multiEnsemble.cmi
	$(OCAMLC) -c $<

tests_dico.cmo: tests_dico.ml dictionnaire.cmi
	$(OCAMLC) -c $<

# CLEANING RULES
clean:
	rm -f $(foreach lib, $(MODULES), $(addprefix $(lib),.cmi))
	rm -f $(foreach lib, $(LIBS), $(addprefix $(lib),.cma .cmi .cmo))
	rm -f $(foreach lib, $(EXECUTABLES), $(addprefix $(lib),.cma .cmi .cmo))
	rm -f $(foreach lib, $(EXECUTABLES_TST), $(addprefix $(lib),.cma .cmi .cmo))

mrproper: clean
	rm -f $(EXECUTABLES) $(EXECUTABLES_TST)

.PHONY: all clean mrproper

