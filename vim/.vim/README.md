# dotvim
My vim configuration!

## Setup

Clone the entire repo recursively, then set symlink
```bash
$ cd ~
$ git clone --recursive git@github.com:nigeljyng/dotvim.git
$ mv dotvim .vim
$ ln -s ~/.vim/vimrc ~/.vimrc
```

## Adding new plugins
Add new plugins as submodules to easily keep track of updates
```bash
$ cd bundle
$ git submodule add <address of plugin>
```

## Removing plugins cleanly
See http://stackoverflow.com/a/1260982. Instructions replicated below for convenience.

> To remove a submodule you need to:

> 1. Delete the relevant section from the ```.gitmodules``` file.
> 2. Stage the ```.gitmodules``` changes ```git add .gitmodules```
> 3. Delete the relevant section from ```.git/config```.
> 4. Run ```git rm --cached path_to_submodule``` (no trailing slash).
> 5. Run ```rm -rf .git/modules/path_to_submodule```
> 6. Commit ```git commit -m "Removed submodule <name>"```
> 7. Delete the now untracked submodule files
> 8. ```rm -rf path_to_submodule```
