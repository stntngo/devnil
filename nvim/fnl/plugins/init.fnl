(module plugins.init
  {require {core   aniseed.core}})

(->> [:plugins.lspconfig
      :plugins.lualine
      :plugins.mini
      :plugins.telescope
      :plugins.treesitter]
     (core.run! require))
