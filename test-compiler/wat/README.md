# Contents of this directory

This directory contains WAT (WebAssembly text format) code generated from
integration test files [test-compiler/*.scm](..) by the compiler that is been
developed in this repository. The files are formatted with
[WABT](https://github.com/WebAssembly/wabt)'s `wat-desugar`
command. The .wat files are updated automatically by this project's build
script when the integration test files or the compiler's code generated for them
changes.

The purpose of storing these files into the repository is to expose changes
in the compiler's code generation as a difference to the files produced by
previous versions of the compiler. Changes into these files should be
reviewed and committed to this repository along with the update compiler source
files.