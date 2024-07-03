local cmp = require('cmp')
local cmp_lsp = require("cmp_nvim_lsp")
local capabilities = vim.tbl_deep_extend(
  "force",
  {},
  vim.lsp.protocol.make_client_capabilities(),
  cmp_lsp.default_capabilities()
)

require("fidget").setup({})
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "rust_analyzer",
    "gopls",
    "solargraph",
    "tsserver"
  },
  handlers = {
    function(server_name) -- default handler (optional)
      require("lspconfig")[server_name].setup {
        capabilities = capabilities,
        on_attach = function(_, bufnr)
          local buf_set_keymap = function(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
          local opts = { noremap = true, silent = true }

          buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
          buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
          buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
          buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
        end,
      }
    end,

    zls = function()
      local lspconfig = require("lspconfig")
      lspconfig.zls.setup({
        root_dir = lspconfig.util.root_pattern(".git", "build.zig", "zls.json"),
        settings = {
          zls = {
            enable_inlay_hints = true,
            enable_snippets = true,
            warn_style = true,
          },
        },
        on_attach = function(_, bufnr)
          local buf_set_keymap = function(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
          local opts = { noremap = true, silent = true }

          buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
          buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
          buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
          buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
        end,
      })
      vim.g.zig_fmt_parse_errors = 0
      vim.g.zig_fmt_autosave = 0
    end,

    ["lua_ls"] = function()
      local lspconfig = require("lspconfig")
      lspconfig.lua_ls.setup {
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = { version = "Lua 5.1" },
            diagnostics = {
              globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
            }
          }
        },
        on_attach = function(_, bufnr)
          local buf_set_keymap = function(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
          local opts = { noremap = true, silent = true }

          buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
          buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
          buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
          buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
        end,
      }
    end,
  }
})

local cmp_select = { behavior = cmp.SelectBehavior.Select }

cmp.setup({
  snippet = {
    expand = function(args)
      require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' }, -- For luasnip users.
  }, {
    { name = 'buffer' },
  })
})

vim.diagnostic.config({
  virtual_text = false,
  signs = false,
  underline = false,
  update_in_insert = false,
  severity_sort = false,
  float = {
    focusable = false,
    style = "minimal",
    border = "rounded",
    source = "always",
    header = "",
    prefix = "",
  },
})

