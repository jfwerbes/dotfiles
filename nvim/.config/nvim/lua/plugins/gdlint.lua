-- .config/nvim/lua/file.lua
return {
  {
    "mfussenegger/nvim-lint",
    config = function()
      local lint = require("lint")

      -- Register gdlint as the linter for gdscript
      lint.linters_by_ft = {
        gdscript = { "gdlint" },
      }

      -- Run linting automatically on every write
      vim.api.nvim_create_autocmd("BufWritePost", {
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
}
