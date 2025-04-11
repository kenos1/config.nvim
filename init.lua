local pkg = {}

local config_dir = vim.fn.stdpath("config")

--- @type table
Loaded_plugins = {}

function pkg.use(name, opts)
        pcall(function()
                vim.opt.runtimepath:prepend(config_dir .. "/plugins/" .. name)

                Loaded_plugins[name] = false

                local load_func = function()
                        if opts.config then
                                opts.config()
                        else
                                local module = require(name)
                                if module.setup then
                                        module.setup {}
                                end
                        end
                        Loaded_plugins[name] = true
                end

                if opts.filetype then
                        local patterns = {}

                        local fmt_ft = function(ft)
                                return "*" .. "." .. ft
                        end

                        if type(opts.filetype) == "string" then
                                patterns = fmt_ft(opts.filetype)
                        else
                                for _, ft in ipairs(opts.filetype) do
                                        table.insert(patterns, fmt_ft(ft))
                                end
                        end

                        vim.api.nvim_create_autocmd({ "BufEnter" }, {
                                once = true,
                                pattern = patterns,
                                callback = load_func
                        })
                end
                if opts.event then
                        local events = opts.event
                        if type(opts.event) == "string" then
                                events = { opts.event }
                        end

                        vim.api.nvim_create_autocmd(events, {
                                once = true,
                                callback = load_func
                        })
                        return
                end

                load_func()
        end)
end

vim.api.nvim_create_user_command("PkgList", function()
        local buf = ""
        for name, loaded in pairs(Loaded_plugins) do
                local loaded_str = ""
                if loaded then
                        loaded_str = "Loaded"
                else
                        loaded_str = "Not Loaded"
                end
                buf = buf .. name .. " : " .. loaded_str .. "\n"
        end
        vim.print(buf)
end, {})

local key = {}

key.bind = vim.keymap.set

vim.g.mapleader = " "
vim.opt.clipboard = "unnamedplus"
vim.opt.tabstop = 4
vim.opt.expandtab = true

pkg.use("plenary")
pkg.use("nio")

pkg.use("bg", {
        event = "UIEnter",
        config = function() end
})

pkg.use("modus", {
        event = "UIEnter",
        config = function()
                vim.cmd [[colorscheme modus]]
        end
})

pkg.use("mini", {
        config = function()
                require "mini.basics".setup {}
                require "mini.pairs".setup {}
                require "mini.tabline".setup {}
                require "mini.cursorword".setup {}
                require "mini.align".setup {}
                require "mini.move".setup {}
                require "mini.surround".setup {}
                require "mini.comment".setup {}
                require "mini.bracketed".setup {}
                require "mini.jump2d".setup {}
                require "mini.completion".setup {}
                require "mini.animate".setup {
                        scroll = {
                                enable = false
                        }
                }
        end
})

pkg.use("guess-indent", {})

pkg.use("lspconfig", {
        config = function()
                local lspconfig = require("lspconfig")

                vim.diagnostic.config({
                        virtual_text = true,
                        update_in_insert = true
                })

                key.bind("n", "<leader>ls", "<cmd>LspStart<cr>")
                key.bind("n", "<leader>lS", "<cmd>LspStop<cr>")
                key.bind("n", "<leader>lr", "<cmd>LspStop<cr>")
                key.bind("n", "<leader>ll", "<cmd>LspLog<cr>")
                key.bind("n", "<leader>li", "<cmd>LspInfo<cr>")

                lspconfig.ts_ls.setup {
                        cmd = { "bun", "x", "--bun", "typescript-language-server", "--stdio" }
                }
        end
})

pkg.use("dap")

pkg.use("dap-python", {
        config = function()
                require("dap-python").setup("uv")
        end
})

pkg.use("dap-ui")


pkg.use("lazydev", {
        filetype = "lua"
})

pkg.use("nvim-treesitter", {
        config = function()
                require "nvim-treesitter.configs".setup {
                        ensure_installed = { "lua", "vimdoc", "c", "cpp", "javascript", "typescript" },
                        auto_install = true,
                        sync_install = false,
                        ignore_install = {},
                        modules = {},
                        highlight = {
                                enable = true
                        }
                }
        end
})

pkg.use("rainbow-delimiters", {})

pkg.use("guihua", {})
pkg.use("navigator", {
        config = function()
                require "navigator".setup {
                        lsp = {
                                hls = { filetype = {} },
                                denols = { filetype = {} },
                                rust_analyzer = { filetype = {} }
                        }
                }
        end
})

pkg.use("telescope", {
        config = function()
                local telescope = require("telescope")
                local builtin = require("telescope.builtin")

                key.bind("n", "<leader>tf", builtin.find_files)
                key.bind("n", "<leader>tl", builtin.live_grep)
                key.bind("n", "<leader>th", builtin.help_tags)
                key.bind("n", "<leader>tb", builtin.buffers)
        end
})

pkg.use("which-key", {
        event = "UIEnter",
        config = function()
                require("which-key").setup {
                        preset = "helix"
                }
        end
})

pkg.use("rust", {})
pkg.use("haskell", {})

pkg.use("snacks", {
        config = function()
                require("snacks").setup {
                        terminal = {},
                        bigfile = {},
                        indent = {},
                        input = {},
                        toggle = {}
                }
        end
})

pkg.use("lualine", {
        event = "UIEnter",
        config = function()
                require("lualine").setup {
                        options = {
                                component_separators = { left = '', right = '' },
                                section_separators = { left = '', right = '' },
                        },
                        sections = {
                                lualine_a = {},
                                lualine_b = {},
                                lualine_c = { "mode", "filename" },
                                lualine_x = { "filesize", "filetype", "branch", "lsp_status" },
                                lualine_y = {},
                                lualine_z = {}
                        }
                }
        end
})
