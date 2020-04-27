zippedsrc := $(shell git ls-files *.7z)
csvs := $(patsubst %.7z,%,$(zippedsrc))
convocations := $(patsubst %.csv,%,$(csvs))

%.csv: %.csv.7z
	7z e $< && touch $@

lem/%.txt: txt/%.txt
	test -d lem || mkdir -p lem
	mystem -n -l -d $< > $@

w2v/%.300.tsv: lem/%.all.txt
	test -d w2v || mkdir -p w2v
	word2vec -train $< -output $@ -size 300 -window 5 -binary 0 -cbow 0

all: extract lemmatize convocations-txt w2v-convocations

unzip: $(csvs)

extract: $(csvs)
	test -d txt || mkkdir -p txt
	for f in $^ ; do python3 scripts/extract_txt.py $$f txt/ ; done

lemmatize: $(patsubst txt/%.txt,lem/%.txt,$(wildcard txt/*.txt))

convocations-txt: lemmatize
	for c in $(convocations); do cat lem/$$c.[0-9]*.txt > lem/$$c.all.txt ; done 

w2v-convocations: $(patsubst %,w2v/%.300.tsv,$(convocations))
