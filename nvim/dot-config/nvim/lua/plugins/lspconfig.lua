return {
  -- configure language servers
  {
    "neovim/nvim-lspconfig",
    ---@class PluginLspOpts
    opts = {
      ---@type lspconfig.options
      servers = {
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
