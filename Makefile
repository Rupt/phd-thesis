# build a pdflatex document
PDFLATEX := pdflatex -output-directory=scratch \
	-file-line-error -interaction=batchmode

BIBTEX := bibtex -terse

SOFT := \\documentclass[bindnopdf]{minithesis}
HARD := \\documentclass[oneside]{minithesis}


.PHONY: main
main: main.pdf


.PHONY: all
all: main.pdf main_soft.pdf main_hard.pdf


# first pdflatex call creates .aux
# repeated calls are required to get references right
# -file-line-error tags errors with a flag we can grep for
# bibtex creates a .bbl from .aux and context
%.pdf: %.tex ALWAYS_REBUILD
	@rm -rf scratch/$*.* && mkdir -p scratch/
	-$(PDFLATEX) -draftmode $< > /dev/null
	@! grep -E -A5 '^\.\/.+.tex:[0-9]+: ' scratch/$*.log
	-$(BIBTEX) scratch/$*.aux
	$(PDFLATEX) -draftmode $< > /dev/null
	$(PDFLATEX) $< > /dev/null
	@mv scratch/$*.pdf .


# alternative builds
%_soft.tex: %.tex
	sed 's=\\documentclass.*=$(SOFT)=' $< > $@


%_hard.tex: %.tex
	sed 's=\\documentclass.*=$(HARD)=' $< > $@


.PHONY: clean
clean:
	rm -rf scratch *.pdf


.PHONY: ALWAYS_REBUILD
ALWAYS_REBUILD:

