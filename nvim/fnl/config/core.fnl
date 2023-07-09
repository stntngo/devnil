(module config.core
  {require {nvim  aniseed.nvim}})

(vim.cmd "colorscheme nordfox")

(set nvim.o.mousehide true)
(set nvim.o.number true)
(set nvim.o.showmatch true)
(set nvim.o.termguicolors true)
(set nvim.o.undofile true)
(vim.opt_global.shortmess:remove :F)

; NOTE: I don't know how I feel about this yet...
; I've switched back and forth between relativenumber
; and normal numbers historically and I really don't
; feel strongly one way or the other.
(set nvim.o.relativenumber false)

; NOTE: I hate folding. I want to see the code, and
; recently I've had folding turned back on for some reason
; that I don't know.
(let [group (nvim.create_augroup
              :no-fold
              {:clear true})]
  (nvim.create_autocmd
    [:BufWritePost :BufEnter]
    {:pattern ["*"]
     :command "set nofoldenable foldmethod=manual foldlevelstart=99"
     :group group}))

(set vim.g.conjure_filetypes ["clojure" "fennel" "janet" "hy" "racket" "scheme" "lisp"])
