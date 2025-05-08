# Zwiki

A Zettelkasten note taking system that uses markdown. Written in lua for neovim, it depends on fzf-lua, and ripgrep to function.

It only supports markdown syntax and Zettel file names will have a format of
`YYMMDD-HHMMSS.md`. When saving a file, backlinks will be automatically updated to its
linked notes.

## Keymappings

```
<Leader>z    search and open Zettels by title (:Zwiki)
(VISUAL) z   create a new note and copy selection
(INSERT) [[  search and insert a Zettel link
```

## Commands

```
Zwiki         search all notes by title
ZwikiNew      create a new Zettel, commands can be supplied like 'e', i.e.
              Znew +norm\ "+p    -> create a note with current clipboard content
ZwikiTab      create   a         new Zettel  in     a    new     tab
Zwikibacklink generate backlinks for linked  notes. This command is automatically
              triggered when a note is updated.
```
