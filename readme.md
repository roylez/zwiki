# Zwiki

A Zettelkasten note taking system based on VimWiki. It depends on vimwiki, FZF.vim,
and ripgrep to function.

It only supports markdown syntax and Zettel file names will have a format of
`YYMMDD-HHMMSS.md`. When saving a file, backlinks will be automatically updated to its
linked notes.

## Keymappings

```
<Leader>z    search and open Zettels by title (:Z)
<Leader>l    search and open links included in current note (:Zlinks)
(VISUAL) z   create a new note and copy selection
(INSERT) [[  search and insert a Zettel link
```

## Commands

```
Znew/Ztab   create a new Zettel, commands can be supplied like 'e', i.e.
            Znew +norm\ "+p    -> create a note with current clipboard content
Zlinks      list links in current note
Z           search all notes by title
Zbacklink   generate backlinks for linked notes. This command is automatically
            triggered when a note is updated.
```
