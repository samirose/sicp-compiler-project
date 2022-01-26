# Development notes
## lexical-env
- Variables can be overridden in lexical-env, but additional-info is the same
for all variables with the same name. Maybe change the lexical-frame to an
association list with (var-name additional-info) pairs?
