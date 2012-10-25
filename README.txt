-*- mode:org; -*-

* Python-Emacs

This repository contains all the third party code required to make
Emacs an awesome python IDE. Namely, it contains the latest versions
of Pymacs and Rope and instructions on how to install them. I use this
repository as a sub-module in my emacs configuration.

* INSTALL
** Clone this repository:
   - git clone --recursive https://github.com/vedang/python-emacs
     ~/.emacs.d/any/where/you/want/

** Compile the code that's been downloaded:
   - config/python-mode-config.el: this file contains extra sugar for
     an awesome experience. No compilation needed
   - lib/pymacs: run the make command, the compiled python code should
     be in the build folder and the pymacs.el file should be in the
     top-most folder
   - lib/rope: run `python setup.py build`, the compiled code should
     be in the build folder
   - lib/ropemode: run `python setup.py build`, the compiled code should
     be in the build folder
   - lib/ropemacs: run `python setup.py build`, the compiled code should
     be in the build folder
   - lib/pycheckers: get the pre-requisites (pyflakes and
     pycheckers). `sudo pip install pyflakes pep8`. make the
     pycheckers file executable.

** Copy the compiled code:
   - Python code to /usr/local/lib/python2.7/dist-packages/ (basically
     anywhere on PYTHONPATH)
   - pycheckers to /usr/bin (basically anywhere on the system path)

** Add the following lines to your .emacs

   (add-to-list 'load-path "/path/to/python-emacs")
   (require 'python-emacs-init)

** Restart Emacs. Profit!

* Caveats

 - This configuration is ONLY known to work with Emacs 24. You are on
   your own with older versions of Emacs.
 - For unleashing the full power of this configuration, you should
   install and use autocomplete to provide python completion
 - You should read-up on Rope in lib/rope/docs/ to understand how to use it
