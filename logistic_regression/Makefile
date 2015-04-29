all: logistic_regression

logistic_regression: porter_stemmer.c main.cc
	g++ -std=c++11 -w -O3 -o logistic_regression porter_stemmer.c main.cc

clean:
	rm -f *.o logistic_regression
