-- Override LazyVim's gopls setup to fix:
--   .../extras/lang/go.lua:64: attempt to index local 'semantic' (a nil value)
-- LazyVim's semanticTokens workaround indexes
-- client.config.capabilities.textDocument.semanticTokens without checking it
-- exists; on some capability setups that field is nil and Neovim errors out.
-- This override adds the missing nil guard.
return {
  "neovim/nvim-lspconfig",
  opts = {
    setup = {
      gopls = function(_, _)
        Snacks.util.lsp.on({ name = "gopls" }, function(_, client)
          if client.server_capabilities.semanticTokensProvider then
            return
          end
          local cap = client.config and client.config.capabilities and client.config.capabilities.textDocument
          local semantic = cap and cap.semanticTokens
          if not semantic then
            return
          end
          client.server_capabilities.semanticTokensProvider = {
            full = true,
            legend = {
              tokenTypes = semantic.tokenTypes,
              tokenModifiers = semantic.tokenModifiers,
            },
            range = true,
          }
        end)
        -- returning false lets LazyVim continue with the default lspconfig setup
        return false
      end,
    },
  },
}
