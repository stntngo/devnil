(module dotfiles.plugins.lspconfig
  {require {core         aniseed.core
            nvim         aniseed.nvim
            lsp          lspconfig
            cmp          cmp
            luasnip      luasnip
            cmp_nvim_lsp cmp_nvim_lsp}})

(let [opts {:noremap true :silent true}]
  (vim.keymap.set :n :gd vim.lsp.buf.definition opts)
  (vim.keymap.set :n :gt vim.lsp.buf.type_definition opts)
  (vim.keymap.set :n :gD vim.lsp.buf.declaration opts)
  (vim.keymap.set :n :gr vim.lsp.buf.references opts)
  (vim.keymap.set :n :gi vim.lsp.buf.implementation opts)
  (vim.keymap.set :n :K  vim.lsp.buf.hover opts)
  (vim.keymap.set :n :<c-k> vim.lsp.buf.signature_help opts)
  (vim.keymap.set :n :<leader>rn vim.lsp.buf.rename opts)
  (vim.keymap.set :n :<c-p> vim.diagnostic.goto_prev opts)
  (vim.keymap.set :n :<c-n> vim.diagnostic.goto_next opts))

; Define the common capabilities of the nvim lsp client in order to provide the
; LSP servers with all of the features the native nvim client is capable of
; supporting
(local capabilities (-> (vim.lsp.protocol.make_client_capabilities)
                        cmp_nvim_lsp.default_capabilities))

(lsp.gopls.setup
  {:name :gopls
   :cmd ["gopls" "-remote=auto" "serve"]
   :init_options {:gofumpt true
                  :staticcheck true
                  :hints {:parameterNames true
                          :functionTypeParameters true
                          :assignVariableTypes true}
                  :memoryMode :DegradeClosed}
   :whitelist [:go]
   :capabilities capabilities})

(vim.api.nvim_create_autocmd
  :LspAttach
  {:group (vim.api.nvim_create_augroup "user_lsp_config" {:clear true})
   :callback 
   (fn [ev]
     (let [bufnr     (. ev :buf)
           client (-> ev
                      (. :data)
                      (. :client_id)
                      vim.lsp.get_client_by_id)
           opts      {:noremap true :silent true :buffer bufnr}]

       (nvim.buf_set_option bufnr :omnifunc "v:lua.vim.lsp.omnifunc")

       ; Formatting
       (when client.server_capabilities.documentFormattingProvider
         (vim.api.nvim_create_autocmd
           :BufWritePre
           {:group (vim.api.nvim_create_augroup (.. "user_lsp_format_b_" bufnr) {:clear true})
            :buffer bufnr
            :callback #(vim.lsp.buf.format {})}))

       ; Code Lens
       (when client.server_capabilities.codeLensProvider
           (let [codelens (vim.api.nvim_create_augroup (.. "user_lsp_code_lens_b_" bufnr) {:clear true})]
             (vim.api.nvim_create_autocmd
               [:BufEnter :InsertLeave :CursorHold]
               {:group codelens
                :callback vim.lsp.codelens.refresh
                :buffer bufnr})))))})

(vim.diagnostic.config
  {:virtual_text {:prefix "●"}})

(->> [[:DiagnosticSignError " "]
      [:DiagnosticSignWarn  " "]
      [:DiagnosticSignHint  " "]
      [:DiagnosticSignInfo  " "]]
     (core.run!
       (fn [[sev text]]
         (vim.fn.sign_define sev {:texthl sev :text text :numhl sev}))))

(cmp.setup
  {:snippet {:expand (fn [args] (luasnip.lsp_expand args.body))}
   :preselect cmp.PreselectMode.None
   :window {}
   :mapping (cmp.mapping.preset.insert
              {:<c-b> (cmp.mapping.scroll_docs -4)
               :<c-f> (cmp.mapping.scroll_docs 4)
               :<tab> (cmp.mapping.select_next_item)
               :<s-tab> (cmp.mapping.select_prev_item)
               :<c-space> (cmp.mapping.complete)
               :<c-e> (cmp.mapping.abort)
               :<cr> (cmp.mapping.confirm {:select false})})
   :sources (cmp.config.sources
              [{:name :nvim_lsp}
               {:name :nvim_lsp_signature_help}
               {:name :luasnip}
               {:name :conjure}
               {:name :path}])})

(set nvim.g.completeopt "menu,menuone,noselect")
(set nvim.g.conjure#filetypes [:clojure :fennel :janet])

(cmp.setup.filetype
  "gitcommit"
  [{:name :cmp_git}
   {:name :buffer}])

(cmp.setup.cmdline
  "/"
  {:mapping (cmp.mapping.preset.cmdline)
   :sources [{:name :buffer}]})

(cmp.setup.cmdline
  ":"
  {:mapping (cmp.mapping.preset.cmdline)
   :sources (cmp.config.sources
              [{:name :path}
               {:name :cmdline}])})
