(module plugins.treesitter
  {require {treesitter nvim-treesitter.configs}})

(treesitter.setup
  ; Installing treesitter grammars is handled through home-manager. See home.nix for the list of installed grammars.
  {:ensure_installed []
   :indent {:enable true}
   :highlight {:enable true
               :additional_vim_regex_highlighting false}
   :incremental_selection {:enable true
                           :keymaps {:init_selection :gnn
                                     :node_incremental :grn
                                     :scope_incremental :grc
                                     :node_decremental :grm}}
   :textobjects {:enable true
                 :lsp_interop {:enable true
                               :peek_definition_code {:DF "@function.outer"
                                                      :DF "@class.outer"}}
                 :keymaps {:iL {:go "(function_definition) @function"}
                           :aF "@function.outer"
                           :if "@function.inner"
                           :aC "@class.outer"
                           :iC "@class.inner"
                           :ac "@conditional.outer"
                           :ic "@conditional.inner"
                           :ae "@block.outer"
                           :ie "@block.inner"
                           :al "@loop.outer"
                           :il "@loop.inner"
                           :is "@statement.inner"
                           :as "@statement.outer"
                           :ad "@comment.outer"
                           :am "@call.outer"
                           :im "@call.inner"}
                 :move {:enable true
                        :set_jumps true
                        :goto_next_start {"]m" "@function.outer"
                                          "]]" "@class.outer"}
                        :goto_next_end {"]M" "@function.outer"
                                        "][" "@class.outer"}
                        :goto_previous_start {"[m" "@function.outer"
                                              "[[" "class.outer"}
                        :goto_previous_end {"[M" "@function.outer"
                                            "[]" "@class.outer"}}
                 :select {:enable true
                          :keymaps {:af "@function.outer"
                                    :if "@function.inner"
                                    :ac "@class.outer"
                                    :ic "@class.inner"
                                    :iF {:python "(function_definition) @function"
                                         :cpp    "(function_definition) @function"
                                         :c      "(function_definition) @function"
                                         :java   "(method_declaration) @function"
                                         :go   "(method_declaration) @function"}}}
                 :swap {:enable true
                        :swap_next {"<leader>a" "@parameter.inner"}
                        :swap_previous {"<leader>A" "@parameter.inner"}}}})
