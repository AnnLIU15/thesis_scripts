#import "@preview/polylux:0.3.1": *
#import "libs/university.typ": *
#import "libs/LaTeX-math-expressions-in-Typst.typ": *
#import "@preview/physica:0.9.3": *

#import "@preview/cetz:0.2.2": canvas, plot, draw, tree
#import "@preview/cetz:0.2.2"

#let color-b = rgb("#0C6291")
#let color-r = rgb("#A63446")
#let color-g = rgb("#00561F")
#let color-g1 = rgb("#A9D18E")
#let color-g2 = rgb("#C5E0B4")

#show: university-theme.with(
  aspect-ratio: "4-3", // or "16-9"
  authors: ("你好",),
  emails: ("xxxxx@mail2.sysu.edu.cn",),
  institutions: ("中山大学",),
  title: [xxxxxxxxx],
  date: datetime(year: 2024, month: 05, day: 24), //datetime.today(),
  logo: image("imgs/logo/校徽+字.svg", height: 20mm),
  inv-logo: image("imgs/logo/校徽+字-00561F.svg", height: 20mm),
  color-a: color-b,
  color-b: color-r,
  color-c: color-g,
  color-c1: color-g1,
  color-c2: color-g2,
  init-section: false,
  ref: "ref/references.bib",
  cls: "ref/ieee_my.csl",
  progress-barline_flag: false,
  // lang: "English", // default: Chinese
)

#title-slide()
// #content-slide()
#new-section-slide([离线强化学习简介])
#slide(
  title: [强化学习],
)[
  序贯决策任务是机器学习领域的一种任务#citez("zhang2022")

  - 序贯决策和人生选择很相似 $-->$ 会有"后果"，需要为未来负责

  - 强化学习 (Reinforcement Learning, RL) 是机器通过与环境交互来实现目标的一种计算方法

  // - 机器和环境的一轮交互是指，机器在环境的一个状态下做一个动作决策，把这个动作作用到环境当中，这个环境发生相应的改变并且将相应的奖励反馈和下一轮状态传回机器
  #grid(
    columns: (auto, auto),
    rows: (auto),
    column-gutter: 4.5%,
    align(left + horizon)[
      #figure(image("imgs/s1/RL.png", width: auto))
    ],
    [*马尔可夫决策过程 (Markov Decision Process, MDP)* #citee("prudencio2023survey"): $(cal(S), cal(A), cal(P), R, gamma)$

      #list(
        [$cal(S)$ -- 状态空间],
        [$cal(A)$ -- 动作空间],
        [$cal(P): cal(S) times cal(A) times cal(S) -> [0, 1]$ -- 转移概率],
        [$R: cal(S) times cal(A) -> bb(R) $ -- 奖励函数],
        [$gamma in [0, 1]$ -- 折扣因子 (折扣MDP)],
      )],
  )
  #v(-20%)
]



#slide(title: [Why Offline RL?])[
  Offline RL -- 使用预先收集的、固定的数据集来训练Agent，而不是通过与环境的实时交互来收集数据

  - 智能体无法与环境在线交互 (数据收集成本高昂或危险)#list(
      [机器人#citee("singh2022reinforcement")],
      [教育#citee("singla2021reinforcement")],
      [医疗#citee("liu2020reinforcement")],
      [自动驾驶#citee("kiran2021deep")],
      [etc.],
    )

  #place(
    top + right,
    dx: -2em,
    dy: 5em,
    image("imgs/s1/pilot-fail.jpg", height: 45%),
  )

]

#slide(
  title: [Decision Diffuser -- 轨迹拼接],
)[
#canvas(length: 1cm, {
  import draw: *
  let width = 1.5
// 调用函数并传入一个具体的offset值，例如0
  drawMarkedCircles(0)
  line("A.east", "center.west", "C.100deg",
   mark: (end: ">",), stroke: blue+1.5pt) // 从点A画一条线到点B     
   drawMarkedCircles(width * 4)
  // 如果需要，可以使用line函数连接这些点，以展示它们之间的相对位置
  line("C.80deg", "center.east", "B.west",
   mark: (end: ">",), stroke: blue+1.5pt) // 从点A画一条线到点B
  drawMarkedCircles(width * 9)
  let info = (-3* width, 0)
  content(info, [Go to C]) // 在圆A内添加标记A
  let info = (width * 2, -width / calc.sqrt(2) - 2)
  content(info, [Imitation Learning]) // 在圆A内添加标记A
  let info = (width * 9, -width / calc.sqrt(2) - 2)
  content(info, [#strong("Suboptimal")]) // 在圆A内添加标记A
  line("A.east", "center.west", "C.100deg",
   mark: (end: ">",), stroke: blue+1.5pt) // 从点A画一条线到点B     
   line("C.80deg", "center.east", "B.west",
   mark: (end: ">",), stroke: blue+1.5pt) // 从点A画一条线到点B
})

#canvas(length: 1cm, {
  import draw: *
  let width = 1.5
// 调用函数并传入一个具体的offset值，例如0
  drawMarkedCircles(0)
  line("A.east", "center.west", "C.100deg",
   mark: (end: ">",), stroke: blue+1.5pt) // 从点A画一条线到点B     
   drawMarkedCircles(width * 4)
  // 如果需要，可以使用line函数连接这些点，以展示它们之间的相对位置
  line("C.80deg", "center.east", "B.west",
   mark: (end: ">",), stroke: blue+1.5pt) // 从点A画一条线到点B
  drawMarkedCircles(width * 9)
  let info = (-3* width, 0)
  content(info, [Go to C]) // 在圆A内添加标记A
  let info = (width * 2, -width / calc.sqrt(2) - 2)
  content(info, [Learn a Q-function]) // 在圆A内添加标记A
  let info = (width * 9, -width / calc.sqrt(2) - 2)
  content(info, [#strong("Trajectory stitching leads")]) 
  let info = (width * 9, -width / calc.sqrt(2) - 3)
  content(info, [#strong("to optimal path")])
  line("A.east", "center.west", "C.100deg",
   mark: (end: ">",), stroke: blue+1.5pt) // 从点A画一条线到点B     
   line("C.80deg", "center.east", "B.west",
   mark: (end: ">",), stroke: blue+1.5pt) // 从点A画一条线到点B
})

  - 估计 Q 函数不稳定#citee("kumar2020conservative") $->$ 是否能避开 QL /值估计做轨迹拼接？
  #v(-10%)
]

#focus-slide()[
  *谢谢! Q&A* //
]