" Vim syntax file
" Language: Macaulay2
" Maintainer: macaulay2.nvim
" Latest Revision: 2024

if exists("b:current_syntax")
  finish
endif

" Case sensitive
syn case match

" Comments
syn match m2Comment "--.*$" contains=m2Todo
syn keyword m2Todo contained TODO FIXME XXX NOTE HACK BUG

" Strings
" Double-quoted strings
syn region m2String start=+"+ skip=+\\\\\|\\"+ end=+"+ contains=m2StringEscape
syn match m2StringEscape contained +\\[\\nrtb"]+

" Triple-slash strings (///...///)
syn region m2String start=+///+ end=+///+

" Numbers
syn match m2Number "\<\d\+\>"
syn match m2Number "\<\d\+\.\d*\>"
syn match m2Number "\<\d*\.\d\+\>"
syn match m2Number "\<\d\+[eE][+-]\=\d\+\>"
syn match m2Number "\<\d\+\.\d*[eE][+-]\=\d\+\>"
syn match m2Number "\<\d*\.\d\+[eE][+-]\=\d\+\>"
" Complex numbers with p for precision
syn match m2Number "\<\d\+p\d\+\>"

" Control flow keywords
syn keyword m2Keyword and break catch continue do else elseif
syn keyword m2Keyword for from global if in list local new not of
syn keyword m2Keyword or return shield step symbol then throw
syn keyword m2Keyword time timing to try when while xor

" Built-in types
syn keyword m2Type Adjacent AfterEval AfterNoPrint AfterPrint
syn keyword m2Type Analyzer AngleBarList Array AssociativeExpression
syn keyword m2Type BasicList BettiTally BinaryOperation Boolean
syn keyword m2Type CC CacheFunction CacheTable ChainComplex ChainComplexMap
syn keyword m2Type CoherentSheaf Command CompiledFunction
syn keyword m2Type CompiledFunctionBody CompiledFunctionClosure
syn keyword m2Type ComplexField Constant Database Descent
syn keyword m2Type Dictionary Divide DocumentTag EngineRing Equation
syn keyword m2Type Expression File FilePosition Function
syn keyword m2Type FunctionApplication FunctionBody FunctionClosure
syn keyword m2Type GaloisField GeneralOrderedMonoid GlobalDictionary
syn keyword m2Type GradedModule GradedModuleMap GroebnerBasis
syn keyword m2Type GroebnerBasisOptions HashTable HeaderType Holder
syn keyword m2Type Ideal ImmutableType IncompatibleMatrices
syn keyword m2Type IndeterminateNumber InexactField InexactFieldFamily
syn keyword m2Type InexactNumber InfiniteNumber IntermediateMarkUpType
syn keyword m2Type Iterator Keyword LibxmlAttribute LibxmlNode List
syn keyword m2Type LocalDictionary LowerBound Manipulator MapExpression
syn keyword m2Type MarkUpType Matrix MatrixExpression MethodFunction
syn keyword m2Type MethodFunctionBinary MethodFunctionSingle
syn keyword m2Type MethodFunctionWithOptions Minus Module Monoid
syn keyword m2Type MonoidElement MonomialIdeal MutableHashTable
syn keyword m2Type MutableList MutableMatrix Net NetFile
syn keyword m2Type NonAssociativeProduct Nothing Number OneExpression
syn keyword m2Type Option OptionTable OrderedMonoid Package
syn keyword m2Type Parenthesize Parser Partition PolynomialRing Power
syn keyword m2Type Product ProductOrder Program ProgramRun
syn keyword m2Type ProjectiveHilbertPolynomial ProjectiveVariety
syn keyword m2Type Pseudocode QQ QuotientRing RR RRi RealField
syn keyword m2Type Resolution Ring RingElement RingFamily RingMap
syn keyword m2Type RowExpression ScriptedFunctor SelfInitializingType
syn keyword m2Type Sequence Set SheafOfRings
syn keyword m2Type SparseMonomialVectorExpression SparseVectorExpression
syn keyword m2Type String Subscript Sum SumOfTwists Superscript
syn keyword m2Type Symbol SymbolBody Table Tally Task Thing Time
syn keyword m2Type Type URL Variety Vector VectorExpression
syn keyword m2Type VerticalList VirtualTally VisibleList WrapperType
syn keyword m2Type ZZ ZeroExpression

" Common functions (most frequently used)
syn keyword m2Function ideal matrix ring map image kernel cokernel
syn keyword m2Function gb groebnerBasis gens mingens basis
syn keyword m2Function dim codim degree hilbertSeries hilbertPolynomial
syn keyword m2Function res resolution betti regularity pdim
syn keyword m2Function saturate quotient intersect radical ann annihilator
syn keyword m2Function primaryDecomposition minimalPrimes associatedPrimes
syn keyword m2Function Ext Hom tensor exteriorPower symmetricPower
syn keyword m2Function det trace transpose inverse rank
syn keyword m2Function substitute sub promote lift coefficients
syn keyword m2Function leadTerm leadCoefficient leadMonomial
syn keyword m2Function homogenize isHomogeneous
syn keyword m2Function random genericMatrix diagonalMatrix
syn keyword m2Function entries flatten join append prepend
syn keyword m2Function apply select position member
syn keyword m2Function sort rsort unique tally set
syn keyword m2Function toString toList toSequence
syn keyword m2Function print error assert use
syn keyword m2Function load needs export
syn keyword m2Function viewHelp help doc
syn keyword m2Function GF frac
syn keyword m2Function sin cos tan exp log sqrt abs floor ceiling round
syn keyword m2Function min max sum product

" Constants
syn keyword m2Constant true false null infinity pi ii
syn keyword m2Constant stdio stderr version

" Operators
syn match m2Operator "[-+*/^]"
syn match m2Operator "\.\."
syn match m2Operator "\.\.\."
syn match m2Operator "//"
syn match m2Operator "\\\\"
syn match m2Operator "=="
syn match m2Operator "!="
syn match m2Operator "<="
syn match m2Operator ">="
syn match m2Operator "[<>]"
syn match m2Operator ":="
syn match m2Operator "<-"
syn match m2Operator "->"
syn match m2Operator "=>"
syn match m2Operator "||"
syn match m2Operator "&&"
syn match m2Operator "@@"
syn match m2Operator "[#_@|:?!~]"

" Delimiters
syn match m2Delimiter "[{}()\[\],;]"

" Special: subscripts and indices
syn match m2Subscript "\w\+_\d\+"
syn match m2Subscript "\w\+_{\w\+}"

" Sync for multiline constructs
syn sync minlines=50
syn sync maxlines=500

" Highlight links
hi def link m2Comment Comment
hi def link m2Todo Todo
hi def link m2String String
hi def link m2StringEscape SpecialChar
hi def link m2Number Number
hi def link m2Keyword Statement
hi def link m2Type Type
hi def link m2Function Function
hi def link m2Constant Constant
hi def link m2Operator Operator
hi def link m2Delimiter Delimiter
hi def link m2Subscript Special

let b:current_syntax = "macaulay2"
