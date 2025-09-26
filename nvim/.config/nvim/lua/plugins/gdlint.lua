return {
  "mfussenegger/nvim-lint",
  opts = {
    -- Map the `gdscript` filetype to the custom `gdlint` linter
    linters_by_ft = {
      gdscript = { "gdlint" },
    },
    linters = {
      -- Define the custom `gdlint` linter
      gdlint = {
        -- `gdtoolkit` is the package that provides `gdlint`.
        -- If the executable isn't directly `gdlint`, adjust this `cmd` value.
        cmd = "gdlint",
        stdin = false,
        args = { "$FILE" },
        stream = "stdout",
        -- The parser is based on `gdlint`'s output format.
        parser = require("lint.parser").from_errorformat(
          "%f:%l:%c: %t: %m",
          -- The skeleton table maps the captured groups to diagnostic fields
          {
            file = "%f",
            lnum = "%l",
            col = "%c",
            type = "%t",
            message = "%m",
          }
        ),
      },
    },
  },
  config = function(_, opts)
    -- Extend the default linters with your custom ones
    for name, linter in pairs(opts.linters) do
      require("lint").linters[name] = linter
    end
    require("lint").linters_by_ft = opts.linters_by_ft

    -- Create an autocommand to run linters on save
    vim.api.nvim_create_autocmd({ "BufWritePost" }, {
      callback = function()
        require("lint").try_lint()
      end,
    })
  end,
}
