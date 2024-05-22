return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      require("lspconfig").gleam.setup({})
    end,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed, {
        "gleam",
      })
    end,
  },
}
