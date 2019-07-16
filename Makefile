
#### Generated image files ####

DOT_GEN_FILES = $(patsubst %.dot, %.png, $(wildcard dot/*.dot))
SVG_GEN_FILES = $(patsubst %.svg, %.png, $(wildcard svg/*.svg))
MSC_GEN_FILES = $(patsubst %.msc, %.png, $(wildcard msc/*.msc))
ALL_GEN_FILES = ${DOT_GEN_FILES} ${SVG_GEN_FILES} ${MSC_GEN_FILES}

#### Primary targets ####

TARGETS = ssp21-iki.html ssp21-iki.pdf

default: $(TARGETS)

clean:
	rm -f $(TARGETS) $(ALL_GEN_FILES)

#### Use pandoc to create PDF and HTML ####

ssp21.html: report.md template_pandoc.html markdown.css Makefile $(ALL_GEN_FILES)
	pandoc report.md -s --toc --toc-depth=5 --number-sections \
		--metadata date="`./get_date_and_revision.sh`" \
		-f markdown+yaml_metadata_block+startnum \
		--filter pandoc-fignos \
		--template template_pandoc.html \
		--css=markdown.css \
		-o index.html

ssp21.pdf: report.md template_pandoc.latex Makefile $(ALL_GEN_FILES)
	pandoc report.md -s --toc --toc-depth=5 --number-sections \
		--metadata date="`./get_date_and_revision.sh`" \
		-f markdown+yaml_metadata_block+startnum \
		--filter pandoc-fignos \
		--template template_pandoc.latex \
		-V colorlinks \
		--highlight-style=monochrome \
		-o ssp21.pdf

#### Wildcard rules for generating PNGs from source formats ####

dot/%.png: dot/%.dot Makefile
	mkdir -p img/dot
	dot -Tpng -o ./img/$@ $<

msc/%.png: msc/%.msc Makefile
	mkdir -p img/msc
	mscgen -T png -i $< -o ./img/$@

svg/%.png: svg/%.svg Makefile
	mkdir -p img/svg
	inkscape -z -e ./img/$@ $<
