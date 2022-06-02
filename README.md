# Welcome
This is the welcome screen for macOS (in progress) that displays every time I open a terminal shell (I use `zsh` with `p10k`, but this works with `bash` as well -- the executable is actually written in `bash`). This is really just a personal repo, but if you stumble upon this and like it, just clone the repo and run the Makefile.

The executable shell script [welcome](./build/welcome "welcome"), in the [bin](./bin) folder, is the final product. You would execute this somewhere in your shell configuration file, ideally near the beginning. I execute it in `~/.zprofile`, which is run before `~/.zshrc`.

This was originally just a shell script, but I sped things up a bit by formatting in C++, hence the source code and Makefile. You can see my original script in the [archive folder](./archive).


## Requirements
* `bash` or `zsh` or whatever.
  * I use `bash` v5.1.16 and `zsh` v5.9; can't guarantee this will work on the ancient version of `bash` that comes stock with macOS.
* `figlet`
* `g++` or another C compiler, just modify the Makefile as necessary.
