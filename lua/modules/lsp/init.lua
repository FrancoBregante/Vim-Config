local lspconfig = require "lspconfig"

-- override handlers
pcall(require, "modules.lsp.handlers")

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities.textDocument.completion.completionItem.resolveSupport = {
  properties = {
    "documentation",
    "detail",
    "additionalTextEdits",
  },
}

local servers = {
  -- denols = {
  --   filetypes = { "javascript", "typescript", "typescriptreact" },
  --   root_dir = vim.loop.cwd,
  --   settings = {
  --     documentFormatting = false,
  --     lint = true,
  --     unstable = true,
  --     config = "./tsconfig.json"
  --   },
  -- },
  tsserver = {
    init_options = { documentFormatting = false },
    root_dir = vim.loop.cwd,
  },
  sumneko_lua = require("modules.lsp.sumneko").config,
  jsonls = require("modules.lsp.json").config,
  svelte = require("modules.lsp.svelte").config,
  html = { cmd = { "html-languageserver", "--stdio" } },
  cssls = { cmd = { "css-languageserver", "--stdio" } },
  clangd = {},
  gopls = {
    settings = {
      gopls = {
        codelenses = {
          references = true,
          test = true,
          tidy = true,
          upgrade_dependency = true,
          generate = true,
        },
        gofumpt = true,
      },
    },
  },
  solargraph = {
    root_dir = vim.loop.cwd,
    settings = {
      solargraph = {
        diagnostic = true,
        logLevel = "debug",
        transport = "stdio",
      },
    },
  },
  pyright = {},
  texlab = {},
  angularls = {},
  julials = {},
  -- ["null-ls"] = {},
}

require("plugins.null-ls").setup()

for name, opts in pairs(servers) do
  if type(opts) == "function" then
    opts()
  else
    local client = lspconfig[name]
    client.setup(vim.tbl_extend("force", {
      flags = { debounce_text_changes = 150 },
      on_attach = Util.lsp_on_attach,
      on_init = Util.lsp_on_init,
      capabilities = capabilities,
    }, opts))
  end
end
