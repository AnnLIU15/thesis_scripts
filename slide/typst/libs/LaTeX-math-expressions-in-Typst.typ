// LaTeX MATH EXPRESSIONS IN TYPST
// (based on https://mirrors.ctan.org/info/symbols/math/maths-symbols.pdf and https://mirrors.ctan.org/fonts/newcomputermodern/doc/newcm-unimath-symbols.pdf)

// Math Alphabets
#let mathrm(input) = { $serif(#input)$ }
#let mathsf(input) = { $sans(#input)$ }
#let mathtt(input) = { $mono(#input)$ }
#let mathup(input) = { $upright(#input)$ }
#let mathit(input) = { $italic(#input)$ }
#let mathbf(input) = { $bold(#input)$ }
#let mathbb(input) = { $bb(#input)$ }
#let mathcal(input) = { $cal(#input)$ }
#let mathscr(input) = { $cal(#input)$ } // see https://tex.stackexchange.com/q/361688 and https://zhuanlan.zhihu.com/p/569922028
#let mathfrak(input) = { $frak(#input)$ }
#let mathnormal(input) = { $serif(italic(#input))$ }

// Greek Letters
#let varepsilon = { $epsilon.alt$ } // the default \epsilon in LaTeX
#let vartheta = { $theta.alt$ }
#let varkappa = { $kappa.alt$ }
#let varpi = { $pi.alt$ }
#let varrho = { $rho.alt$ }
#let varphi = { $phi.alt$ } // the default \phi in LaTeX

// Binary Operation Symbols
#let pm = { $plus.minus$ }
#let mp = { $minus.plus$ }
#let Ast = { $ast.op$ }
#let star = { $star.op$ }
#let circ = { $compose$ }
#let bullet = { $•$ }
#let cdot = { $dot.op$ }
#let cap = { $inter$ }
#let cup = { $union$ }
#let uplus = { $union.plus$ }
#let sqcap = { $inter.sq$ }
#let sqcup = { $union.sq$ }
#let vee = { $and$ }
#let land = { $and$ }
#let wedge = { $or$ }
#let lor = { $or$ }
#let setminus = { $without$ }
#let wr = { $wreath$ }
#let smalldiamond = { $diamond.stroked.small$ }
#let bigtriangleup = { $triangle.stroked.t$ }
#let bigtriangledown = { $triangle.stroked.b$ }
#let triangleleft = { $triangle.stroked.l$ }
#let triangleright = { $triangle.stroked.r$ }
#let smalltriangleleft = { $triangle.stroked.small.l$ }
#let smalltriangleright = { $triangle.stroked.small.r$ }
#let oplus = { $plus.o$ }
#let ominus = { $minus.o$ }
#let otimes = { $times.o$ }
#let oslash = { $⊘$ }
#let odot = { $dot.o$ }
#let bigcirc = { $circle.big$ }
#let ddagger = { $dagger.double$ }
#let amalg = { $⨿$ }

// Relation Symbols
#let leq = { $lt.eq$ }
#let preceq = { $⪯$ }
#let ll = { $lt.double$ }
#let subseteq = { $subset.eq$ }
#let sqsubseteq = { $subset.eq.sq$ }
#let vdash = { $⊢$ }
#let geq = { $gt.eq$ }
#let succeq = { $⪰$ }
#let gg = { $gt.double$ }
#let supseteq = { $supset.eq$ }
#let sqsupseteq = { $supset.eq.sq$ }
#let ni = { $in.rev$ }
#let dashv = { $⊣$ }
#let sim = { $tilde.op$ }
#let simeq = { $tilde.eq$ }
#let asymp = { $≍$ }
#let cong = { $tilde.equiv$ }
#let neq = { $eq.not$ }
#let doteq = { $≐$ }
#let propto = { $prop$ }

// Punctuation Symbols
#let cdotp = { $dot.c$ }

// Arrow symbols
#let leftarrow = { $arrow.l$ }
#let Leftarrow = { $arrow.l.double$ }
#let rightarrow = { $arrow.r$ }
#let to = { $arrow.r$ }
#let Rightarrow = { $arrow.r.double$ }
#let leftrightarrow = { $arrow.l.r$ }
#let Leftrightarrow = { $arrow.l.r.double$ }
#let mapsto = { $arrow.r.bar$ }
#let hookleftarrow = { $arrow.l.hook$ }
#let leftharpoonup = { $harpoon.lt$ }
#let leftharpoondown = { $harpoon.lb$ }
#let rightleftharpoons = { $harpoons.rtlb$ }
#let longleftarrow = { $arrow.l.long$ }
#let Longleftarrow = { $arrow.l.double.long$ }
#let longrightarrow = { $arrow.r.long$ }
#let Longrightarrow = { $arrow.r.double.long$ }
#let implies = { $thin thin arrow.r.double.long thin thin$ }
#let longleftrightarrow = { $arrow.l.r.long$ }
#let Longleftrightarrow = { $arrow.l.r.double.long$ }
#let iff = { $thin thin arrow.l.r.double.long thin thin$ }
#let longmapsto = { $arrow.r.long.bar$ }
#let hookrightarrow = { $arrow.r.hook$ }
#let rightharpoonup = { $harpoon.rt$ }
#let rightharpoondown = { $harpoon.rb$ }
#let rightcurvedarrow = { $⤳$ }
#let leadsto = { $⤳$ }
#let uparrow = { $arrow.t$ }
#let Uparrow = { $arrow.t.double$ }
#let downarrow = { $arrow.b$ }
#let Downarrow = { $arrow.b.double$ }
#let updownarrow = { $arrow.t.b$ }
#let Updownarrow = { $arrow.t.b.double$ }
#let nearrow = { $arrow.tr$ }
#let searrow = { $arrow.br$ }
#let swarrow = { $arrow.bl$ }
#let nwarrow = { $arrow.tl$ }
#let longrightsquigarrow = { $arrow.r.long.squiggly$ }

// Miscellaneous Symbols
#let ldots = { $dots.h$ }
#let aleph = { $א$ }
#let hbar = { $ℏ$ }
#let wp = { $℘$ }
#let mho = { $℧$ }
#let cdots = { $dots.h.c$ }
#let emptyset = { $nothing$ }
#let surd = { $\u{8730}$ }
#let neg = { $not$ }
#let ddots = { $dots.down$ }
#let infty = { $infinity$ }
#let Box = { $square.stroked$ }
#let Diamond = { $diamond.stroked$ }
#let Triangle = { $triangle.stroked.t$ } 
#let clubsuit = { $suit.club$ }
#let diamondsuit = { $♢$ }
#let heartsuit = { $♡$ }
#let spadesuit = { $suit.spade$ }
#let varclubsuit = { $♧$ }
#let vardiamondsuit = { $suit.diamond$ }
#let varheartsuit = { $suit.heart$ }
#let varspadesuit = { $♤$ }

// Variable-sized Symbols
#let prod = { $product$ }
#let coprod = { $product.co$ }
#let int = { $integral$ }
#let oint = { $integral.cont$ }
#let Join = { $⨝$ }
#let bigcap = { $inter.big$ }
#let bigcup = { $union.big$ }
#let bigsqcup = { $union.sq.big$ }
#let bigvee = { $or.big$ }
#let bigwedge = { $and.big$ }
#let bigodot = { $dot.o.big$ }
#let bigotimes = { $times.o.big$ }
#let bigoplus = { $plus.o.big$ }
#let biguplus = { $union.plus.big$ }

// Log-like Symbols
#let operatorname(input) = { $op(#input)$ }
// arccos is predefined
#let arccot = { $operatorname("arccot")$ }
#let arccsc = { $operatorname("arccsc")$ }
#let arcosh = { $operatorname("arcosh")$ }
#let arcoth = { $operatorname("arcoth")$ }
#let arcsch = { $operatorname("arcsch")$ }
#let arcsec = { $operatorname("arcsec")$ }
// arcsin is predefined
// arctan is predefined
// arg is predefined
#let arsech = { $operatorname("arsech")$ }
#let arsinh = { $operatorname("arsinh")$ }
#let artanh = { $operatorname("artanh")$ }
// cos is predefined
// cosh is predefined
// cot is predefined
// coth is predefined
// ctg is predfined
// csc is predefined
#let csch = { $operatorname("csch")$ }
// deg is predefined
// det is predefined
// dim is predefined
// exp is predefined
// gcd is predefined
// hom is predefined
// #let Im = {$operatorname("Im")$} // uncomment this to redefine the imaginary part command from the default "ℑ" to "Im"
// inf is predefined
// ker is predefined
#let lcm = { $operatorname("lcm")$ }
// lg is predefined
// lim is predefined
// liminf is predefined
// limsup is predefined
// ln is predefined
// log is predefined
// max is predefined
// min is predefined
// mod is predefined
// Pr is predefined
// #let Re = {$operatorname("Re")$} // uncomment this to redefine the real part command from the default "ℜ" to "Re"
// sec is predefined
#let sech = { $operatorname("sech")$ }
// sin is predefined
// sinh is predefined
// sup is predefined
// tan is predefined
// tanh is predefined
// tg is predefined

// Delimiters
#let lfloor = { $⌊$ }
#let rfloor = { $⌋$ }
#let langle = { $⟨$ }
#let rangle = { $⟩$ }
#let vert = { $|$ }
#let Vert = { $‖$ }
#let lceil = { $⌈$ }
#let rceil = { $⌉$ }

// Math Mode Accents
#let check(input) = { $accent(#input, caron)$ }
#let Vec(input) = { $accent(#input, arrow)$ }
#let ddot(input) = { $accent(#input, dot.double)$ }

// Some other constructions
#let widetilde(input) = { $accent(#input, tilde)$ }
#let overleftarrow(input) = { $accent(#input, arrow.l)$ }
#let widehat(input) = { $accent(#input, hat)$ }
#let overrightarrow(input) = { $accent(#input, arrow.r)$ }
// Typst's  root(n, x) = LaTeX's \sqrt[n]{x} 
// Typst's \frac(a, b) = LaTeX's \frac{a}{b}

// AMS Delimiters
#let ulcorner = { $⌜$ }
#let urcorner = { $⌝$ }
#let llcorner = { $⌞$ }
#let lrcorner = { $⌟$ }

// AMS Arrows
#let dashrightarrow = { $arrow.r.dashed$ }
#let rightdasharrow = { $arrow.r.dashed$ }
#let Lleftarrow = { $arrow.l.quad$ }
#let leftrightharpoons = { $harpoons.ltrb$ }
#let upuparrows = { $arrows.tt$ }
#let leftrightsquigarrow = { $↭$ }
#let rightleftarrows = { $arrows.rl$ }
#let downdownarrows = { $arrows.bb$ }
#let dashleftarrow = { $arrow.l.dashed$ }
#let leftdasharrow = { $arrow.l.dashed$ }
#let twoheadleftarrow = { $arrow.l.twohead$ }
#let curvearrowleft = { $arrow.ccw.half$ }
#let upharpoonleft = { $harpoon.tl$ }
#let rightrightarrows = { $arrows.rr$ }
#let twoheadrightarrow = { $arrow.r.twohead$ }
#let curvearrowright = { $arrow.cw.half$ }
#let upharpoonright = { $harpoon.tr$ }
#let leftleftarrows = { $arrows.ll$ }
#let leftarrowtail = { $arrow.l.tail$ }
#let circlearrowleft = { $arrow.ccw$ }
#let downharpoonleft = { $harpoon.bl$ }
#let rightarrowtail = { $arrow.r.tail$ }
#let circlearrowright = { $arrow.cw$ }
#let downharpoonright = { $harpoon.br$ }
#let leftrightarrows = { $arrows.lr$ }
#let looparrowleft = { $arrow.l.loop$ }
#let Lsh = { $↰$ }
#let rightrightarrows = { $arrows.rr$ }
#let looparrowright = { $arrow.r.loop$ }
#let Rsh = { $↱$ }
#let rightsquigarrow = { $arrow.r.squiggly$ }

// AMS Negated Arrows
#let nleftarrow = { $arrow.l.not$ }
#let nleftrightarrow = { $arrow.l.r.not$ }
#let nrightarrow = { $arrow.r.not$ }
#let nLeftrightarrow = { $arrow.l.r.double.not$ }
#let nLeftarrow = { $arrow.l.double.not$ }
#let nRightarrow = { $arrow.r.double.not$ }

// AMS Greek
#let digamma = { $ϝ$ }
#let updigamma = { $ϝ$ }
#let Digamma = { $Ϝ$ }
#let upDigamma = { $Ϝ$ }
#let varkappa = { $ϰ$ }
#let upvarkappa = { $kappa.alt$ }

// AMS Miscellaneous
#let Square = { $square.stroked$ }
#let measureadangle = { $angle.arc$ }
#let Game = { $⅁$ }
#let blacktriangle = { $triangle.filled.small.t$ }
#let bigstar = { $★$ }
#let diagup = { $∕$ }
#let hslash = { $ℏ$ }
#let lozenge = { $lozenge.stroked$ }
#let nexists = { $exists.not$ }
#let Bbbk = { $𝕜$ }
#let blacktriangledown = { $triangle.filled.small.b$ }
#let sphericalangle = { $angle.spheric$ }
#let diagdown = { $⧵$ }
#let vartriangle = { $triangle.stroked.small.t$ }
#let circledS = { $Ⓢ$ }
#let backprime = { $‵$ }
#let blacksquare = { $square.filled$ }
#let triangledown = { $triangle.stroked.small.b$ }
#let Finv = { $Ⅎ$ }
#let varnothing = { $⌀$ }
#let diameter = { $⌀$ }
#let blacklozenge = { $⧫$ }
#let eth = { $ð$ }
#let matheth = { $ð$ }

// AMS Binary Operators
#let dotplus = { $plus.dot$ }
#let barwedge = { $⊼$ }
#let boxtimes = { $times.square$ }
#let ltimes = { $⋉$ }
#let curlywedge = { $and.curly$ }
#let circledcirc = { $compose.o$ }
#let smallsetminus = { $∖$ }
#let veebar = { $⊻$ }
#let boxdot = { $dot.square$ }
#let rtimes = { $⋊$ }
#let curlyvee = { $or.curly$ }
#let centerdot = { $dot.c$ }
#let Cap = { $inter.double$ }
#let doublebarwedge = { $⩞$ }
#let boxplus = { $plus.square$ }
#let leftthreetimes = { $times.l$ }
#let circleddash = { $dash.o$ }
#let intercal = { $⊺$ }
#let Cup = { $union.double$ }
#let boxminus = { $minus.square$ }
#let divideontimes = { $times.div$ }
#let rightthreetimes = { $times.r$ }
#let circledast = { $convolve.o$ }

// AMS Binary Relations
#let leqq = { $lt.equiv$ }
#let lessapprox = { $⪅$ }
#let lessgtr = { $lt.gt$ }
#let risingdotseq = { $≓$ }
#let subseteqq = { $⫅$ }
#let curlyeqprec = { $eq.prec$ }
#let trianglelefteq = { $⊴$ }
#let unlhd = { $⊴$ }
#let smallfrown = { $⏜$ }
#let geqslant = { $⩾$ }
#let gtrdot = { $gt.dot$ }
#let gtreqqless = { $⪌$ }
#let thicksim = { $sim$ }
#let sqsupset = { $supset.sq$ }
#let succaprox = { $succ.approx$ }
#let shortmid = { $thin thin thin thin ⃓ thin$ }
#let varpropto = { $propto$ }
#let blacktriangleright = { $triangle.filled.r$ }
#let leqslant = { $⩽$ }
#let approxeq = { $approx.eq$ }
#let lesseqgtr = { $lt.eq.gt$ }
#let fallingdotseq = { $≒$ }
#let Subset = { $subset.double$ }
#let precsim = { $prec.tilde$ }
#let vDash = { $⊨$ }
#let bumpeq = { $≏$ }
#let eqslantgtr = { $⪖$ }
#let ggg = { $gt.triple$ }
#let eqcirc = { $≖$ }
#let thickapprox = { $approx$ }
#let succcurlyeq = { $succ.eq$ }
#let vartriangleright = { $⊳$ }
#let rhd = { $⊳$ }
#let shortparallel = { $thin thin thin ⃓ thin ⃓$ }
#let blacktriangleleft = { $triangle.filled.l$ }
#let eqslantless = { $⪕$ }
#let lessdot = { $lt.dot$ }
#let lesseqqgtr = { $⪋$ }
#let backsim = { $tilde.rev$ }
#let sqsubset = { $subset.sq$ }
#let precapprox = { $prec.approx$ }
#let Vvdash = { $⊪$ }
#let Bumpeq = { $≎$ }
#let gtrsim = { $gt.tilde$ }
#let gtrless = { $gt.lt$ }
#let circeq = { $≗$ }
#let supseteqq = { $⫆$ }
#let curlysucceq = { $eq.succ$ }
#let trianglerighteq = { $⊵$ } 
#let unrhd = { $⊵$ }
#let between = { $≬$ }
#let lesssim = { $lt.tilde$ }
#let lll = { $lt.triple$ }
#let doteqdot = { $≑$ }
#let Doteq = { $≑$ }
#let backsimeq = { $tilde.eq.rev$ }
#let preccurlyeq = { $prec.eq$ }
#let vartriangleleft = { $⊲$ }
#let lhd = { $⊲$ }
#let smallsmile = { $⏝$ }
#let geqq = { $gt.equiv$ }
#let gtrapprox = { $gt.approx$ }
#let gtreqless = { $gt.eq.lt$ }
#let triangleq = { $eq.delta$ }
#let Supset = { $supset.double$ }
#let succsim = { $succ.tilde$ }
#let Vdash = { $⊩$ }
#let pitchfork = { $⋔$ }
#let backepsilon = { $϶$ }
#let upbackepsilon = { $϶$ }

// AMS Negated Binary Relations
#let nless = { $lt.not$ }
#let nleq = { $lt.eq.not$ }
#let lnapprox = { $⪉$ }
#let precnapprox = { $prec.napprox$ }
#let nvdash = { $⊬$ }
#let nsubseteq = { $subset.eq.not$ }
#let nsubseteqq = { $#h(5pt) slash #h(-7pt)⫅$ }
#let varsubsetneqq = { $⫋$ }
#let ngeqq = { $#h(5pt) slash #h(-7pt) gt.equiv$ }
#let gnsim = { $gt.ntilde$ }
#let nsucceq = { $succ.eq.not$ }
#let nshortparallel = { $thin thin thin #h(0.75pt) ̷#h(-0.75pt) ⃓ thin ⃓$ }
#let ntriangleright = { $⋫$ }
#let nvartriangleright = { $⋫$ }
#let supsetneq = { $supset.neq$ }
#let nleq = { $lt.eq.not$ }
#let nprec = { $prec.not$ }
#let nsim = { $tilde.not$ }
#let nvDash = { $⊭$ }
#let subsetneq = { $subset.neq$ }
#let ngtr = { $gt.not$ }
#let gneq = { $⪈$ }
#let gnapprox = { $⪊$ }
#let succnsim = { $succ.ntilde$ }
#let nparallel = { $parallel.not$ }
#let ntrianglerighteq = { $⋭$ }
#let varsupsetneq = { $supset.eq_(#h(-4pt) ̷)$ }
#let nleqslant = { $#h(5pt) slash #h(-7pt) ⩽$ }
#let npreceq = { $#h(4.75pt) slash #h(-7.25pt) ⪯$ }
#let notshortmid = { $thin thin thin thin #h(-0.25pt) ̷ #h(0.25pt) ⃓ thin$ }
#let ntriangleleft = { $⋪$ }
#let nvartriangleleft = { $⋪$ }
#let varsubsetneq = { $subset.eq_(#h(-4pt) ̷)$ }
#let ngeq = { $gt.eq.not$ }
#let nsucc = { $succ.not$ }
#let succnapprox = { $succ.napprox$ }
#let nvDash = { $⊭$ }
#let nsupseteq = { $supset.eq.not$ }
#let supsetneqq = { $⫌$ }
#let lnsim = { $lt.ntilde$ }
#let precnsim = { $prec.ntilde$ }
#let nmid = { $divides.not$ }
#let ntrianglelefteq = { $⋬$ }
#let subsetneqq = { $⫋$ }
#let ngeqslant = { $#h(5pt) slash #h(-7pt)⩾$ }
#let gvertneqq = { $gt.equiv_(#h(-8.2pt)｜)$ }
#let nVDash = { $⊯$ }
#let nsupseteqq = { $#h(5pt) slash #h(-7pt)⫆$ }
#let varsupsetneqq = { $⫌$ }

// Selected stmaryrd Delimiters (that are available in the NewComputerModern Math font)
#let Lbag = { $⟅$ }
#let Rbag = { $⟆$ }
#let lbag = { $⟅$ }
#let rbag = { $⟆$ }
#let llceil = { $⌈ #h(-3.5pt) ⌈ #h(-1.125pt)$ }
#let lCeil = { $⌈ #h(-3.5pt) ⌈ #h(-1.125pt)$ }
#let rrceil = { $#h(-1.125pt) ⌉ #h(-3.5pt) ⌉$ }
#let rCeil = { $#h(-1.125pt) ⌉ #h(-3.5pt) ⌉$ }
#let llfloor = { $⌊ #h(-3.5pt) ⌊ #h(-1.125pt)$ }
#let lFloor = { $⌊ #h(-3.5pt) ⌊ #h(-1.125pt)$ }
#let rrfloor = { $#h(-1.125pt) ⌋ #h(-3.5pt) ⌋$ }
#let rFloor = { $#h(-1.125pt) ⌋ #h(-3.5pt) ⌋$ }
#let llbracket = { $⟦$ }
#let lBrack = { $⟦$ }
#let rrbracket = { $⟧$ }
#let rBrack = { $⟧$ }

// Selected stmaryrd Arrows (that are available in the NewComputerModern Math font)
#let Longmapsfrom = { $arrow.l.double.long.bar$ }
#let nnearrow = { $arrow.tr$ }
#let nearrow = { $arrow.tr$ }
#let longmapsfrom = { $arrow.l.long.bar$ }
#let lightning = { $↯$ }
#let downzigarrow = { $↯$ }
#let Longmapsto = { $arrow.r.double.long.bar$ }
#let nnwarrow = { $arrow.tl$ }
#let nwarrow = { $arrow.tl$ }
#let mapsfrom = { $arrow.l.bar$ }
#let llparenthesis = { $⦇$ }
#let rrparenthesis = { $⦈$ }
#let Mapsfrom = { $arrow.l.double.bar$ }
#let ssearrow = { $arrow.br$ }
#let searrow = { $arrow.br$ }
#let leftarrowtriangle = { $⇽$ }
#let Mapsto = { $arrow.r.double.bar$ }
#let swarrow = { $arrow.bl$ }
#let swarrow = { $arrow.bl$ }
#let rightarrowtriangle = { $⇾$ }
#let leftrightarrowtriangle = { $⇿$ }

// Selected stmaryrd Binary Operators (that are available in the NewComputerModern Math font)
#let boxcircle = { $⧇$ }
#let varogreaterthan = { $gt.o$ }
#let ogreaterthan = { $gt.o$ }
#let ogtr = { $gt.o$ }
#let varcurlyvee = { $or.curly$ }
#let varobslash = { $backslash.o$ }
#let obslash = { $backslash.o$ }
#let varolessthan = { $lt.o$ }
#let olessthan = { $lt.o$ }
#let oless = { $lt.o$ }
#let varotimes = { $times.o$ }
#let boxbar = { $◫$ }
#let obar = { $⦶$ }
#let varobar = { $⌽$ }
#let varcurlyvee = { $and.curly$ }
#let varocircle = { $compose.o$ }
#let ocircle = { $compose.o$ }
#let varominus = { $minus.o$ }
#let boxbox = { $⧈$ }
#let emptybox = { $square.stroked$ }
#let talloblong = { $⫾$ }
#let varoast = { $convolve.o$ }
#let oast = { $convolve.o$ }
#let varodot = { $dot.o$ }
#let varoplus = { $dot.o$ }
#let Yup = { $⅄$ }
#let boxbslash = { $⧅$ }
#let boxslash = { $⧄$ }
#let boxdiag = { $⧄$ }
#let interleave = { $⫴$ }
#let varbigcirc = { $circle.big$ }
#let varoslash = { $⊘$ }

// Selected stmaryrd Large Binary Operators (that are available in the NewComputerModern Math font)
#let biginterleave = { $⫼$ }
#let bigsqcap = { $inter.sq.big$ }