#VARIABLES

INSTALL		= install
PROGRAMS 	= yumpkgs
VERSION		= HEAD
REVCHANGES	= 20

#TARGETS

.PHONY: all help release

#all: generate the programs and some other targets
all: $(PROGRAMS)

#help: display this message
help:
	@echo -e "Some useful targets are:\n"
	@grep -E '^#[^:]+:' Makefile|tr -d '#'
	@echo ''

#run: run every compiled program
run: $(PROGRAMS)
	for p in $(PROGRAMS);do \
		echo Program: $$p;\
		./$$p; \
	done

#release VERSION=<version>(ex.: v0.04): make a release
release:
	git archive --format=zip -o releases/yumpkgs-$(VERSION).zip $(VERSION)
	echo "<p>This is automatically generated whenever a new release is built.</p>Bellow are $(REVCHANGES) revision changes until the release of this version.<pre class=\"cli\">" > blogger-post.html
	git log $(VERSION) -$(REVCHANGES) >> blogger-post.html
	echo "</pre><p>The release can be downloaded from here: <a href=\"http://github.com/gtuxed/yumpkgs/raw/master/releases/yumpkgs-$(VERSION).zip\">yumpkgs-$(VERSION).zip</a>." >> blogger-post.html
	git add releases/yumpkgs-$(VERSION).zip
	git commit -m "Release $(VERSION)"
	git push github
	google blogger post -n "yumpkgs-$(VERSION)" -t "yumpkgs,FOSS,Windows,English" blogger-post.html

#install: install the programs
install:
	for p in $(PROGRAMS);do \
		$(INSTALL) $$p /usr/bin/; \
	done

#clean: clean files generated by this makefile
clean:
	rm -f *~
