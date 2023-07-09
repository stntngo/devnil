(module init
  {require {core aniseed.core}})

(->> [:plugins.init
      :config.core
      :config.keymap]
      (core.run! require))
