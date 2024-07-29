# Development notes

## Compiler output
### Current solution – runtime module
Currently the compiler is producing Wasm modules that import memory, globals and functions from a runtime support module, see [runtime](runtime/). This has worked OK with the current compiler that can only produce library-like modules from Scheme libraries. The compiler tests have used [WAST][wast] with its rudimentary multi-module support in the compiler tests to link the runtime support and the compiler-produced modules together.

### Why this is a problem now?
I am planning to extend the compiler to produce executable Scheme programs that could be run with a standard command-line WebAssembly runtime. To have the programs do something useful, I also plan to add a rudimentary output facility as some basic version of the `(scheme write)` standard libary. I could then rethink the compiler testing by adding a simple testing library and have compiled test programs that could be executed, instead of the current approach that compiles Wasm modules and tests them with WAST scripts that are generated from simple Scheme-like test scripts (see [test-compiler/test/](test-compiler/test/) and -[/lib/](test-compiler/lib/)).

Testing with WAST is very limited and test errors are hard to debug. The next big thing that I want to add to the compiler is support for lists, vectors and garbage collection. I feel that I need stronger testing tools to help with developing those. Now that support for output and executable Scheme programs is planned to be added, the separate runtime and executable modules would require some kind of module linking support from the Wasm runtime that I will to use to execute the compiled programs.

### Issues with module linking
There is no straightforward module linking support in the current, popular Wasm command-line runtimes, which I would like to use in the project for simplicity and minimal dependencies. Modules could be linked with a programming language integrated Wasm runtime, such as Node.js, or with a Wasm runtime that provides a library and an API, by writing explict code to link the runtime module exports with the compiled module imports, but that would require the compiler to preferably generate the linking code too and would add a huge dependency to the project. Also the compiler-generated Wasm modules would not be self-sufficient anymore, but would require the linking code and its runtime to execute.

### Use WebAssembly Component Model?
The nascent [WebAssembly component model][component-model] promises to provide module linking support and its [use cases documentation][component-model-use-cases-performance] has a case that sounds like a good fit for this project. The [Wasmtime runtime][wasmtime] has early support for executing components with support for I/O. I took a long look at the component model documentation, installed the [wasm-tools][wasm-tools] package, read its documentation, tried to build some simple test components that mimicked my problem of linking runtime library with compiled code, but got nowhere. The documentation on the Wasm component model is still very rudimentary and I found the tools hard to use and some of the concepts hard to understand. Also, I don't currently have use case for the number 1 feature of component model, which is language-agnostic component interfaces.

### The solution – for now
After banging my head against the component model documentation and tooling I gave up on it for now and decided to let it mature a bit. I decided to just emit the runtime code into the same module with compiled code to avoid the module linking issues altogether. Generating self-sufficient programs with I/O support with this approach is still possible using the Wasmtime runtime and the [WASI][wasi] preview 1 system interface it provides. See [wasi-echo.wat](wasm-test-snippets/wasi-echo.wat) in this repository for an example.

Changing the compiler to emit the runtime code into the compiled module is not a small change, but it should not be overwhelming either.

## lexical-env
- Variables can be overridden in lexical-env, but additional-info is the same
for all variables with the same name. Maybe change the lexical-frame to an
association list with (var-name additional-info) pairs?

[wast]: https://github.com/WebAssembly/spec/blob/main/interpreter/README.md#scripts
[component-model]: https://component-model.bytecodealliance.org
[component-model-use-cases-performance]: https://github.com/WebAssembly/component-model/blob/main/design/high-level/UseCases.md#performance
[wasmtime]: https://wasmtime.dev/
[wasm-tools]: https://github.com/bytecodealliance/wasm-tools
[wasi]: https://github.com/WebAssembly/WASI