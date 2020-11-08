default: fizzbuzz

fizzbuzz: fizzbuzz.ll
	llc ./fizzbuzz.ll
	clang fizzbuzz.s -o fizzbuzz