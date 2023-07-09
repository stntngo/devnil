(module plugins.init
  {require {core   aniseed.core}})

(->> [:plugins.go
      :plugins.lspconfig
      :plugins.lualine
      :plugins.mini
      :plugins.telescope
      :plugins.treesitter]
     (core.run! require))
