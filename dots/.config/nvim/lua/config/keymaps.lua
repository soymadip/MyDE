-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local keymap = vim.keymap

-- Use 'jj' to exit insert mode (like Escape)
keymap.set('i', 'jk', '<Esc>', { noremap = true, silent = true })
