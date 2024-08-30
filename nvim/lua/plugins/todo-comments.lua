return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  opts = {
    merge_keywords = true,
    keywords = {
      DONOTSUBMIT = { alt = { "DO NOT SUBMIT" }, icon = " ", color = "error" },
    },
  }
}
