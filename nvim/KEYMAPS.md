# MY NEOVIM KEYMAPS

This document lists all my keyboard shortcuts available in this Neovim configuration, organized by category.

## Table of Contents

- [General Navigation](#general-navigation)
- [File Management](#file-management)
- [Editing](#editing)
- [Search](#search)
- [Windows and Buffers](#windows-and-buffers)
- [LSP (Language Server Protocol)](#lsp-language-server-protocol)
- [Git](#git)
- [Terminal](#terminal)
- [Interface](#interface)
- [Telescope](#telescope)
- [Neo-tree (File Explorer)](#neo-tree-file-explorer)
- [Others](#others)

## General Navigation

| Shortcut                              | Mode | Description                                     |
| ------------------------------------- | ---- | ----------------------------------------------- |
| `h`, `j`, `k`, `l`                    | n    | Move cursor left, down, up, right               |
| `w`                                   | n    | Go to beginning of next word                    |
| `b`                                   | n    | Go to beginning of previous word                |
| `e`                                   | n    | Go to end of current word                       |
| `0`                                   | n    | Go to beginning of line                         |
| `$`                                   | n    | Go to end of line                               |
| `gg`                                  | n    | Go to beginning of file                         |
| `G`                                   | n    | Go to end of file                               |
| `{`                                   | n    | Go to previous paragraph                        |
| `}`                                   | n    | Go to next paragraph                            |
| `f{char}`                             | n    | Go to next occurrence of {char} on the line     |
| `F{char}`                             | n    | Go to previous occurrence of {char} on the line |
| `t{char}`                             | n    | Go just before next occurrence of {char}        |
| `T{char}`                             | n    | Go just after previous occurrence of {char}     |
| `%`                                   | n    | Go to matching parenthesis/bracket              |
| `<C-d>`                               | n    | Scroll half page down with centering            |
| `<C-u>`                               | n    | Scroll half page up with centering              |
| `n`                                   | n    | Find next occurrence and center                 |
| `N`                                   | n    | Find previous occurrence and center             |
| `]]`                                  | n, x | Go to next reference of word under cursor       |
| `[[`                                  | n, x | Go to previous reference of word under cursor   |
| `<Up>`, `<Down>`, `<Left>`, `<Right>` | n    | Normal movement with arrow keys                 |

## File Management

| Shortcut     | Mode | Description                     |
| ------------ | ---- | ------------------------------- |
| `<C-s>`      | n    | Save file                       |
| `<leader>sn` | n    | Save without auto-formatting    |
| `<C-q>`      | n    | Quit file                       |
| `q`          | c    | Quit all files (:qa)            |
| `<leader>e`  | n    | Open file explorer              |
| `<leader>cR` | n    | Rename file (with LSP support)  |
| `<leader>q`  | n    | Quickly open a file (QuickFile) |
| `<leader>.`  | n    | Toggle temporary buffer         |
| `<leader>S`  | n    | Select temporary buffer         |
| `<leader>fc` | n    | Find config file                |
| `<leader>fp` | n    | Show projects                   |

## Editing

| Shortcut     | Mode | Description                                  |
| ------------ | ---- | -------------------------------------------- |
| `x`          | n    | Delete character without copying             |
| `<`          | v    | Decrease indentation and stay in visual mode |
| `>`          | v    | Increase indentation and stay in visual mode |
| `p`          | v    | Paste without overwriting register           |
| `<leader>lw` | n    | Toggle line wrapping                         |
| `<leader>sc` | n    | Toggle code scope visualization              |

## Search

| Shortcut     | Mode | Description                         |
| ------------ | ---- | ----------------------------------- |
| `<leader>sg` | n    | Search text in files (grep)         |
| `<leader>sw` | n, x | Search word under cursor            |
| `<leader>sb` | n    | Search in current buffer lines      |
| `<leader>sB` | n    | Search text in all open buffers     |
| `<leader>/`  | n    | Fuzzy search in current buffer      |
| `<leader>s/` | n    | Search history                      |
| `<leader>sh` | n    | Search in help pages                |
| `<leader>sk` | n    | Show all keymaps                    |
| `<leader>sH` | n    | Show all syntax highlighting groups |
| `<leader>sa` | n    | Show autocmds                       |
| `<leader>si` | n    | Show icons                          |
| `<leader>sj` | n    | Show jumps                          |
| `<leader>sl` | n    | Show location list                  |
| `<leader>sm` | n    | Show marks                          |
| `<leader>sM` | n    | Show man pages                      |
| `<leader>sp` | n    | Search for plugin spec              |
| `<leader>sq` | n    | Show quickfix list                  |
| `<leader>sR` | n    | Resume last search                  |
| `<leader>s"` | n    | Show registers                      |
| `<leader>su` | n    | Show undo history                   |

## Windows and Buffers

| Shortcut     | Mode | Description                                     |
| ------------ | ---- | ----------------------------------------------- |
| `<Tab>`      | n    | Go to next buffer                               |
| `<S-Tab>`    | n    | Go to previous buffer                           |
| `<leader>x`  | n    | Close buffer                                    |
| `<leader>b`  | n    | Create new buffer                               |
| `<leader>v`  | n    | Split window vertically                         |
| `<leader>h`  | n    | Split window horizontally                       |
| `<leader>se` | n    | Equalize window sizes                           |
| `<leader>xs` | n    | Close split window                              |
| `<C-k>`      | n    | Go to window above                              |
| `<C-j>`      | n    | Go to window below                              |
| `<C-h>`      | n    | Go to window on the left                        |
| `<C-l>`      | n    | Go to window on the right                       |
| `<leader>to` | n    | Open new tab                                    |
| `<leader>tx` | n    | Close current tab                               |
| `<leader>tn` | n    | Go to next tab                                  |
| `<leader>tp` | n    | Go to previous tab                              |
| `<A-Up>`     | n    | Decrease window height                          |
| `<A-Down>`   | n    | Increase window height                          |
| `<A-Left>`   | n    | Decrease window width                           |
| `<A-Right>`  | n    | Increase window width                           |
| `<leader>bd` | n    | Delete current buffer without disrupting layout |
| `<leader>z`  | n    | Toggle Zen mode                                 |
| `<leader>Z`  | n    | Zoom on current window                          |

## LSP (Language Server Protocol)

| Shortcut     | Mode | Description                |
| ------------ | ---- | -------------------------- |
| `[d`         | n    | Go to previous diagnostic  |
| `]d`         | n    | Go to next diagnostic      |
| `<leader>d`  | n    | Open floating diagnostic   |
| `<leader>q`  | n    | Open diagnostics list      |
| `gd`         | n    | Go to definition           |
| `gD`         | n    | Go to declaration          |
| `gr`         | n    | Show references            |
| `gI`         | n    | Go to implementation       |
| `gy`         | n    | Go to type definition      |
| `<leader>D`  | n    | Type definition            |
| `<leader>ds` | n    | Show document symbols      |
| `<leader>ws` | n    | Show workspace symbols     |
| `<leader>rn` | n    | Rename                     |
| `<leader>ca` | n, x | Code action                |
| `<leader>ss` | n    | Show LSP symbols           |
| `<leader>sS` | n    | Show LSP workspace symbols |
| `<leader>sd` | n    | Show diagnostics           |
| `<leader>sD` | n    | Show buffer diagnostics    |
| `<leader>th` | n    | Toggle inline hints        |

## Git

| Shortcut     | Mode | Description                          |
| ------------ | ---- | ------------------------------------ |
| `<leader>gg` | n    | Open LazyGit                         |
| `<leader>gB` | n, v | Open file/commit in browser          |
| `<leader>gb` | n    | Show and switch Git branches         |
| `<leader>gl` | n    | Show commit history                  |
| `<leader>gL` | n    | Show commit history for current line |
| `<leader>gs` | n    | Show modified files                  |
| `<leader>gS` | n    | Show and manage Git stashes          |
| `<leader>gd` | n    | Show Git differences by hunks        |
| `<leader>gf` | n    | Show Git history for current file    |

## Terminal

| Shortcut    | Mode | Description                                |
| ----------- | ---- | ------------------------------------------ |
| `<leader>t` | n    | Open/close floating terminal               |
| `<A-i>`     | n    | Open/close floating terminal (alternative) |

## Interface

| Shortcut     | Mode | Description                    |
| ------------ | ---- | ------------------------------ |
| `<leader>n`  | n    | Show notification history      |
| `<leader>un` | n    | Hide all active notifications  |
| `<leader>d`  | n    | Open dashboard                 |
| `<leader>uC` | n    | Show and change color theme    |
| `<leader>N`  | n    | Show Neovim news               |
| `<leader>bg` | n    | Toggle background transparency |
| `<leader>ub` | n    | Toggle dark/light background   |
| `<leader>uc` | n    | Toggle conceallevel            |
| `<leader>ud` | n    | Toggle diagnostics display     |
| `<leader>ug` | n    | Toggle indent guides           |
| `<leader>uh` | n    | Toggle inlay hints             |
| `<leader>ul` | n    | Toggle line numbers            |
| `<leader>uL` | n    | Toggle relative line numbers   |
| `<leader>us` | n    | Toggle spell checking          |
| `<leader>uT` | n    | Toggle treesitter              |
| `<leader>uD` | n    | Toggle dim out-of-focus code   |
| `<leader>uw` | n    | Toggle line wrapping           |

## Telescope

| Shortcut          | Mode    | Description               |
| ----------------- | ------- | ------------------------- |
| `<leader>ff`      | n       | Find files                |
| `<leader>fg`      | n       | Find Git files            |
| `<leader>fr`      | n       | Recent files              |
| `<leader>fb`      | n       | Find in buffers           |
| `<leader>fp`      | n       | Show projects             |
| `<leader>sf`      | n       | Search files              |
| `<leader>sh`      | n       | Search in help            |
| `<leader>sk`      | n       | Search keymaps            |
| `<leader>ss`      | n       | Select Telescope function |
| `<leader>sw`      | n       | Search current word       |
| `<leader>sg`      | n       | Search by Grep            |
| `<leader>sd`      | n       | Search diagnostics        |
| `<leader>sr`      | n       | Resume last search        |
| `<leader>s.`      | n       | Search in recent files    |
| `<leader>sb`      | n       | Search in buffers         |
| `<leader><space>` | disable | Smart file search         |
| `<leader>:`       | n       | Command history           |

## Neo-tree (File Explorer)

| Shortcut    | Mode | Description                            |
| ----------- | ---- | -------------------------------------- |
| `\`         | n    | Open Neo-tree and reveal current file  |
| `<leader>e` | n    | Toggle focus between Neo-tree and code |
| `<bs>`      | n    | Go up one level in tree                |
| `.`         | n    | Set as root                            |
| `H`         | n    | Show/hide hidden files                 |
| `/`         | n    | Fuzzy search                           |
| `D`         | n    | Fuzzy search in directories            |
| `#`         | n    | Fuzzy sort                             |
| `f`         | n    | Filter                                 |
| `<c-x>`     | n    | Clear filter                           |
| `[g`        | n    | Go to previous Git modification        |
| `]g`        | n    | Go to next Git modification            |
| `m`         | n    | Move                                   |
| `q`         | n    | Close window                           |
| `R`         | n    | Refresh                                |
| `?`         | n    | Show help                              |
| `<`         | n    | Previous source                        |
| `>`         | n    | Next source                            |
| `i`         | n    | Show file details                      |
| `d`         | n    | Delete buffer (buffers mode)           |
| `bd`        | n    | Delete buffer (buffers mode)           |
| `A`         | n    | Add all files (git mode)               |
| `gu`        | n    | Unstage file (git mode)                |
| `ga`        | n    | Add file (git mode)                    |
| `gr`        | n    | Revert file (git mode)                 |
| `gc`        | n    | Commit (git mode)                      |
| `gp`        | n    | Push (git mode)                        |
| `gg`        | n    | Commit and push (git mode)             |

## Others

| Shortcut     | Mode | Description             |
| ------------ | ---- | ----------------------- |
| `<leader>th` | n    | Toggle LSP inline hints |
