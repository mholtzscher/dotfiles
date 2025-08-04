return {
  -- this is needed fro octo.nvim to work. there is open pr for snacks to work
  "ibhagwan/fzf-lua",
  dependencies = { "echasnovski/mini.icons" },
  opts = {
    files = {
      formatter = "path.filename_first",
    },
  },
}
