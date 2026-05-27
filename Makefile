.PHONY: all build clean run test

all: build

build:
	gleam build

run:
	gleam run

test:
	gleam test

clean:
	gleam clean
