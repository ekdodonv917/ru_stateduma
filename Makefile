zippedsrc := $(shell git ls-files *.7z)
csvs := $(patsubst %.7z,%,$(zippedsrc))

%.csv: %.csv.7z
	7z e $< && touch $@

lem/%.txt: txt/%.txt
	test -d lem || mkdir -p lem
	mystem -n -l -d $< > $@

all: lemmatize

unzip: $(csvs)

extract: $(csvs)
	test -d txt || mkkdir -p txt
	for f in $^ ; do python3 scripts/extract_txt.py $$f txt/ ; done

lemmatize: $(patsubst txt/%.txt,lem/%.txt,$(wildcard txt/*.txt))
