local wk = require("which-key")

wk.register({
  m = {
    name = "ChatGPT",
    z = { "<cmd>Gen<CR>", "Ollama Gen", mode = { "n", "v" } },
  },
}, { prefix = "<leader>" })

return {
  "David-Kunz/gen.nvim",
  config = function()
    local gen = require("gen")
    gen.setup({
      model = "mistral",
      display_mode = "split",
      show_model = "true",
      debug = false,
    })

    gen.prompts["X_Generate_Simple_Description"] = {
      prompt = "Provide a simple and concise description of the following code:\n$register",
      replace = false,
    }

    gen.prompts["X_Generate_Description"] = {
      prompt = "Provide a detailed description of the following code:\n$register",
      replace = false,
    }

    gen.prompts["X_Suggest_Better_Naming"] = {
      prompt = "Take all variable and function names, and provide only a list with suggestions with improved naming:\n$register",
      replace = false,
    }

    gen.prompts["X_Enhance_Grammar_Spelling"] = {
      prompt = "Modify the following text to improve grammar and spelling, just output the final text in English without additional quotes around it:\n$register",
      replace = false,
    }

    gen.prompts["X_Enhance_Wording"] = {
      prompt = "Modify the following text to use better wording, just output the final text without additional quotes around it:\n$register",
      replace = false,
    }

    gen.prompts["X_Make_Concise"] = {
      prompt = "Modify the following text to make it as simple and concise as possible, just output the final text without additional quotes around it:\n$register",
      replace = false,
    }

    gen.prompts["X_Review_Code"] = {
      prompt = "Review the following code and make concise suggestions:\n```$filetype\n$register\n```",
    }

    gen.prompts["X_Enhance_Code"] = {
      prompt = "Enhance the following code, only output the result in format ```$filetype\n...\n```:\n```$filetype\n$register\n```",
      replace = false,
      extract = "```$filetype\n(.-)```",
    }

    gen.prompts["X_Simplify_Code"] = {
      prompt = "Simplify the following code, only output the result in format ```$filetype\n...\n```:\n```$filetype\n$register\n```",
      replace = false,
      extract = "```$filetype\n(.-)```",
    }

    gen.prompts["X_Ask"] = { prompt = "Regarding the following text, $input:\n$register" }
  end,
}
