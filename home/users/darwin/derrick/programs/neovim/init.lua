-- 基本設定
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smartindent = true
vim.opt.termguicolors = true

-- Leader key
vim.g.mapleader = " "

--------------------------------------------------
-- Plugin manager: lazy.nvim
--------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath
  })
end
vim.opt.rtp:prepend(lazypath)

--------------------------------------------------
-- Plugins
--------------------------------------------------
require("lazy").setup({
  -- LSP
  { "neovim/nvim-lspconfig" },

  -- 補全
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },

  -- Tree-sitter
  { "nvim-treesitter/nvim-treesitter", 
    build = ":TSUpdate" ,
    config = function()
        require("nvim-treesitter.config").setup({
            ensure_installed = { "rust", "nix", "lua", "toml", "json", "yaml" },
            highlight = { enable = true },
        })
    end,
  },

  -- Rust 工具
  { "simrat39/rust-tools.nvim" },

  -- 狀態列
  { "nvim-lualine/lualine.nvim" },

  -- 檔案樹
  {
    "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        config = function()
            require("neo-tree").setup({
                filesystem = {
                    follow_current_file = {
                        enable = true,
                    },
                    hijack_netrw_behavior = "open_default",
                    filtered_items = {
                        visible = true,      -- 顯示被隱藏的檔案
                        hide_dotfiles = false,
                        hide_gitignored = false,
                    },
                },
            })
        end,
  },
  {
    "kdheepak/lazygit.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
    },
    config = function()
        vim.g.lazygit_floating_window_winblend = 0 -- 透明度
        vim.g.lazygit_floating_window_scaling_factor = 0.9
        vim.g.lazygit_use_neovim_remote = true
    end,
  },

  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },

  -- 主題
  { "catppuccin/nvim", name = "catppuccin" },

  { "nvim-lua/plenary.nvim" },
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },
})

--------------------------------------------------
-- Theme
--------------------------------------------------
vim.cmd.colorscheme("catppuccin")

--------------------------------------------------
-- Tree-sitter
--------------------------------------------------
-- require("nvim-treesitter.configs").setup({
--   ensure_installed = { "rust", "nix", "lua", "toml", "json", "yaml" },
--   highlight = { enable = true },
-- })

--------------------------------------------------
-- LSP 設定
--------------------------------------------------
local cmp = require("cmp")

cmp.setup({
  mapping = {
    ["<Tab>"] = cmp.mapping.confirm({ select = true }),
  },
  sources = {
    { name = "nvim_lsp" },
  },
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- 設定 rust-analyzer
vim.lsp.config("rust_analyzer", {
  capabilities = capabilities,
  settings = {
    ["rust-analyzer"] = {
      cargo = { allFeatures = true },
      checkOnSave = { command = "clippy" },
    },
  },
})

-- 設定 nixd（指定 formatter 為 alejandra）
vim.lsp.config("nixd", {
  capabilities = capabilities,
  settings = {
    nixd = {
      formatting = { command = { "alejandra" } },
    },
  },
})

vim.lsp.enable({ "rust_analyzer", "nixd" })

--------------------------------------------------
-- Format on save
--------------------------------------------------
-- vim.api.nvim_create_autocmd("BufWritePre", {
--   pattern = { "*.rs" },
--   callback = function() vim.lsp.buf.format() end,
-- })

-- vim.api.nvim_create_autocmd("BufWritePre", {
--   pattern = { "*.nix" },
--   callback = function()
--     vim.lsp.buf.format({ async = false })
--   end,
-- })

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.rs", "*.nix" },
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

--------------------------------------------------
-- 快捷鍵
--------------------------------------------------
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>")
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>")
vim.keymap.set("n", "<leader>e", ":Neotree toggle<CR>")
vim.keymap.set("n", "<leader>gg", ":LazyGit<CR>", { silent = true, desc = "Open LazyGit" })
