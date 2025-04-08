local pkg = {}

local config_dir = vim.fn.stdpath("config")

function pkg.use(name, opts)
  vim.opt.runtimepath:prepend(config_dir .. "/plugins/" .. name)

  if not opts then
    return
  end
  if opts.config then
    opts.config()
  else
    local module = require(name)
    if module.setup then
      module.setup {}
    end
  end
end

local key = {}

key.bind = vim.keymap.set

vim.g.mapleader = " "

pkg.use("bg")

pkg.use("modus", {
  config = function()
    vim.cmd [[colorscheme modus]]
  end
})

pkg.use("mini", {
  config = function()
    require "mini.basics".setup {}
    require "mini.pairs".setup {}
    require "mini.statusline".setup {}
    require "mini.tabline".setup {}
    require "mini.cursorword".setup {}
    require "mini.align".setup {}
    require "mini.move".setup {}
    require "mini.surround".setup {}
    require "mini.comment".setup {}
    require "mini.bracketed".setup {}
    require "mini.jump2d".setup {}
    require "mini.indentscope".setup {}
    require "mini.completion".setup {}
  end
})

pkg.use("guess-indent", {})

pkg.use("which-key", {})

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


pkg.use("lazydev", {})

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
        disable_lsp = { "denols", "hls", "rust-analyzer" }
      }
    }
  end
})

pkg.use("plenary")
pkg.use("telescope", {
  config = function()
    local telescope = require("telescope")
    local builtin = require("telescope.builtin")

    key.bind("n", "<leader>tf", builtin.find_files)
    key.bind("n", "<leader>tl", builtin.live_grep)
    key.bind("n", "<leader>tb", builtin.buffers)
  end
})

pkg.use("rust")
pkg.use("haskell")
