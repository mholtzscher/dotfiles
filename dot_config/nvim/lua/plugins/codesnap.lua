return {
  {
    "mistricky/codesnap.nvim",
    build = "make",
    init = function()
      -- Keymap
      local wk = require("which-key")
      wk.register({
        c = {
          x = { ":CodeSnap<CR>", "CodeSnap", mode = { "v" } },
        },
      }, { prefix = "<leader>" })
    end,

    config = function()
      require("codesnap").setup({
        has_breadcrumbs = true,
        bg_theme = "grape",
        code_font_family = "Iosevka Nerd Font Mono",
      })
    end,
  },
}
