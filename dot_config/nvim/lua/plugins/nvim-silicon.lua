return {
  "michaelrommel/nvim-silicon",
  lazy = true,
  cmd = "Silicon",
  init = function()
    -- Keymap
    local wk = require("which-key")
    wk.register({
      c = {
        name = "ChatGPT",
        x = { "<cmd>Silicon<CR>", "Silicon", mode = { "v" } },
      },
    }, { prefix = "<leader>" })
  end,
  config = function()
    require("silicon").setup({
      -- Configuration here, or leave empty to use defaults
      font = "Iosevka Nerd Font Mono",
      theme = "Dracula",
      background = "#aaaaff",
      shadow_color = "#555555",
      to_clipboard = true,
    })
  end,
}
