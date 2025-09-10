-- ./LnVim/plugins/conduct.lua test

local ok, conduct = pcall(require, "conduct")
if not ok then
    vim.notify("conduct.nvim not found!", vim.log.levels.ERROR)
    return
end

-- Core setup
conduct.setup({
    functions = {},
    presets = {},
    hooks = {},
})

-- Telescope integration
local has_telescope, telescope = pcall(require, "telescope")
if has_telescope then
    telescope.load_extension("conduct")
end

-- Helper function to create a project with prompt
function create_project_prompt()
    vim.ui.input({ prompt = "Enter project name: " }, function(input)
        if input and input ~= "" then
            -- Create the project in current directory
            vim.cmd("ConductNewProject " .. input)
            vim.cmd("ConductLoadProject " .. input)
            vim.cmd("ConductProjectNewSession default") -- optional: initial session
            vim.notify("Project '" .. input .. "' created and loaded!", vim.log.levels.INFO)
        else
            vim.notify("Project creation cancelled.", vim.log.levels.WARN)
        end
    end)
end

-- Helper function to create a project with prompt
function create_session_prompt()
    vim.ui.input({ prompt = "Enter session name: " }, function(input)
        if input and input ~= "" then
            -- Create the project in current directory
            vim.cmd("ConductProjectNewSession " .. input)
            vim.cmd("ConductProjectLoadSession " .. input)
            vim.notify("Session '" .. input .. "' created and loaded!", vim.log.levels.INFO)
        else
            vim.notify("Session creation cancelled.", vim.log.levels.WARN)
        end
    end)
end



-- Keymaps
local opts = { noremap = true, silent = true }

-- Prompt for a new project
vim.api.nvim_set_keymap("n", "<leader>Pn", "<cmd>lua create_project_prompt()<CR>", opts)
vim.api.nvim_set_keymap("n", "<leader>Sn", "<cmd>lua create_session_prompt()<CR>", opts)    -- Save/create new session

-- Telescope commands
vim.api.nvim_set_keymap("n", "<leader>P", "<cmd>Telescope conduct projects<CR>", opts)   -- Telescope project picker
vim.api.nvim_set_keymap("n", "<leader>S", "<cmd>Telescope conduct sessions<CR>", opts)   -- Telescope session picker

-- Manual session commands
--vim.api.nvim_set_keymap("n", "<leader>Sl", "<cmd>ConductProjectLoadSession<CR>", opts)   -- Load a session
--vim.api.nvim_set_keymap("n", "<leader>Sd", "<cmd>ConductProjectDeleteSession<CR>", opts) -- Delete a session
--vim.api.nvim_set_keymap("n", "<leader>Sr", "<cmd>ConductProjectRenameSession<CR>", opts) -- Rename a session
--
---- Manual project commands
--vim.api.nvim_set_keymap("n", "<leader>pp", "<cmd>ConductLoadProject<CR>", opts)          -- Load a project
--vim.api.nvim_set_keymap("n", "<leader>pl", "<cmd>ConductLoadLastProject<CR>", opts)      -- Load last project
--vim.api.nvim_set_keymap("n", "<leader>pc", "<cmd>ConductLoadCwdProject<CR>", opts)       -- Load project in cwd
--vim.api.nvim_set_keymap("n", "<leader>pd", "<cmd>ConductDeleteProject<CR>", opts)        -- Delete project
--vim.api.nvim_set_keymap("n", "<leader>pr", "<cmd>ConductRenameProject<CR>", opts)        -- Rename project
