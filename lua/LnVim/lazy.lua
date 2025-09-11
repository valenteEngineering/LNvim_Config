-- ~/.config/nvim/lua/LnVim/lazy.lua
-- :w jsut a test:will

-- This is the bootstrap script for lazy.nvim.
-- It will automatically install lazy.nvim if it's not already present.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- Use the stable branch for reliability
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- This is the main setup call for lazy.nvim.
require("lazy").setup({

    -- TELESCOPE, fuzzy finding for files + more 
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-ui-select.nvim",
            "nvim-tree/nvim-tree.lua",
        },
        config = function()
            require("LnVim.plugins.telescope")
        end,
    },

    -- Treesitter for code highlighting + Playground 
    {
        "nvim-treesitter/nvim-treesitter", branch = 'master', lazy = false, build = ":TSUpdate",
        "nvim-treesitter/playground",
    },

    -- Huez Theme Manager - todo!
    {
        "vague2k/huez.nvim",
        -- if you want registry related features, uncomment this
        import = "huez-manager.import",
        branch = "stable",
        lazy = false,
        priority = 1000,
        config = function()
            require("LnVim.plugins.huez")
        end,
    },

    -- Harpoon
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            require("LnVim.plugins.harpoon")
        end,
    },

    -- UndoTree
    {
        'mbbill/undotree',
        event = "VeryLazy",
        config = function()
            require("LnVim.plugins.undotree")
        end,
    },

    --NVimTRee for File Traversal
    {
        "nvim-tree/nvim-tree.lua",
        version = "*",
        lazy = false,
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("LnVim.plugins.nvimtree")
        end,
    },


    -- LSP Support
    -- NOTE: We have broken this into three separate plugin definitions
    -- to ensure they load and configure in the correct order.

    -- 1. MASON: Manages our LSPs, DAP, Linters, etc.
    {
        'williamboman/mason.nvim',
        config = function()
            require("mason").setup()
        end,
    },

    -- 2. MASON-LSPCONFIG: The bridge between Mason and lspconfig.
    {
        'williamboman/mason-lspconfig.nvim',
        event = "VeryLazy",
        dependencies = { 'williamboman/mason.nvim', 'neovim/nvim-lspconfig' },
        config = function()
            require("LnVim.lsp").setup() -- This calls your lsp/init.lua file
        end,
    },

    -- 3. NVIM-LSPCONFIG: The core LSP configuration library.
    {
        'neovim/nvim-lspconfig',
    },

    -- Autocompletion
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            -- Snippet Engine & its source for nvim-cmp
            {
                'L3MON4D3/LuaSnip',
                dependencies = { "rafamadriz/friendly-snippets" } -- <<< ADD THIS LINE
            },
            'saadparwaiz1/cmp_luasnip',

            -- Adds LSP completion capabilities
            'hrsh7th/cmp-nvim-lsp',

            -- Adds other completion sources
            'hrsh7th/cmp-buffer',
            'hrsh7th/cmp-path',
        },
        config = function()
            -- Make sure friendly-snippets are loaded
            require("luasnip.loaders.from_vscode").lazy_load()
            require("luasnip.loaders.from_snipmate").lazy_load()
            require("LnVim.plugins.cmp")
        end
    },

    -- Which key to view option after hitting leader key
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        config = function()
            require("LnVim.plugins.whichkey")
        end,

    },

    -- Window Split Manager, auto resize
    {
        "anuvyklack/windows.nvim",
        dependencies = {
            "anuvyklack/middleclass",
            "anuvyklack/animation.nvim",
        },
        keys = {
            {
                "<C-w>v",
                function()
                    -- Load windows.nvim if not already loaded
                    require("lazy").load({ plugins = { "windows.nvim" } })
                    -- Perform the original split
                    vim.cmd("wincmd v")
                end,
                desc = "Vertical Split (with windows.nvim)",
            },
            {
                "<C-w>s",
                function()
                    require("lazy").load({ plugins = { "windows.nvim" } })
                    vim.cmd("wincmd s")
                end,
                desc = "Horizontal Split (with windows.nvim)",
            },
        },
        config = function()
            require("LnVim.plugins.windows")
        end,
    },

    -- Window picker for fast changing
    {
        "s1n7ax/nvim-window-picker",
        name = "window-picker",
        version = "2.*",
        -- Use 'keys' to lazy-load the plugin on the first keypress.
        keys = {
            {
                "<leader>p",
                function()
                    -- This function calls the specific picker from our config file.
                    require("LnVim.plugins.windowpicker").pick_window_with_big_letter()
                end,
                desc = "Window Picker: Pick window",
            },
        },
        -- The config function runs after the plugin is loaded (triggered by the keypress).
        config = function()
            require("LnVim.plugins.windowpicker")
        end,
    },

    -- LazyGit Intigration
    {
        "kdheepak/lazygit.nvim",
        lazy = true,
        cmd = {
            "LazyGit",
            "LazyGitConfig",
            "LazyGitCurrentFile",
            "LazyGitFilter",
            "LazyGitFilterCurrentFile",
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        -- Need to move keymap here as this will lazyload the plugin when called
        keys = {
            {"<leader>gg", "<cmd>LazyGit<CR>", desc = "LazyGit: Open" }

        },
    },

    -- Status line plugin to make it look better
    {
        'nvim-lualine/lualine.nvim',
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            require("LnVim.plugins.lualine")
        end,
    },

    -- Terminal Layout Tool toggleterm
    {
        'akinsho/toggleterm.nvim',
        version = "*",
        config = function ()
            require("LnVim.plugins.toggleterm")
        end
    },

    -- Terminal manager
    {
        "ryanmsnyder/toggleterm-manager.nvim",
        dependencies = {
            "akinsho/nvim-toggleterm.lua",
            "nvim-telescope/telescope.nvim",
            "nvim-lua/plenary.nvim", -- only needed because it's a dependency of telescope
        },
        config = true,
    },

    -- SSHFS Manager 
    {
        "nosduco/remote-sshfs.nvim",
        dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
        config = function()
            require("LnVim.plugins.sshfs")
        end,
    },

    -- Session manager
    {
        "Shatur/neovim-session-manager",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("LnVim.plugins.sessionmanager")
        end,
    },

    -- Projcet manager

})

