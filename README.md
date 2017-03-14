Vala support for Babel
======================

[Vala] is a programming language for the GObject system (think Glib
and GTK) that is converted to C source code and then compiled.

[Babel] is an [Emacs] package that allows to run code directly from
within an [Org-mode] text file.

`ob-vala.el` adds Vala support to Babel.


status
------

These things work:

- compile and run a simple Vala class (like one that prints `hello world`)
- capture the output of the executed code as a `#+RESULTS:`

These things don't work:

- pass parameters to compiler/linker [planned]
- automatically wrap naked code lines with a class and main method
- parameter expansion
- session support (because Vala is compiled and has no interpreter)
- no support of .vapi files (would that even make sense?)


installation
------------

Move or symlink `ob-vala.el` to a directory that is read by your
Emacs.  To use the directory `~/.emacs.d/lisp/`, you probably have to add
it to your [load-path] by adding this line to your `~/.emacs` file:

```elisp
(add-to-list 'load-path "~/.emacs.d/lisp/")
```

If you need Vala support all the time, you can automatically load
`ob-vala.el` on every Emacs startup by also adding

```elisp
(require 'op-vala)
```

to your `~/.emacs`.

If you need Vala support only occasionally, you can instead add this
footer to your `.org` files that contain Vala code:

```elisp
# Local Variables:
# eval: (require 'ob-vala)
# End:
```


usage
-----

Within an Org-mode file, you can now add a code block like this (note
the `vala` keyword on the first line):

```
#+BEGIN_SRC vala
  class Demo.HelloWorld : GLib.Object {
      public static int main(string[] args) {
          stdout.printf("Hello, World\n");
          return 0;
      }
  }
#+END_SRC
```

Place your cursor in there, hit `C-c C-c` and the code will be
executed and the result added to your file:

```
#+RESULTS:
| Hello | World |
```

(The result is in tabular format by default because `,` is a
delimiter.)

See `examples.org` for further examples.


[Vala]: https://wiki.gnome.org/Projects/Vala
[Babel]: http://orgmode.org/worg/org-contrib/babel/
[Emacs]: https://www.gnu.org/software/emacs/
[Org-mode]: http://orgmode.org
[load-path]: https://www.emacswiki.org/emacs/LoadPath
