; guix environment --manifest=generic_julia.scm
( specifications->manifest
 '( "make"
    "texlive"
    "emacs-graphviz-dot-mode"
    "dot2tex"
    "texlive-pstool"
    "graphviz"
  )
)
