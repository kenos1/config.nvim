require("pkg")
Pkg.setup()

local key = {}

key.bind = vim.keymap.set

vim.g.mapleader = " "
vim.opt.clipboard = "unnamedplus"
vim.opt.tabstop = 4
vim.opt.expandtab = true

Pkg.use("plenary")
Pkg.use("nio")
Pkg.use("bg")

Pkg.use("modus")
Pkg.subscribe("modus", function()
        vim.cmd [[colorscheme modus]]
end)
Pkg.load("modus")

Pkg.use("mini")
Pkg.subscribe("mini", function()
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
end)
Pkg.load("mini")

Pkg.use("guess-indent")
Pkg.setup_plugin("guess-indent", {})
Pkg.load("guess-indent")

Pkg.use("lazydev")
Pkg.setup_plugin("lazydev", {})
Pkg.use("lspconfig")
Pkg.subscribe("lspconfig", function()
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

        lspconfig.pylsp.setup {
                cmd = { "uvx", "--from", "python-lsp-server", "pylsp" }
        }

        lspconfig.texlab.setup {}

        Pkg.load("lazydev")
end)
Pkg.load("lspconfig")

Pkg.use("dap")
Pkg.use("dap-ui")
Pkg.use("dap-python")
Pkg.setup_plugin("dap-python", "uv")
Pkg.load("dap-python")

Pkg.use("rainbow-delimiters")
Pkg.setup_plugin("rainbow-delimiters", {})
Pkg.use("nvim-treesitter")
Pkg.subscribe("nvim-treesitter", function()
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
        Pkg.load("rainbow-delimiters")
end)


Pkg.use("navigator")
Pkg.setup_plugin("navigator", {
        lsp = {
                hls = { filetype = {} },
                denols = { filetype = {} },
                rust_analyzer = { filetype = {} }
        }
})
Pkg.use("guihua")
Pkg.setup_plugin("guihua", {})
Pkg.subscribe("guihua", function()
        Pkg.load("navigator")
end)
Pkg.load("guihua")

Pkg.use("telescope")
Pkg.subscribe("telescope", function()
        local telescope = require("telescope")
        local builtin = require("telescope.builtin")

        key.bind("n", "<leader>tf", builtin.find_files)
        key.bind("n", "<leader>tl", builtin.live_grep)
        key.bind("n", "<leader>th", builtin.help_tags)
        key.bind("n", "<leader>tb", builtin.buffers)
end)
Pkg.load("telescope")

Pkg.use("which-key")
Pkg.setup_plugin("which-key", {
        preset = "helix"
})
Pkg.load_on_event("which-key", "UIEnter")

Pkg.use("rust")
Pkg.use("haskell")

Pkg.use("vimtex")
Pkg.subscribe("vimtex", function()
        vim.g.vimtex_compiler_method = "tectonic"
        vim.g.vimtex_view_method = "zathura"
end)
Pkg.load("vimtex")

Pkg.use("snacks")
Pkg.setup_plugin("snacks", {
        terminal = {},
        bigfile = {},
        indent = {},
        input = {},
        toggle = {},
        image = {}
})
Pkg.load("snacks")

Pkg.use("lualine")
Pkg.setup_plugin("lualine", {
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
})
Pkg.load_on_event("lualine", "UIEnter")
