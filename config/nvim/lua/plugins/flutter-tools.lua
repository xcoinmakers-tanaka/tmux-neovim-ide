return {
  {
    "nvim-flutter/flutter-tools.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "stevearc/dressing.nvim",
    },
    opts = {
      lsp = {
        on_attach = function(_, bufnr)
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
          end
          map("n", "<F12>", vim.lsp.buf.definition, "Go to definition")
          map("n", "gd", vim.lsp.buf.definition, "Go to definition")
          map("n", "K", vim.lsp.buf.hover, "Hover documentation")
          map("n", "<F2>", vim.lsp.buf.rename, "Rename symbol")
        end,
        settings = {
          showTodos = true,
          completeFunctionCalls = true,
        },
      },
      widget_guides = { enabled = true },
      debugger = {
        enabled = true, -- integrates with nvim-dap (see dap.lua)
        register_configurations = function()
          require("dap").adapters.dart = {
            type = "executable",
            command = "flutter",
            args = { "debug_adapter" },
          }
        end,
      },
    },
    -- Note: capital-F prefix to avoid colliding with fzf.lua's <leader>f* bindings
    keys = {
      { "<leader>Fr", "<cmd>FlutterRun<cr>", desc = "Flutter run" },
      { "<leader>FR", "<cmd>FlutterHotReload<cr>", desc = "Flutter hot reload" },
      { "<leader>Fq", "<cmd>FlutterQuit<cr>", desc = "Flutter quit" },
      { "<leader>Fd", "<cmd>FlutterDevices<cr>", desc = "Flutter devices" },
    },
  },
}
