-- ~/.config/nvim/lua/LnVim/lsp/init.lua

local M = {}

-- This function is called from your lazy.lua to set up everything.
function M.setup()
    -- Step 1: Get our shared settings for on_attach and capabilities.
    -- This makes it easy to apply the same keymaps and completion settings to all LSPs.
    local capabilities = require("LnVim.lsp.capabilities")
    local on_attach = require("LnVim.lsp.attach")

    -- Step 2: Set the global default configuration for all LSP servers.
    -- Neovim's LSP client will automatically use these settings for every server
    -- unless a server-specific config overrides them.
    vim.lsp.config('*', {
        capabilities = capabilities,
        on_attach = on_attach,
    })

    -- Step 3: Define the list of LSP servers you want to use.
    -- This list is used by mason-lspconfig to ensure they are installed.
    local servers = {
        "lua_ls",
        "clangd",
        "pyright",
        -- Add other servers here, for example: "pyright", "rust_analyzer"
    }

    -- Step 4: Load any custom server configurations from the `lsp/servers` directory.
    -- This loop tries to load a config file for each server in the list.
    -- Using `pcall` (protected call) prevents errors if a config file doesn't exist.
    for _, server_name in ipairs(servers) do
        pcall(require, "LnVim.lsp.config." .. server_name)
    end

    -- Step 5: Configure mason and mason-lspconfig.
    -- 2. CONFIGURE MASON TO INSTALL YOUR TOOLS
    require("mason").setup({
        -- This is where you tell Mason what tools to install.
        -- We add ruff here. Pyright will be handled by mason-lspconfig.
        ensure_installed = {
            "ruff",   -- For Python linting and formatting
            "stylua", -- Optional: for formatting Lua code
        }
    })

    -- 3. CONFIGURE MASON-LSPCONFIG
    -- This ensures the servers in your `servers` list are installed
    -- and automatically configured for nvim-lspconfig.
    require("mason-lspconfig").setup({
        ensure_installed = servers,
    })

    --- A custom function to show LSP references and apply our interactive behaviors.
    function GoToReferencesWithPreview()
        local currentWindow = vim.api.nvim_get_current_win()
        local i = 0

        vim.lsp.buf.references()

        vim.schedule(function()
            -- 4. Create the autocommand that triggers the preview.
            vim.api.nvim_create_autocmd('CursorMoved', {
                group = augroup,
                buffer = qf_buffer_id, -- Attach ONLY to the quickfix buffer.
                callback = function()
                    -- Use a protected call to prevent errors on non-file lines (like headers).
                    pcall(function()
                        -- 5. Get structured data for the current line in the quickfix list.
                        --    This is much better than splitting the string manually.
                        local item = vim.fn.getqflist({ idx = vim.fn.line('.'), items = 0 }).items[1]

                        -- Ensure the item is a valid file location.
                        if not item or item.valid ~= 1 then
                            return
                        end

                        -- 6. Find or load the buffer for the target file.
                        --    'bufadd' adds it to the list, 'bufload' reads the content.
                        local file_path = vim.fn.expand(item.filename) -- expand() handles paths like '~/'
                        local bufnr = vim.fn.bufadd(file_path)
                        vim.fn.bufload(bufnr)

                        -- 7. THE CORE LOGIC: Command the *original* window to change.
                        --    This does NOT change your focus. Your cursor stays in the list.
                        vim.api.nvim_win_set_buf(original_window_id, bufnr)

                        -- Move the cursor in the original window to the correct line and column.
                        -- API columns are 0-indexed, so we subtract 1.
                        vim.api.nvim_win_set_cursor(original_window_id, { item.lnum, item.col - 1 })
                    end)
                end,
            })

            --            vim.api.nvim_create_autocmd('CursorMoved', {
            --                callback = function()
            --                    if vim.bo.filetype == 'qf' then
            --                        -- 6. Every time the cursor moves, this will print the ID we saved in step 1.
            --                        print("Cursor moved in QF. Original window was: " .. currentWindow .. " - " .. i)
            --                        local current_line = vim.fn.getline('.')
            --                        print(current_line)
            --
            --                        -- Location list entries are typically formatted like: "filename|line_num col_num| text".
            --                        -- We need to extract just the filename.
            --                        -- 'vim.fn.split()' is a handy function to break a string into a table (like an array)
            --                        -- based on a delimiter. Here we split the line by the '|' character.
            --                        -- The '[1]' at the end selects the first item from the resulting table, which is the file path.
            --                        local file_path = vim.fn.split(current_line, '|')[1]
            --                        print(file_path)
            --                        local location = vim.fn.split(current_line, '|')[2]
            --                        print(location)
            --                        local line = vim.fn.split(location, 'col')[1]
            --                        local colLocation = vim.fn.split(location, 'col')[2]
            --                        print(file_path .. " - " .. location .. " - " .. line .. " - " .. colLocation)
            --
            --                        i = i + 1
            --                    end
            --                end,
            --            })
        end)

        --        -- This is the standard Neovim function to find all references for the symbol under the cursor.
        --        -- It automatically opens the results in a location list.
        --        vim.lsp.buf.references(nil, {
        --            on_list = function(list)
        --                -- 2. NOW, get the current window ID. This will be the new quickfix window.
        --                local qf_window_id = vim.api.nvim_get_current_win()
        --                print(list)
        --
        --                -- 3. Get the buffer ID from that new window. This will work correctly.
        --                local qf_buffer_id = vim.api.nvim_win_get_buf(qf_window_id)
        --
        --                vim.api.nvim_create_autocmd('CursorMoved', {
        --                    -- Attach this command only to the quickfix buffer.
        --                    buffer = qf_buffer_id,
        --
        --                    -- This callback is a "closure". It remembers `original_window_id`
        --                    -- from the outer function.
        --                    callback = function()
        --                        -- 6. Every time the cursor moves, this will print the ID we saved in step 1.
        --                        print("Cursor moved in QF. Original window was: " .. currentWindow .. " - " .. i)
        --                        i = i + 1
        --                    end,
        --                })
        --            end,
        --        })
    end

    -- Remove your old mapping if you have one, for example:
    vim.keymap.del('n', 'grr')

    -- Create the new mapping
    -- This tells Neovim to execute our custom Lua function when you press <leader>grr in Normal mode.
    vim.keymap.set('n', 'grr', GoToReferencesWithPreview, { desc = 'Lentils - Go to References with Preview' })

    --    -- Create an autocommand that triggers whenever the cursor moves in any buffer.
    --    vim.api.nvim_create_autocmd('CursorMoved', {
    --        -- The 'group' option is good practice to organize autocommands.
    --        -- This allows you to clear all autocommands in this group easily later.
    --        group = vim.api.nvim_create_augroup('LspReferencePreview', { clear = true }),
    --
    --        -- The 'callback' is the function that will run when the 'CursorMoved' event happens.
    --        callback = function()
    --            -- We only want this logic to run when we are inside the location/quickfix list.
    --            -- 'vim.bo.filetype' gets the 'filetype' option for the current buffer ('bo' is short for buffer option).
    --            -- The filetype for location and quickfix lists is 'qf'.
    --            if vim.bo.filetype == 'qf' then
    --                -- Get the entire line the cursor is currently on.
    --                -- 'vim.fn' is a table of functions that are equivalent to Vim's built-in functions.
    --                -- So, 'vim.fn.getline(".")' is the Lua equivalent of Vimscript's 'getline(".")'.
    --                -- The "." argument means "the current line".
    --                local current_line = vim.fn.getline('.')
    --                print(current_line)
    --
    --                -- Location list entries are typically formatted like: "filename|line_num col_num| text".
    --                -- We need to extract just the filename.
    --                -- 'vim.fn.split()' is a handy function to break a string into a table (like an array)
    --                -- based on a delimiter. Here we split the line by the '|' character.
    --                -- The '[1]' at the end selects the first item from the resulting table, which is the file path.
    --                local file_path = vim.fn.split(current_line, '|')[1]
    --                print(file_path)
    --
    --                -- Before trying to open the file, we should check if it actually exists and is readable.
    --                -- 'vim.fn.filereadable()' returns 1 (true in Vim's logic) if the file can be read, and 0 (false) otherwise.
    --                if vim.fn.filereadable(file_path) == 1 then
    --                    -- This is the command that opens the preview.
    --                    -- 'vim.cmd()' executes a Vim command string, just as if you typed it in command mode (with a ':').
    --                    -- The ':pedit' command opens a file in a special "preview window".
    --                    -- The key feature of the preview window is that it doesn't steal focus from your current window.
    --                    -- We concatenate the command string 'pedit ' with the file_path we extracted.
    --                    vim.cmd('pedit ' .. file_path)
    --                end
    --            end
    --        end,
    --    })
    --
    --    vim.api.nvim_create_autocmd('FileType', {
    --        pattern = 'qf',
    --        callback = function()
    --            vim.api.nvim_buf_set_keymap(0, 'n', '<CR>', '<C-w><CR><C-w>p:lclose<CR>', { noremap = true, silent = true })
    --        end,
    --    })
end

return M
