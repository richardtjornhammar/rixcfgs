; guix environment --manifest=generic_python.scm
( specifications->manifest
 '( "python"
    "python-numpy"
    "python-pandas"
    "python-matplotlib"
    "python-seaborn"
    "python-networkx"
    "python-scipy"
    "python-statsmodels"
    "python-pip"
    "python-scikit-learn"
    "graphviz"
  )
)
