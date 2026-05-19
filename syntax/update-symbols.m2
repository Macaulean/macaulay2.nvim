needsPackage "Style"

generateGrammar(
    currentFileDirectory | "macaulay2.vim.in",
    currentFileDirectory | "macaulay2.vim",
    x -> demark(" ", x))
