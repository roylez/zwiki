# Zwiki

A Zettelkasten note taking system based on VimWiki. It depends on vimwiki, FZF.vim, and ripgrep to function.

It only supports markdown syntax and Zettel file names will have a format of
`YYMMDD-HHMMSS.md`. When saving a file, backlinks will be automatically updated to its
linked notes.

## Keymappings

```
<Leader>z    search and open Zettels by title (:Zwiki)
<Leader>Z    search and read the content of selected wiki item (:ZwikiRead)
<Leader>l    search and open links included in current note (:Zwikilinks)
(VISUAL) z   create a new note and copy selection
(INSERT) [[  search and insert a Zettel link
```

## Commands

```
Zwiki         search all notes by title
ZwikiRead     search and insert wiki item content
ZwikiNew      create a new Zettel, commands can be supplied like 'e', i.e.
              Znew +norm\ "+p    -> create a note with current clipboard content
ZwikiTab      create   a         new Zettel  in     a    new     tab
ZwikiLinks    list     links     in  current note
Zwikibacklink generate backlinks for linked  notes. This command is automatically
              triggered when a note is updated.
```
