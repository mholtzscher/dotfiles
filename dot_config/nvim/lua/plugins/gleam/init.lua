return {
  recommended = function()
    return LazyVim.extras.wants({
      ft = "gleam",
      root = { "gleam.toml" },
    })
  end,
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        gleam = {},
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      if type(opts.ensure_installed) == "table" then
        vim.list_extend(opts.ensure_installed, { "gleam" })
      end
    end,
  },
}
