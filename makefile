all: data-preparation

data-preparation:
	make -C src/data-preparation

clean:
	-rm -r data