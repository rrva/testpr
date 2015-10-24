.PHONY: all
all: hello1

hello1: hello1.cpp
	g++ -o hello1 hello1.cpp

.PHONY: install
install:
	mkdir -p bin
	cp -p hello1 bin

.PHONY: clean 
clean:
	rm -f hello1
