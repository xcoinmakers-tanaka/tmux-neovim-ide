return {
  {
    "mg979/vim-visual-multi",
    branch = "master",
    keys = {
      -- VSCode macOS: Cmd+M = Add selection to next match (multi-cursor)
      {
        "<D-m>",
        "<Plug>(VM-Find-Under)",
        mode = { "n", "x" },
        desc = "Multi-cursor: add selection to next match",
      },
    },
  },
}
