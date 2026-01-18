#import "@preview/touying:0.6.1": *
#import "libs/university-touying.typ": *
#import "libs/LaTeX-math-expressions-in-Typst.typ": *
#import "@preview/physica:0.9.3": *

#import "@preview/cetz:0.4.2"

#let color-b = rgb("#0C6291")
#let color-r = rgb("#A63446")
#let color-g = rgb("#00561F")
#let color-g1 = rgb("#A9D18E")
#let color-g2 = rgb("#C5E0B4")

#show: university-theme.with(
  aspect-ratio: "16-9",
  config-info(
    title: [低秩微调概述],
    author: "XXXX",
    institution: "XXXX",
    date: datetime.today(),
    logo: image("imgs/logo/校徽+字.svg", height: 20mm),
    inv-logo: image("imgs/logo/校徽+字-00561F.svg", height: 20mm),

  ),
//   config-common(show-bibliography-as-footnote: bibliography("./ref/references.bib",
// )),
  dy-title: 32%,
  emails: "XXXXX@mail2.sysu.edu.cn",
  colors-config: (
    primary: color-r,
    secondary: color-b,
    tertiary: color-g,
  ),
  color-c1: color-g1,
  color-c2: color-g2,
  init-section: false,
  ref: "ref/references.bib",
  cls: "ref/ieee_my.csl",
  progress-barline_flag: true,
  // lang: "English", // default: Chinese
)

#title-slide()

#new-section-slide([背景])
#slide(
  title: [基座模型],
  header-percent: 73%,
)[

  目前，主流的方式是在开源基座模型 (Foundation model) 的基础上微调，实现高效训练

  - 基座模型
    - Llama-3.1 (8B, BF16)#footnote("https://huggingface.co/meta-llama/Llama-3.1-8B")
    - GLM-4 (9B, BF16)#footnote("https://huggingface.co/THUDM/glm-4-9b-chat")
    - T5 (2.85B, FP32)#footnote("https://huggingface.co/google-t5/t5-3b")
    - Stable Video Diffusion (3B, FP32)#footnote("https://huggingface.co/stabilityai/stable-video-diffusion-img2vid-xt")
    #uncover("2-")[
      #place(top, dx: 380pt, dy: -50pt, [
        #image("imgs/logo/校徽+字.svg")
      ])
      #place(top, dx: -10pt, dy: -22pt, [
    #cetz-canvas({
      import cetz.draw: rect, content,merge-path,bezier, line
      // Your drawing code goes here
      rect((0, 0), (9, 1.2), name: "kz-rect", stroke: 2pt + color-r)
      content((10, 2.5), auto, text(fill: color-r, [*需要*]), name: "content2")
    })
  ])

    ]
]



#new-section-slide([总结与展望])

#slide(title: [总结], right-s: 1em)[

  - 只要大模型的范式没有被取代，LoRA还有搞头

  - Idea

]


#focus-slide()[
  *谢谢! Q&A* //
]