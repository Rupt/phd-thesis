# build with pdflatex

.PHONY: main
main: main.pdf


.PHONY: all
all: main.pdf main.soft.pdf main.hard.pdf


# first pdflatex call creates .aux
# repeated calls are required to get references right
# -file-line-error tags errors with a flag we can grep for
# bibtex creates a .bbl from .aux and context
PDFLATEX := pdflatex -output-directory=scratch \
	-file-line-error -interaction=batchmode

%.pdf: %.tex ALWAYS_REBUILD
	@rm -rf scratch/$*.* && mkdir -p scratch/
	-$(PDFLATEX) -draftmode $< > /dev/null
	@! grep -E -A5 '^\.\/.+.tex:[0-9]+: ' scratch/$*.log
	-bibtex -terse scratch/$*.aux
	$(PDFLATEX) -draftmode $< > /dev/null
	$(PDFLATEX) $< > /dev/null
	@mv scratch/$*.pdf .


# make alternative builds by replacing the documentclass
# for Cambridge soft-bound version
%.soft.tex: %.tex
	sed 's=\\documentclass.*=\\documentclass[bindnopdf]{minithesis}=' $< > $@


# for Cambridge hard-bound version, which must be one-sided
%.hard.tex: %.tex
	sed 's=\\documentclass.*=\\documentclass[oneside]{minithesis}=' $< > $@


.PHONY: clean
clean:
	rm -rf scratch *.pdf


.PHONY: ALWAYS_REBUILD
ALWAYS_REBUILD:
