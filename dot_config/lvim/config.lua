-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

------------------------
-- Plugins
------------------------
lvim.plugins = {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
  },
  {
    "zbirenbaum/copilot-cmp",
    after = { "copilot.lua" },
    config = function()
      require("copilot_cmp").setup()
    end,
  },
  { "catppuccin/nvim",   name = "catpuccin" },
  { "leoluz/nvim-dap-go" },
  {
    "ggandor/leap.nvim",
    name = "leap",
    config = function()
      require("leap").add_default_mappings()
    end,
  },
  { "stevearc/dressing.nvim" },
  -- { "olexsmir/gopher.nvim" },
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  {
    "ray-x/lsp_signature.nvim",
    event = "BufRead",
    config = function() require "lsp_signature".on_attach() end,
  },
  {
    "folke/todo-comments.nvim",
    event = "BufRead",
    config = function()
      require("todo-comments").setup()
    end,
  },
  -- {
  --   "rmagatti/goto-preview",
  --   config = function()
  --     require('goto-preview').setup {
  --       width = 120,             -- Width of the floating window
  --       height = 25,             -- Height of the floating window
  --       default_mappings = true, -- Bind default mappings
  --       debug = false,           -- Print debug information
  --       opacity = nil,           -- 0-100 opacity level of the floating window where 100 is fully transparent.
  --       post_open_hook = nil     -- A function taking two arguments, a buffer and a window to be ran as a hook.
  --       -- You can use "default_mappings = true" setup option
  --       -- Or explicitly set keybindings
  --       -- vim.cmd("nnoremap gpd <cmd>lua require('goto-preview').goto_preview_definition()<CR>")
  --       -- vim.cmd("nnoremap gpi <cmd>lua require('goto-preview').goto_preview_implementation()<CR>")
  --       -- vim.cmd("nnoremap gP <cmd>lua require('goto-preview').close_all_win()<CR>")
  --     }
  --   end
  -- },
  -- { "AckslD/swenv.nvim" },
  -- { "mfussenegger/nvim-dap-python" },
  -- { "nvim-neotest/neotest" },
  -- { "nvim-neotest/neotest-python" },
  {
    "pwntester/octo.nvim",
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require("octo").setup()
    end,
  },
  {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    config = function()
      require("chatgpt").setup({
        api_key_cmd = "op read op://personal/OpenAI/chatgpt.nvim --no-newline"
      })
    end,
    dependencies = {
      "MunifTanjim/nui.nvim",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim"
    }
  },
  { "ellisonleao/glow.nvim", config = true, cmd = "Glow" }
}

------------------------
-- Theme Annd Colors
------------------------
lvim.colorscheme = "catppuccin-mocha"

------------------------
-- Treesitter
------------------------
lvim.builtin.treesitter.ensure_installed = {
  "go",
  "gomod",
  "python",
}

------------------------
-- Formatting
------------------------
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { command = "goimports", filetypes = { "go" } },
  { command = "gofumpt",   filetypes = { "go" } },
  { command = "prettier",  filetypes = { "yaml" } },
  { name = "black" },
}

lvim.format_on_save = true

------------------------
-- Linting
------------------------
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { command = "flake8", filetypes = { "python" } }
}

------------------------
-- Go Dap
------------------------
local dap_ok, dapgo = pcall(require, "dap-go")
if not dap_ok then
  return
end

dapgo.setup()

------------------------
-- Copilot Configuration
------------------------
local ok, copilot = pcall(require, "copilot")
if not ok then
  return
end

copilot.setup {
  suggestion = {
    keymap = {
      accept = "<c-l>",
      next = "<c-j>",
      prev = "<c-k>",
      dismiss = "<c-h>",
    },
  },
}

local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<c-s>", "<cmd>lua require('copilot.suggestion').toggle_auto_trigger()<CR>", opts)

--------------------------------------
-- Go Development Plugin Configuration
--------------------------------------
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "gopls" })

local lsp_manager = require "lvim.lsp.manager"
lsp_manager.setup("golangci_lint_ls", {
  on_init = require("lvim.lsp").common_on_init,
  capabilities = require("lvim.lsp").common_capabilities(),
})

lsp_manager.setup("gopls", {
  on_attach = function(client, bufnr)
    require("lvim.lsp").common_on_attach(client, bufnr)
    local _, _ = pcall(vim.lsp.codelens.refresh)
    -- local map = function(mode, lhs, rhs, desc)
    --   if desc then
    --     desc = desc
    --   end

    --   vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc, buffer = bufnr, noremap = true })
    -- end
    -- map("n", "<leader>Ci", "<cmd>GoInstallDeps<Cr>", "Install Go Dependencies")
    -- map("n", "<leader>Ct", "<cmd>GoMod tidy<cr>", "Tidy")
    -- map("n", "<leader>Ca", "<cmd>GoTestAdd<Cr>", "Add Test")
    -- map("n", "<leader>CA", "<cmd>GoTestsAll<Cr>", "Add All Tests")
    -- map("n", "<leader>Ce", "<cmd>GoTestsExp<Cr>", "Add Exported Tests")
    -- map("n", "<leader>Cg", "<cmd>GoGenerate<Cr>", "Go Generate")
    -- map("n", "<leader>Cf", "<cmd>GoGenerate %<Cr>", "Go Generate File")
    -- map("n", "<leader>Cc", "<cmd>GoCmt<Cr>", "Generate Comment")
    -- map("n", "<leader>DT", "<cmd>lua require('dap-go').debug_test()<cr>", "Debug Test")
  end,
  on_init = require("lvim.lsp").common_on_init,
  capabilities = require("lvim.lsp").common_capabilities(),
  settings = {
    gopls = {
      usePlaceholders = true,
      gofumpt = true,
      codelenses = {
        generate = false,
        gc_details = true,
        test = true,
        tidy = true,
      },
    },
  },
})

-- local status_ok, gopher = pcall(require, "gopher")
-- if not status_ok then
--   return
-- end

-- gopher.setup {
--   commands = {
--     go = "go",
--     gomodifytags = "gomodifytags",
--     gotests = "gotests",
--     impl = "impl",
--     iferr = "iferr",
--   },
-- }

--------------------------------------
-- Trouble Plugin Configuration
--------------------------------------
lvim.builtin.which_key.mappings["t"] = {
  name = "Diagnostics",
  t = { "<cmd>TroubleToggle<cr>", "trouble" },
  w = { "<cmd>TroubleToggle workspace_diagnostics<cr>", "workspace" },
  d = { "<cmd>TroubleToggle document_diagnostics<cr>", "document" },
  q = { "<cmd>TroubleToggle quickfix<cr>", "quickfix" },
  l = { "<cmd>TroubleToggle loclist<cr>", "loclist" },
  r = { "<cmd>TroubleToggle lsp_references<cr>", "references" },
}

--------------------------------------
-- Swenv Plugin Configuration
--------------------------------------
lvim.builtin.which_key.mappings["C"] = {
  name = "Python",
  c = { "<cmd>lua require('swenv.api').pick_venv()<cr>", "Choose Env" },
}

--------------------------------------
-- Pyright Plugin Configuration
--------------------------------------
local pyright_opts = {
  single_file_support = true,
  settings = {
    pyright = {
      disableLanguageServices = false,
      disableOrganizeImports = false
    },
    python = {
      analysis = {
        autoImportCompletions = true,
        autoSearchPaths = true,
        diagnosticMode = "workspace", -- openFilesOnly, workspace
        typeCheckingMode = "basic",   -- off, basic, strict
        useLibraryCodeForTypes = true
      }
    }
  },
}

require("lvim.lsp.manager").setup("pyright", pyright_opts)

--------------------------------------
-- Jsonls Plugin Configuration
--------------------------------------
local json_opts = {
  settings = {
    json = {
      schemas = vim.list_extend(
        {
          {
            description = "pyright config",
            fileMatch = { "pyrightconfig.json" },
            name = "pyrightconfig.json",
            url =
            "https://raw.githubusercontent.com/microsoft/pyright/main/packages/vscode-pyright/schemas/pyrightconfig.schema.json",
          },
        },
        require('schemastore').json.schemas {
        }
      ),
    },
  },
}

require("lvim.lsp.manager").setup("jsonls", json_opts)

--------------------------------------
-- ChatGPT.nvim Plugin Configuration
--------------------------------------
-- require("chatgpt").setup({
--   api_key_cmd = "op read op://personal/OpenAI/chatgpt.nvim --no-newline"
-- })

local chatgpt = require("chatgpt")
lvim.builtin.which_key.mappings["m"] = {
  name = "ChatGPT",

  -- edit with instructions
  i = {
    function()
      chatgpt.edit_with_instructions()
    end,
    "edit with instructions",
  },

  -- run actions
  e = { "<Cmd>ChatGPTRun explain_code<cr>", "explain code" },
  t = { "<Cmd>ChatGPTRun translate<cr>", "translate" },
  k = { "<Cmd>ChatGPTRun keywords<cr>", "keywords" },
  d = { "<Cmd>ChatGPTRun docstring<cr>", "docstring" },
  a = { "<Cmd>ChatGPTRun grammar_correction<cr>", "add tests" },
  o = { "<Cmd>ChatGPTRun optimize_code<cr>", "optimize code" },
  s = { "<Cmd>ChatGPTRun summarize<cr>", "summarize" },
  f = { "<Cmd>ChatGPTRun fix_bugs<cr>", "fix bugs" },
  -- x = { "<Cmd>ChatGPTRun roxygen_edit<cr>", "roxygen edit" },
  r = { "<Cmd>ChatGPTRun code_readability_analysis<cr>", "code readability analysis" },

  -- chat
  c = { "<Cmd>ChatGPT<cr>", "chat" },

  -- chat persona
  p = { "<Cmd>ChatGPTActAs<Cr>", "act as persona" },
}
