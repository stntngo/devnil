(module plugins.go
  {require {go go}})

(go.setup {:disable_defaults true})

(vim.api.nvim_create_autocmd
  :BufWritePre
  {:group (vim.api.nvim_create_augroup "user_go_import" {:clear true})
   :pattern ["*.go"]
   :callback (fn []
               (let [format (require :go.format)]
                 (format.goimport)))})
