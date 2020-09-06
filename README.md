# Scheme to WAT/Wasm compiler

In spirit of [SICP](https://mitpress.mit.edu/sites/default/files/sicp/index.html) exercises [5.49](https://mitpress.mit.edu/sites/default/files/sicp/full-text/book/book-Z-H-35.html#%_thm_5.49)-52.

* The compiler is based on the Scheme to register machine compiler from [SICP section 5.5](https://mitpress.mit.edu/sites/default/files/sicp/full-text/book/book-Z-H-35.html#%_sec_5.5)
* Wasm stands for [WebAssembly](https://webassembly.org)
* WAT is the [WebAssembly Text Format](https://webassembly.github.io/spec/core/text/index.html#)

## Goals

* Implement the compiler in [Scheme](https://en.wikipedia.org/wiki/Scheme_(programming_language)) [R6RS](http://www.r6rs.org), using [Racket](https://racket-lang.org) as the development platform
* Learn about Scheme and compilation of functional languages in general
* Get familiar with WebAssembly as an execution environment and compiler target
* Stay in the spirit of simple Scheme and target initially to support a subset of [R7RS-small Scheme](https://r7rs.org)
* Compile Scheme forms directly to as idiomatic Wasm as feasible
* Use only basic, standardised [Wasm core](https://www.w3.org/TR/wasm-core-1/) features initially
* Implement as much of the required run-time support in Scheme as possible
* Write the required native run-time support in WAT
* Compile a Scheme interpreter to Wasm using the compiler (see also [SICP exercise 5.52](https://mitpress.mit.edu/sites/default/files/sicp/full-text/book/book-Z-H-35.html#%_thm_5.52))
* If the interpreter works, host it on a web page with minimal JavaScript-driven [REPL](https://en.wikipedia.org/wiki/Read–eval–print_loop)
* _Maybe_ try to [bootstrap](https://en.wikipedia.org/wiki/Bootstrapping_(compilers)) the compiler at some point as an interesting exercise

## Non-goals

* Build a full-blown implementation with robust error reporting, tooling, full Scheme libarary support etc.
* Good interoperability with JavaScript is not critical, except where it helps in testing the compiler or hosting an interpreter or the compiler on the Web
* Do not aim to replace JavaScript on the Web

## Running

Required tools:
* GNU Make
* [Racket](https://racket-lang.org) with [R6RS support](https://docs.racket-lang.org/r6rs/index.html) (Other R6RS supporting Schemes may work too, but the Makefile at least will need modification)
* [WABT](https://github.com/WebAssembly/wabt) for running the compiler tests as defined in the Makefile. Compiler's output can be tested with any Wasm tooling that provides a WAT to Wasm assembler and a Wasm runtime.

On macOS the built-in `make` is sufficient. Racket and WABT can be installed with [Homebrew](https://brew.sh).

* Run `make` to compile the compiler. Requires Racket to be installed and in PATH.
* `make test-unit` to run unit tests defined in [test-unit](./test-unit) of the compiler support libraries
* `make test-compiler` to run tests defined in [test-compiler](./test-compiler) for the full compiler. This requires WABT to be installed and in PATH.
* `make test` to run both unit and compiler tests
* `cat test.scm | make compile` to compile the Scheme file `test.scm` to a WAT module to standard output.

Test runs can be a bit slow, but can be executed faster in parallel using GNU make's concurrent exeuction. For example, `make -j4 -O test` compiles the compiler and runs all tests with 4-way concurrency. Requires recent-enough GNU make. The option `-O` keeps the output ordered despite the parallel execution.

## Implemented features

* Compilation of 32-bit integer values and open-coded application of + - * / = operators
* Scheme if statement to Wasm if statement
* Compilation of lambda expressions to Wasm functions and values that can be applied to arguments
* Port the compiler from Racket `#lang sicp` to standard R6RS Scheme (still using Racket as the development platform)
* A simple compiler "driver" that can be given a Scheme program from standard input and that emits a Wasm module to standard output in WAT format
* Add Makefile for building the compiler and regression test execution
* Add regression tests for the implemented features
  * Tests are specified in WAST and executed with [WABT](https://github.com/WebAssembly/wabt)'s [spectest-interp](https://webassembly.github.io/wabt/doc/spectest-interp.1.html) tool
  * The tests invoke the compiler with a Scheme expression, compile it and check the executed WebAssembly's result with WAST assertions
  * See [test-compiler](./test-compiler) for the tests. They also give an overall idea of what works and has been implemented in the compiler.
* Compilation of Scheme R7RS library to a Wasm module with the top-level code in an exported `func` "main"
* Top-level `define` of values and procedures
* `set!` top-level and in-scope binding values

## Known issues
* Open coding of numerical comparison operators produces incorrect results when the operator is applied to more than two parameters
* Numerical operator special cases `(+)`, `(*)`, `(+ x)`, `(* x)`, `(- x)`, `(/ x)` are not supported
* The Scheme values are not type checked in the compiled programs: a number can be used as a procedure reference and vice-versa. Using of uninitialized values is not detected.
* Compiling `(begin)` results in no value
* The Makefile always runs the tests twice after clean before recognizing that there is nothing more to be done

## Features currently under work

## Backlog

* Come up with a name for this project
* Add support for exported top-level definitions with R7RS libary syntax. The exports can be used for writing more comprehensive tests with multiple calls to the exported procedures and asserting the return values.
* Implement local bindings (`let` forms), with Wasm locals instead of `lambda`, if possible.
* _Scan out_ (see [SICP chapter 4.16](https://mitpress.mit.edu/sites/default/files/sicp/full-text/book/book-Z-H-26.html#%_sec_4.1.6)) internal definitions and implement the bindings with `letrec*`
* Add support for allocating local temporary variables. They will be needed in the implementation of `and` and `or` expressions for retaining the expression's value. See also [#1102 dup instruction](https://github.com/WebAssembly/design/issues/1102).
* Add compilation of `and` and `or` expressions. They can be implemented with Wasm block structure and conditional branch instructions.
* Restrict numerical comparison operators to two parameters (see [Known issues](#known-issues)) and add support for the currently missing operators
* Optional: Implement support for numerical comparison operators with more than two parameters by compiling them as an `and` expression
* Compile `cond` as Wasm block structure and conditional branch instructions instead of the current nested if expressions.
* Add high-level design documentation with guide to the source code of the compiler
* Add bit tagged typing to values and type predicates: `number?`, `procedure?` and uninitialized value and add type checking to generated code. (see [Known issues](#known-issues))
* Add support for read-only symbols and strings
* Add run-time support for rudimentary heap-based values: vectors, pairs
* Implement simple garbage collection using [SICP section 5.3](https://mitpress.mit.edu/sites/default/files/sicp/full-text/book/book-Z-H-33.html#%_sec_5.3) as a guideline in WAT
* Implement lexical [closures](https://en.wikipedia.org/wiki/Closure_(computer_programming)) with function activation records as vector lists on the heap
* More R7RS-small features, prioritisation TBD.

## References

### Essential
* [Structure and Interpretation of Computer Programs (SICP) Web Site](https://mitpress.mit.edu/sites/default/files/sicp/index.html)
* [WebAssembly home page](https://webassembly.org)
* [WebAssembly specification](https://webassembly.github.io/spec/core/)
* [WebAssembly text format (WAT)](https://webassembly.github.io/spec/core/text/index.html)

### Supporting
* [WebAssembly on MDN](https://developer.mozilla.org/en-US/docs/WebAssembly)
* [Bringing the Web up to Speed with WebAssembly (research paper)](https://dl.acm.org/doi/10.1145/3140587.3062363)
* [Bringing the Web Up to Speed with WebAssembly (article in ACM Communications)](https://cacm.acm.org/magazines/2018/12/232881-bringing-the-web-up-to-speed-with-webassembly/fulltext)
* [CHICKEN internals: data representation](https://www.more-magic.net/posts/internals-data-representation.html)

### Scheme classics
* [SCHEME: An Interpreter for Extended Lambda Calculus](https://dspace.mit.edu/handle/1721.1/5794)
* [RABBIT: A Compiler for SCHEME](https://dspace.mit.edu/handle/1721.1/6913)

### Similar projects
* [Schism – an experimental compiler from Scheme to WebAssembly](https://github.com/google/schism)
* [WAForth: Forth Interpreter+Compiler for WebAssembly](https://el-tramo.be/blog/waforth/)
