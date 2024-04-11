#import "@preview/polylux:0.3.1": *
#import "libs/university.typ": *

#let color-b = rgb("#0C6291")
#let color-r = rgb("#A63446")
#let color-w = rgb("#FBFEF9")

#show: university-theme.with(
  aspect-ratio: "4-3",
  authors: ("xxx",),
  emails: ("xxxxx@mail2.sysu.edu.cn",),
  institutions: ("中山大学",),
  title: [xxxxxxxx],
  date: datetime.today(),
  logo: image("imgs/logo/校徽.svg", height: 30mm),
  inv-logo: image("imgs/logo/校徽-A63446.svg", height: 30mm),
  color-a: color-b,
  color-b: color-r,
  color-c: color-w,
  init-section: false,
  // lang: "English", // default: Chinese
)
#title-slide()
// #content-slide()
#new-section-slide([文献收集])
#slide(title: [关键字搜索: Google Scholar])[

  网页地址: #underline([https://scholar.google.com/]) (需要梯子)

  // #align(center + horizon)[
  //   #figure(image("imgs/s1/scholar.jpg", width: 100%)) <Vehicles>
  // ]

  关键字搜索
  #v(-1%)
  // #align(center + horizon)[
  //   #figure(image("imgs/s1/scholar-search.jpg", width: 75%)) <Vehicles>
  // ]
  #uncover("2-")[#place(
      top + left,
      dx: -2%,
      dy: 10%,
    )[#rect(width: 6%, stroke: 2pt + red, height: 4%)]]
]


#focus-slide()[
  *谢谢 !* // Q&A*
]