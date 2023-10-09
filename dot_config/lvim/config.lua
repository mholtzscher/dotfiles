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
  {
    "catppuccin/nvim",
    name = "catpuccin",
  },
  {
    "leoluz/nvim-dap-go",
  },
  -- {
  --   "ggandor/leap.nvim",
  --   name = "leap",
  --   config = function()
  --     require("leap").add_default_mappings()
  --   end,
  -- },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    ---@type Flash.Config
    opts = {},
    -- stylua: ignore
    keys = {
      { "s", mode = { "n", "o", "x" }, function() require("flash").jump() end,       desc = "Flash" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash Treesitter" },
      { "r", mode = "o",               function() require("flash").remote() end,     desc = "Remote Flash" },
      {
        "R",
        mode = { "o", "x" },
        function() require("flash").treesitter_search() end,
        desc =
        "Treesitter Search"
      },
      {
        "<c-s>",
        mode = { "c" },
        function() require("flash").toggle() end,
        desc =
        "Toggle Flash Search"
      },
    },
  },
  {
    "stevearc/dressing.nvim",
  },
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  {
    "folke/todo-comments.nvim",
    event = "BufRead",
    config = function()
      require("todo-comments").setup()
    end,
  },
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
    keys = {
      { "<leader>O", "<cmd>Octo actions<cr>", desc = "Octo" },
    }
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
  {
    "piersolenski/wtf.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
    },
    opts = {},
    --stylua: ignore
    keys = {
      { "<leader>xa", function() require("wtf").ai() end,     desc = "Search Diagnostic with AI" },
      { "<leader>xg", function() require("wtf").search() end, desc = "Search Diagnostic with Google" },
    },
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
      "nvim-neotest/neotest-go",
      "sidlatau/neotest-dart",
    },
    keys = {
      {
        "<leader>tF",
        "<cmd>w|lua require('neotest').run.run({vim.fn.expand('%'), strategy = 'dap'})<cr>",
        desc =
        "Debug File"
      },
      {
        "<leader>tL",
        "<cmd>w|lua require('neotest').run.run_last({strategy = 'dap'})<cr>",
        desc =
        "Debug Last"
      },
      {
        "<leader>ta",
        "<cmd>w|lua require('neotest').run.attach()<cr>",
        desc =
        "Attach"
      },
      { "<leader>tf", "<cmd>w|lua require('neotest').run.run(vim.fn.expand('%'))<cr>", desc = "File" },
      { "<leader>tl", "<cmd>w|lua require('neotest').run.run_last()<cr>",              desc = "Last" },
      {
        "<leader>tn",
        "<cmd>w|lua require('neotest').run.run()<cr>",
        desc =
        "Nearest"
      },
      {
        "<leader>tN",
        "<cmd>w|lua require('neotest').run.run({strategy = 'dap'})<cr>",
        desc =
        "Debug Nearest"
      },
      {
        "<leader>to",
        "<cmd>w|lua require('neotest').output.open({ enter = true })<cr>",
        desc =
        "Output"
      },
      { "<leader>ts", "<cmd>w|lua require('neotest').run.stop()<cr>",              desc = "Stop" },
      {
        "<leader>tS",
        "<cmd>w|lua require('neotest').summary.toggle()<cr>",
        desc =
        "Summary"
      },
      { "<leader>tA", "<cmd>w|lua require('neotest').run.run(vim.fn.getcwd()<cr>", desc = "All" },
    },
    config = function()
      -- get neotest namespace (api call creates or returns namespace)
      local neotest_ns = vim.api.nvim_create_namespace("neotest")
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message =
                diagnostic.message:gsub("\n", " "):gsub("\t", " "):gsub("%s+", " "):gsub("^%s+", "")
            return message
          end,
        },
      }, neotest_ns)
      require("neotest").setup({
        -- your neotest config here
        adapters = {
          require("neotest-go"),
        },
      })
    end,
  },
  {
    'stevearc/aerial.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons"
    },
  },
  {
    'pfeiferj/nvim-hurl',
  },
  {
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    config = function()
      require('treesj').setup({ use_default_keymaps = false })
    end,
  },
  {
    'akinsho/flutter-tools.nvim',
    lazy = false,
    dependencies = {
      'nvim-lua/plenary.nvim',
      'stevearc/dressing.nvim', -- optional for vim.ui.select
      "RobertBrunhage/flutter-riverpod-snippets",
    },
    config = function()
      require("flutter-tools").setup {
        dev_log = {
          open_cmd = "e",
        },
      }
    end,
    keys = {
      { "<leader>F", "<cmd>Telescope flutter commands<cr>", desc = "Flutter Tools" }
    }
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      -- add any options here
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    }
  },
}

------------------------
-- Theme Annd Colors
------------------------
require("catppuccin").setup()
lvim.colorscheme = "catppuccin-mocha"
------------------------
-- Treesitter
------------------------
lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "go",
  "gomod",
  "hcl",
  "json",
  "python",
  "typescript",
  "tsx",
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
  { command = "buf",       filetypes = { "proto" } },
  { command = "taplo" }
}

lvim.format_on_save = true

------------------------
-- Linting
------------------------
local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
  { command = "flake8", filetypes = { "python" } },
  { command = "buf",    filetypes = { "proto" } },
}

------------------------
-- nvim-dap launch.json Configuration
------------------------
local ds = lvim.builtin.which_key.mappings["d"]
ds["l"] = { "<cmd>lua require('dap.ext.vscode').load_launchjs()<cr>", "load launch.json" }

------------------------
-- Go Dap Configuration
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

--------------------------------------
-- Trouble Plugin Configuration
--------------------------------------
lvim.builtin.which_key.mappings["x"] = {
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
  r = { "<Cmd>ChatGPTRun code_readability_analysis<cr>", "code readability analysis" },

  -- chat
  c = { "<Cmd>ChatGPT<cr>", "chat" },

  -- chat persona
  p = { "<Cmd>ChatGPTActAs<Cr>", "act as persona" },
}

--------------------------------------
-- dressing.nvim Plugin Configuration
--------------------------------------
require('dressing').setup({
  input = {
    win_options = {
      winhighlight = 'NormalFloat:DiagnosticError'
    }
  }
})

--------------------------------------
-- aerial.nvim Plugin Configuration
--------------------------------------
require('aerial').setup({
  -- optionally use on_attach to set keymaps when aerial has attached to a buffer
  on_attach = function(bufnr)
    -- Jump forwards/backwards with '{' and '}'
    vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
    vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
  end
})

local xs = lvim.builtin.which_key.mappings["x"]
xs["o"] = { "<cmd>AerialToggle!<cr>", "Toggle Aerial" }

--------------------------------------
-- nvim-hurl Plugin Configuration
--------------------------------------
require("hurl").setup()

local ls = lvim.builtin.which_key.mappings["l"]
ls["h"] = { "<cmd>Hurl<cr>", "Hurl" }

--------------------------------------
-- treesj Plugin Configuration
--------------------------------------
-- local ls = lvim.builtin.which_key.mappings["l"]
ls["t"] = { "<cmd>TSJToggle<cr>", "toggle split/join" }

--------------------------------------
-- flutter-tools Plugin Configuration
--------------------------------------
require("telescope").load_extension("flutter")

-- local gs = lvim.builtin.which_key.mappings["g"]
ls["g"] = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Go to Definition" }

--------------------------------------
-- noice.nvim Plugin Configuration
--------------------------------------
require("noice").setup({
  lsp = {
    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
    override = {
      ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
      ["vim.lsp.util.stylize_markdown"] = true,
      ["cmp.entry.get_documentation"] = true,
    },
  },
  -- you can enable a preset for easier configuration
  presets = {
    bottom_search = true,         -- use a classic bottom cmdline for search
    command_palette = true,       -- position the cmdline and popupmenu together
    long_message_to_split = true, -- long messages will be sent to a split
    inc_rename = false,           -- enables an input dialog for inc-rename.nvim
    lsp_doc_border = false,       -- add a border to hover docs and signature help
  },
})
