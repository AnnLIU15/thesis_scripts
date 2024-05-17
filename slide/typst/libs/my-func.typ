#import "@preview/polylux:0.3.1": *
#import "@preview/cetz:0.2.2"

#import logic:*
#import utils:*
#let chinesenumber(num, standalone: false) = if num < 11 {
  ("零", "一", "二", "三", "四", "五", "六", "七", "八", "九", "十").at(num)
} else if num < 100 {
  if calc.rem(num, 10) == 0 {
    chinesenumber(calc.floor(num / 10)) + "十"
  } else if num < 20 and standalone {
    "十" + chinesenumber(calc.rem(num, 10))
  } else {
    chinesenumber(calc.floor(num / 10)) + "十" + chinesenumber(calc.rem(num, 10))
  }
} else if num < 1000 {
  let left = chinesenumber(calc.floor(num / 100)) + "百"
  if calc.rem(num, 100) == 0 {
    left
  } else if calc.rem(num, 100) < 10 {
    left + "零" + chinesenumber(calc.rem(num, 100))
  } else {
    left + chinesenumber(calc.rem(num, 100))
  }
} else {
  let left = chinesenumber(calc.floor(num / 1000)) + "千"
  if calc.rem(num, 1000) == 0 {
    left
  } else if calc.rem(num, 1000) < 10 {
    left + "零" + chinesenumber(calc.rem(num, 1000))
  } else if calc.rem(num, 1000) < 100 {
    left + "零" + chinesenumber(calc.rem(num, 1000))
  } else {
    left + chinesenumber(calc.rem(num, 1000))
  }
}

#let Romannumber(num, standalone: false) = if num == 0 {
  ""
} else if num < 4 {
  "I" + Romannumber(num - 1)
} else if num < 5 {
  "IV" + Romannumber(num - 4)
} else if num < 9 {
  "V" + Romannumber(num - 5)
} else if num < 10 {
  "IX" + Romannumber(num - 9)
} else if num < 40 {
  "X" + Romannumber(num - 10)
} else if num < 50 {
  "XL" + Romannumber(num - 40)
} else if num < 90 {
  "L" + Romannumber(num - 50)
} else if num < 100 {
  "XC" + Romannumber(num - 90)
} else if num < 400 {
  "C" + Romannumber(num - 100)
} else if num < 500 {
  "CD" + Romannumber(num - 400)
} else if num < 900 {
  "D" + Romannumber(num - 500)
} else if num < 1000 {
  "CM" + Romannumber(num - 900)
} else {
  "M" + Romannumber(num - 1000)
} // https://blog.csdn.net/qq_32763643/article/details/104137993

#let to-string(content) = {
  if content.has("text") {
    content.text
  } else if content.has("children") {
    content.children.map(to-string).join("")
  } else if content.has("body") {
    to-string(content.body)
  } else if content == [ ] {
    ""
  }
}

#let citef(lang: "en", cjk-latin-spacing: auto, content) = {
  if type(content) == "content" {
    footnote()[#text(
        lang: lang,
        cjk-latin-spacing: cjk-latin-spacing,
        cite(content, form: "full"),
      )]
  } else if type(content) == "string" {
    footnote()[#text(
        lang: lang,
        cjk-latin-spacing: cjk-latin-spacing,
        cite(label(content), form: "full"),
      )]
  } else if type(content) == "label" {
    footnote()[#text(
        lang: lang,
        cjk-latin-spacing: cjk-latin-spacing,
        cite(content, form: "full"),
      )]
  }
}

#let citez(content) = {
  if type(content) == "array" {
    for val in content{
      citez(val)
      if val != content.last() {
        super[,~]
      }
    }
  } else {
    citef(lang: "zh", cjk-latin-spacing: auto, content)
  }
}

#let citee(content) = {
  if type(content) == "array" {
    for val in content{
      citee(val)
      if val != content.last() {
        super[,~]
      }
    }
  } else {
    citef(lang: "en", cjk-latin-spacing: none, content)
  }
}

#let polylux-outline-my(enum-args: (:), padding: 0pt) = locate(loc => {
  let sections = sections-state.final(loc)
  set text(size: 30pt)
  pad(padding, enum(
    tight: false,
    spacing: 80% / sections.len(),
    ..enum-args,
    ..sections.map(section => link(section.loc, section.body)),
  ))
})

#let drawMarkedCircles(offset, width: 1.5) = {
    import cetz.draw: *
    let A = (offset - width, width);
    let B = (offset + width, width);
    let C = (offset, -width / calc.sqrt(2));
    
    // 绘制中心圆，不设置边框
    let center = (offset, width)
    circle(center, radius: calc.tan(10deg)*(width / calc.sqrt(2)/2), name: "center", stroke: none)
    
    // 绘制包含三个圆的矩形框
    rect((offset - width - 1, width + 1), (offset + 1 + width, -1 - width / calc.sqrt(2)), )
    // set-style(
    //   content: (padding: .2),
    //   fill: gray.lighten(70%),
    //   stroke: gray.lighten(100%),
    // )
    // 绘制标记A的圆
    circle(A, radius: 0.5, name: "A", fill: blue.lighten(70%))
    content(A, [A]) // 在圆A内添加标记A
    
    // 绘制标记B的圆
    circle(B, radius: 0.5, name: "B", fill: blue.lighten(70%))
    content(B, [B]) // 在圆B内添加标记B
    
    // 绘制标记C的圆
    circle(C, radius: 0.5, name: "C", fill: blue.lighten(70%))
    content(C, [C]) // 在圆C内添加标记C
}