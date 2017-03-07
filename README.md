Vala support for Babel
======================

Vala is a programming language for the GObject system (think Glib and
GTK) that is converted to C source code and then compiled.

Babel is an Emacs package that allows to run code directly from within
a text file (at least in org-mode).

`ob-vala.el` adds Vala support to Babel.

These things work:

- compile and run a simple Vala class (like one that prints `hello world`)
- capture the output of the executed code

These things don't work:

- pass parameters to compiler/linker [planned]
- session support (because Vala is compiled and has no interpreter)
- parameter expansion
