# Generate thesis pdfs
# Initial experimentation

PDFLATEXARGS='-interaction=batchmode'
BIBTEXARGS='-terse'

batch: hello_world.tex
	# Repeated executions correct cross-references.
	TEXINPUTS="tex//:${TEXINPUTS}"; \
	    pdflatex $(PDFLATEXARGS) $< > /dev/null && \
	    bibtex $(BIBTEXARGS) hello_world && \
	    pdflatex $(PDFLATEXARGS) $< > /dev/null && \
	    pdflatex $(PDFLATEXARGS) $< > /dev/null

debug: hello_world.tex
	# Repeated executions correct cross-references.
	TEXINPUTS="tex//:${TEXINPUTS}"; \
	    pdflatex $< && \
	    bibtex hello_world && \
	    pdflatex $< && \
	    pdflatex $<

clean:
	rm -f hello_world.pdf hello_world.log hello_world.aux hello_world.blg \
	    hello_world.bbl

.PHONY: clean
