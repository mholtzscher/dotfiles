return {
  {
    "maxandron/goplements.nvim",
    ft = "go",
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },
  {
    "Jay-Madden/auto-fix-return.nvim",
    config = function()
      require("auto-fix-return").setup({})
    end,
  },
}
