.PHONY: all
all: hello2

hello2: hello2.cpp
	g++ -o hello2 hello2.cpp

.PHONY: install
install:
	mkdir -p bin
	cp -p hello2 bin

.PHONY: clean 
clean:
	rm -f hello2
