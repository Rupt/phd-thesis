# build with pdflatex

.PHONY: all
all: main.pdf main.soft.pdf main.hard.pdf


.PHONY: draft
draft: main.pdf


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
	@mv scratch/$@ .


# make alternative builds by replacing the documentclass
# for Cambridge soft-bound version
%.soft.tex: %.tex
	sed 's=\\documentclass.*=\\documentclass[bindnopdf]{minithesis}=' $< > $@


# for Cambridge hard-bound version, which must be one-sided
%.hard.tex: %.tex
	sed 's=\\documentclass.*=\\documentclass[oneside]{minithesis}=' $< > $@


# Awful hack for latexdiff
main_diff.pdf: main_diff.tex main.bbl

main_diff.tex: main.tex
	latexdiff --flatten --ignore-warnings ../thesis_v1.1/main.tex main.tex > main_diff.tex 2> /dev/null

main.bbl: scratch/main.bbl
	cp scratch/main.bbl .

scratch/main.bbl: main.pdf


.PHONY: clean
clean:
	rm -rf scratch *.pdf main_diff.tex main.bbl


.PHONY: ALWAYS_REBUILD
ALWAYS_REBUILD:
