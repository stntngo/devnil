(module plugins.mini
  {require {surround mini.surround
            commentary  mini.comment}})

; Enable use of the "surround" motions.
(surround.setup {})

; Enable use of gc motion to comment out
; lines of code
(commentary.setup {})
