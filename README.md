# Scheme to WAT/WASM compiler

In spirit of [SICP](https://mitpress.mit.edu/sites/default/files/sicp/index.html) exercises [5.49](https://mitpress.mit.edu/sites/default/files/sicp/full-text/book/book-Z-H-35.html#%_thm_5.49)-52.

* The compiler is based on the Scheme to register machine compiler from [SICP section 5.5](https://mitpress.mit.edu/sites/default/files/sicp/full-text/book/book-Z-H-35.html#%_sec_5.5)
* WASM stands for [WebAssembly](https://webassembly.org)
* WAT is the [WebAssembly Text format](https://webassembly.github.io/spec/core/text/index.html#)

## Goals

* Implement the compiler in [Scheme](https://en.wikipedia.org/wiki/Scheme_(programming_language)) [R6RS](http://www.r6rs.org), using [Racket](https://racket-lang.org) as the development platform
* Learn about Scheme and compilation of functional languages in general
* Get familiar of WebAssembly as an execution environment and compiler target
* Stay in the spirit of simple Scheme of SICP and use as little of R6RS as possible
* Implement as much of the required run-time support in Scheme as possible
* Write the required native run-time support in WAT
* Use only basic, standardised WASM features initially
* Compile a Scheme interpreter to WASM using the compiler (see also [SICP exercise 5.52](https://mitpress.mit.edu/sites/default/files/sicp/full-text/book/book-Z-H-35.html#%_thm_5.52))
* If the interpreter works, host it on a web page with minimal JavaScript-driven [REPL](https://en.wikipedia.org/wiki/Read–eval–print_loop)
* _Maybe_ try to [bootstrap](https://en.wikipedia.org/wiki/Bootstrapping_(compilers)) the compiler at some point as an interesting exercise

## Non-goals

* Build a full-blown implementation with robust error reporting, tooling, full Scheme libarary support etc.
* Good interoperability with JavaScript is not critical, except where it helps in testing the compiler or hosting an interpreter or the compiler on the Web
* Do not aim to replace JavaScript on the Web

## Implemented features

* Compilation of 32-bit integer values and open-coded application of + - * / = operators
* Scheme if statement to WASM if statement
* Compilation of lambda expressions to WASM functions and values that can be applied to arguments
* Compilation of Scheme to a WASM module with the top-level code in an exported `func` "main"
* Port the compiler from Racket `#lang sicp` to standard R6RS Scheme (still using Racket as the development platform)

## Features currently under work

## Rough backlog

* Implement a simple compiler "driver" that can be given a program from standard input and that emits a WASM module to standard output
* Add a few automated tests of the compiler using the driver
* Implement support for top-level definitions. _Scan out_ (see [SICP chapter 4.16](https://mitpress.mit.edu/sites/default/files/sicp/full-text/book/book-Z-H-26.html#%_sec_4.1.6)) internal definitions.
* Export top-level definitions from the WASM module
* Add run-time support for rudimentary heap-based values: vectors, pairs
* Implement simple garbage collection using [SICP section 5.3](https://mitpress.mit.edu/sites/default/files/sicp/full-text/book/book-Z-H-33.html#%_sec_5.3) as a guideline in WAT
* Implement lexical [closures](https://en.wikipedia.org/wiki/Closure_(computer_programming)) with function activation records as vector lists on the heap
