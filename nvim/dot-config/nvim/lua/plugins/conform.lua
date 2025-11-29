return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        gdscript = { "gdformat" },
        c = { "clang_format" },
        cpp = { "clang_format" },
        sh = { "shfmt" },
      },
    },
  },
}
