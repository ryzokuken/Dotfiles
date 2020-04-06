# My Dotfiles

## Introduction

These are my dotfiles for the various services I use on my computer. If you
feel like I might be missing something, or that smething is amiss, feel free to
[ file an issue ]( https://github.com/ryzokuken/Dotfiles/issues/new ).

## Get my dotfiles

These dotfiles have been managed by the dotfile management tool,
[ chezmoi ]( https://github.com/twpayne/chezmoi ). You can get them immediately
through the following sequence of commands.

```shell
$ chezmoi init https://github.com/ryzokuken/dotfiles.git
$ chezmoi apply
```

## Update my dotfiles

If in some case you're using these exact dotfiles (which makes no sense, unless
you're me, in which case it makes a whole lot of sense), you can fetch changes
and update to the latest dotfiles through the following sequence of commands.

```shell
$ chezmoi update
```
