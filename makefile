all: analysis data-preparation data-collection

data-collection:
	make -c src/data-collection

data-preparation:
	make -C src/data-preparation

analysis: data-preparation
	make -C src/analysis

clean:
	-rm -r data
	-rm -r gen



