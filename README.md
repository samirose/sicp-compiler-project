# Scheme to WAT/WASM compiler

In spirit of [SICP](https://mitpress.mit.edu/sites/default/files/sicp/index.html) exercises [5.49](https://mitpress.mit.edu/sites/default/files/sicp/full-text/book/book-Z-H-35.html#%_thm_5.49)-52.

* The compiler is based on the Scheme to register machine compiler from [SICP section 5.5](https://mitpress.mit.edu/sites/default/files/sicp/full-text/book/book-Z-H-35.html#%_sec_5.5)
* WASM stands for [WebAssembly](https://webassembly.org)
* WAT is the [WebAssembly Text format](https://webassembly.github.io/spec/core/text/index.html#)

## Goals

* Implement the compiler in [Scheme](https://en.wikipedia.org/wiki/Scheme_(programming_language)) [R6RS](http://www.r6rs.org), using [Racket](https://racket-lang.org) as the development platform
* Learn about Scheme and compilation of functional languages in general
* Get familiar with WebAssembly as an execution environment and compiler target
* Stay in the spirit of simple Scheme and target initially supporting a subset of [R7RS-small Scheme](https://r7rs.org)
* Implement as much of the required run-time support in Scheme as possible
* Write the required native run-time support in WAT
* Use only basic, standardised [WASM core](https://www.w3.org/TR/wasm-core-1/) features initially
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
* Port the compiler from Racket `#lang sicp` to standard R6RS Scheme (still using Racket as the development platform)
* A simple compiler "driver" that can be given a Scheme program from standard input and that emits a WASM module to standard output in WAT format
* Add Makefile for building the compiler and regression test execution
* Add regression tests for the implemented features
  * Tests are specified in WAST and executed with [WABT](https://github.com/WebAssembly/wabt)'s [spectest-interp](https://webassembly.github.io/wabt/doc/spectest-interp.1.html) tool
  * The tests invoke the compiler with a Scheme expression, compile it and check the executed WebAssembly's result with WAST assertions
  * See [wasm-compiler/test] for the tests
* Compilation of Scheme R7RS library to a WASM module with the top-level code in an exported `func` "main"
* Top-level `define` of values and procedures
* `set!` top-level and in-scope binding values

## Known issues
* Open coding of numerical comparison operators produces incorrect results when the operator is applied to more than two parameters
* The Scheme values are not type checked in the compiled programs: a number can be used as a procedure reference and vice-versa. Using of uninitialized values is not detected.

## Features currently under work

## Rough backlog

* Come up with a name for this project
* Add support for exported top-level definitions with R7RS libary syntax. The exports can be used for writing more comprehensive tests with multiple calls to the exported procedures and asserting the return values.
* Implement local bindings (`let` forms), with WASM locals instead of `lambda`, if possible.
* _Scan out_ (see [SICP chapter 4.16](https://mitpress.mit.edu/sites/default/files/sicp/full-text/book/book-Z-H-26.html#%_sec_4.1.6)) internal definitions and implement the bindings with `letrec*`
* Add support for allocating local temporary variables. They will be needed in the implementation of `and` and `or` expressions for retaining the expression's value. See also [#1102 dup instruction](https://github.com/WebAssembly/design/issues/1102).
* Add compilation of `and` and `or` expressions. They can be implemented with WASM block structure and conditional branch instructions.
* Restrict numerical comparison operators to two parameters (see [Known issues](#known-issues)) and add support for the currently missing operators
* Optional: Implement support for numerical comparison operators with more than two parameters by compiling them as an `and` expression
* Compile `cond` as WASM block structure and conditional branch instructions instead of the current nested if expressions.
* Add high-level design document of the compiler
* Add bit tagged typing to values and type predicates: `number?`, `procedure?` and uninitialized value and add type checking to generated code. (see [Known issues](#known-issues))
* Add support for read-only symbols and strings
* Add run-time support for rudimentary heap-based values: vectors, pairs
* Implement simple garbage collection using [SICP section 5.3](https://mitpress.mit.edu/sites/default/files/sicp/full-text/book/book-Z-H-33.html#%_sec_5.3) as a guideline in WAT
* Implement lexical [closures](https://en.wikipedia.org/wiki/Closure_(computer_programming)) with function activation records as vector lists on the heap
* More R7RS-small features, prioritisation TBD.
