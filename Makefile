# build a pdflatex document
PDFLATEX = TEXINPUTS=./tex//: pdflatex \
	-output-directory=scratch \
	-file-line-error

BIBTEX = bibtex -terse


.PHONY: main
main: main.pdf


.PHONY: debug
debug: main.debug


# first pdflatex call creates .aux and is flagged %.first
# bibtex creates a .bbl from .aux and context
# repeated calls are required to get references right
%.pdf: %.tex bib.bib
	@mkdir -p scratch
	$(PDFLATEX) -interaction=batchmode -draftmode $< > /dev/null
	-$(BIBTEX) scratch/$*.aux
	$(PDFLATEX) -interaction=batchmode -draftmode $< > /dev/null
	$(PDFLATEX) -interaction=batchmode $< > /dev/null
	@mv scratch/$*.pdf .


# make %.pdf while flooding stdout
.PHONY: %.debug
%.debug: %.tex bib.bib # -> %.pdf
	@mkdir -p scratch
	$(PDFLATEX) -interaction=nonstopmode -draftmode $<
	-$(BIBTEX) scratch/$*.aux
	$(PDFLATEX) -interaction=nonstopmode -draftmode $<
	$(PDFLATEX) -interaction=nonstopmode $<
	@mv scratch/$*.pdf .


.PHONY: clean
clean:
	rm -rf scratch *.pdf
