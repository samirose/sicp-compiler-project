# Scheme to WAT/Wasm compiler

In spirit of [SICP](https://mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/6515/sicp.zip/index.html) exercises [5.49](https://mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/6515/sicp.zip/full-text/book/book-Z-H-35.html#%_thm_5.49)-52.

* The compiler is based on the Scheme to register machine compiler from [SICP section 5.5](https://mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/6515/sicp.zip/full-text/book/book-Z-H-35.html#%_sec_5.5)
* Wasm stands for [WebAssembly](https://webassembly.org)
* WAT is the [WebAssembly Text Format](https://webassembly.github.io/spec/core/text/index.html#)

## Goals

* Implement the compiler in [R7RS-small Scheme](https://small.r7rs.org/), using [GNU Guile](https://www.gnu.org/software/guile/) and [GNU Emacs](https://www.gnu.org/software/emacs/) as the development platform. (N.B.
this project originally used R6RS Scheme and [Racket](https://racket-lang.org/)
for development)
* Learn about Scheme and compilation of functional languages in general
* Get familiar with WebAssembly as an execution environment and compiler target
* Stay in the spirit of simple Scheme and target initially to support a subset of [R7RS-small Scheme](https://small.r7rs.org)
* Compile Scheme forms directly to as idiomatic Wasm as feasible
* Use only basic, standardised [Wasm core](https://www.w3.org/TR/wasm-core-1/) features initially
* Implement as much of the required run-time support in Scheme as possible
* Write the required native run-time support in WAT
* Compile a Scheme interpreter to Wasm using the compiler (see also [SICP exercise 5.52](https://mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/6515/sicp.zip/full-text/book/book-Z-H-35.html#%_thm_5.52))
* If the interpreter works, host it on a web page with minimal JavaScript-driven [REPL](https://en.wikipedia.org/wiki/Read–eval–print_loop)
* _Maybe_ try to [bootstrap](https://en.wikipedia.org/wiki/Bootstrapping_(compilers)) the compiler at some point as an interesting exercise

## Non-goals

* Build a full-blown implementation with robust error reporting, tooling, full Scheme libarary support etc.
* Good interoperability with JavaScript is not critical, except where it helps in testing the compiler or hosting an interpreter or the compiler on the Web
* Do not aim to replace JavaScript on the Web

## Running

Required tools:
* [GNU Make](https://www.gnu.org/software/make/) for build and test orchestration
* [GNU Guile](https://www.gnu.org/software/guile/) for running the compiler on the host
* [WABT](https://github.com/WebAssembly/wabt) for assembling the WAT files produced by the compiler
to Wasm binaries and for running the compiler tests as defined in the Makefile. Compiler's output
can be tested with any Wasm tooling that provides a WAT to Wasm assembler and a Wasm runtime.

Run GNU `make` or `make help` to list the build targets with short explanations.

[GNU Emacs](https://www.gnu.org/software/emacs/)  with [Geiser](https://www.nongnu.org/geiser/)
forms a good development platform for working with the code.

## Implemented features

* Compilation of 32-bit integer values and open-coded application of + - * / = operators
* comparison operators = < > <= >= for 32-bit integers
* Scheme if statement to Wasm if statement
* Scheme lambda expressions to Wasm functions and values that can be applied to arguments
* Port the compiler from Racket `#lang sicp` to standard R6RS Scheme (still using Racket as the development platform)
* A simple compiler "driver" that can be given a Scheme program from standard input and that emits a Wasm module to standard output in WAT format
* Makefile for building the compiler and regression test execution
* Regression tests for the implemented features
  * Tests are specified in [WAST](https://github.com/WebAssembly/spec/tree/master/interpreter#scripts)
  and executed with [WABT](https://github.com/WebAssembly/wabt)'s [spectest-interp](https://webassembly.github.io/wabt/doc/spectest-interp.1.html) tool
  * The tests invoke the compiler with a Scheme library, compile it and check the executed WebAssembly's result with WAST assertions
  * See [test-compiler](./test-compiler) for the tests. They also give an overall idea of what works and has been implemented in the compiler.
* Compilation of Scheme R7RS library to a Wasm module with the top-level code in an exported `func` "main"
* Top-level `define` of values and procedures
* `set!` top-level and in-scope binding values
* Support for exported top-level procedure definitions with R7RS libary syntax
* Basic syntax and semantic error detection and tests for error handling
* Implement `let` and `let*` with Wasm locals instead of `lambda`, if possible. (Using the bindings in closures will need further work)
* `and` and `or` expressions with short circuit using Wasm block structure and conditional branch instructions
* `not` expression
* Compile `cond` to Wasm block structure and conditional branch instructions
* Special form symbols and inlined procedures can be overridden with local bindings
* Add a way to raise errors from compiled code. Needed for halting the program when a type error is detected.
* Convert the source code R7RS-small Scheme and switch to Guile as the host Scheme implementation.
(It would have been natural to use [MIT Scheme](https://www.gnu.org/software/mit-scheme/) for this
project because of its SICP origins, but it does not support the M1 Apple Silicon Mac I am using
as my main machine.)

## Features currently under work
* Add bit tagged typing to values and type predicates: `number?`, `procedure?` and uninitialized value and add type checking to generated code. (see [Known issues](#known-issues))
  * ~~detect duplicate imported identfiers~~
  * ~~check that imports are not mutated~~
  * ~~allow overriding of imported identifiers~~
  * ~~implement re-exporting of imported identifiers~~
  * ~~add name to define-library. It is required r7rs syntax.~~
  * ~~add eq? to the runtime library and make it visible to scheme programs~~
  * ~~Create a simple test compiler that compiles assertions written in limited Scheme to WAST assertions. Try to write the test programs in valid Scheme to facilitate using an existing Scheme implementation as a test verifier.~~
  * ~~Rewrite the compiler tests in Scheme using the test compiler. This will make the tests more readable and maintainable as the expected values for the tests can be generated by the compiler with type tagging.~~
  * ~~add type tagging to all values with the runtime library tagging functions~~
  * ~~normalise compiler test modules compiled WAT code with wat-desugar and store the code into version control. The motivation is to make changes in code generation visible and checking the changes part of committing changes to version control.~~
  * optimise out unnecessary type coercion and checking instructions from generated Wasm code to keep the generated code minimal and more readable.
  * ~~Use immutable globals for imported function values~~
  * ~~Generate runtime library WAT with a Scheme program to enable sharing of values between the runtime library and the compiler.~~

## Known issues
* The Scheme values are not type checked in the compiled programs: a number can be used as a procedure reference and vice-versa. Using of uninitialized values is not detected.
* Numeric computations are not checked for over- or underflow. WebAssembly semantics apply in case
of over- or underflow

## Backlog
* Add support for read-only symbols and strings
* Add run-time support for rudimentary heap-based values: vectors, pairs
* Implement simple garbage collection using [SICP section 5.3](https://mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/6515/sicp.zip/full-text/book/book-Z-H-33.html#%_sec_5.3) as a guideline in WAT
* Implement lexical [closures](https://en.wikipedia.org/wiki/Closure_(computer_programming)) with function activation records as vector lists on the heap
* Implement `letrec` form. It does not make sense to implement it before closure support to enable common use case of recursion and procedures calling each other.
* _Scan out_ (see [SICP chapter 4.16](https://mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/6515/sicp.zip/full-text/book/book-Z-H-26.html#%_sec_4.1.6)) internal definitions and implement the bindings with `letrec*`
* Come up with a name for this project
* Add high-level design documentation with guide to the source code of the compiler
* More R7RS-small features, prioritisation TBD.

## References

### Essential
* [Structure and Interpretation of Computer Programs (SICP) Web Site](https://mitp-content-server.mit.edu/books/content/sectbyfn/books_pres_0/6515/sicp.zip/index.html)
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
