-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Telescope for fuzzy finding files
    use {
        'nvim-telescope/telescope.nvim',
        requires = { {'nvim-lua/plenary.nvim'} }
    }

    -- Treesitter for code highlighting
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }
    use 'nvim-treesitter/playground'

    -- Harpoon for saving file locations for fast recal
    use "nvim-lua/plenary.nvim" -- don't forget to add this one if you don't have it yet!
    use {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        requires = { {"nvim-lua/plenary.nvim"} }
    }

    -- UndoTree for local version control change management
    use('mbbill/undotree')

    -- NVimTree for better file traversal
    use {
        'nvim-tree/nvim-tree.lua',
        requires = {
            'nvim-tree/nvim-web-devicons',
        },
    }

    -- Mason manages LSP binaries
    use {
        'williamboman/mason.nvim',
        config = function()
            require('mason').setup()
        end
    }

    -- Core LSP
    use 'neovim/nvim-lspconfig'

    -- Default Config Files
    use 'neovim/nvim-lspconfig'

    -- NVIM Auto Complete
    use {
        "hrsh7th/nvim-cmp",
        requires = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip"
        }
    }

    -- Which key to view options after hitting leader key
    use 'folke/which-key.nvim'
    -- mini icons for which-key
    use {
        "echasnovski/mini.icons",
        config = function()
            require("mini.icons").setup()
        end,
    }


    -- Window split resize manager
    use {
        "anuvyklack/windows.nvim",
        requires = "anuvyklack/middleclass",
        config = function()
            require('windows').setup()
        end,
    }

    -- Window picker for fast changing
    use {
        's1n7ax/nvim-window-picker',
        tag = 'v2.*',
    }

-- FOR ANOTHER DAY
--    -- Lentils Generated HipFire for multi directory fuzzyfind hot list
--    use {
--        -- Tell Packer to load the plugin directly from this path.
--        '~/.config/nvim/lua/HipFire',
--
--        -- The config block runs after the plugin is loaded.
--        -- The content here is identical to the lazy.nvim version.
--        config = function()
--            -- 1. Setup SideScope (this loads your saved hotlist)
--            require("HipFire").setup()
--
--            -- 2. Map your key to the SideScope find_files action
--            vim.keymap.set('n', '<leader>FF', function() require("HipFire").find_files() end, { desc = "SideScope: Find Files" })
--
--            -- (Optional) You can create a live_grep version here in the future
--            -- vim.keymap.set('n', '<leader>FG', function() require("HipFire").live_grep() end, { desc = "SideScope: Live Grep" })
--        end
--    }

end)

