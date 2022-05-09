# build a pdflatex document
PDFLATEX := TEXINPUTS=./tex//: pdflatex \
	-output-directory=scratch \
	-file-line-error \
	-interaction=batchmode

BIBTEX := bibtex -terse


.PHONY: main
main: main.pdf


# first pdflatex call creates .aux
# bibtex creates a .bbl from .aux and context
# repeated calls are required to get references right
%.pdf: %.tex ALWAYS_REBUILD
	@mkdir -p scratch
	-$(PDFLATEX) -draftmode $< > /dev/null
	@! grep -E -A5 '^\.\/.+.tex:[0-9]+: ' scratch/$*.log
	-$(BIBTEX) scratch/$*.aux
	$(PDFLATEX) -draftmode $< > /dev/null
	$(PDFLATEX) $< > /dev/null
	@mv scratch/$*.pdf .


.PHONY: clean
clean:
	rm -rf scratch *.pdf


.PHONY: ALWAYS_REBUILD
ALWAYS_REBUILD:
