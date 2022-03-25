all: data-preparation analysis pricing-app

data-preparation:
	make -C src/data-preparation

analysis: data-preparation
	make -C src/analysis

pricing-app: analysis
	make -C src/pricing-app

clean:
	-rm -r data


