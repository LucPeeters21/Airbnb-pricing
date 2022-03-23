PREPARATION = ../src/data-preparation
ANALYSIS = ../src/analysis
DATA = ../data

all: analysis data-preparation clean

data-preparation:
	make -C $(PREPARATION)

analysis: data-preparation
	make -C $(ANALYSIS)

clean:
	-rm -r .DS_Store
	-rm -r $(DATA)


