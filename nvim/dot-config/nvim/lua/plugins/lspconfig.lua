return {
  -- add pyright to lspconfig
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
        -- pyright will be automatically installed with mason and loaded with lspconfig
        bashls = {
          settings = {
            filetypes = { "sh", "zsh" },
          },
        },
        pyright = {},
        clangd = {},
        gdscript = {},
        gdshader_lsp = {},
      },
    },
  },
}
