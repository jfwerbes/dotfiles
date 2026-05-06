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
          filetypes = { "sh", "zsh" },
        },
        pyright = {
          settings = {
            python = {
              analysis = {
                typeCheckingMode = "strict",
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true,
              },
            },
          },
        },
        clangd = {},
        gdscript = {},
        gdshader_lsp = {},
      },
    },
  },
}
