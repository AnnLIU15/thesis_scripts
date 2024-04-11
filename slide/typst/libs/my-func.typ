#import "@preview/polylux:0.3.1": *

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

#let polylux-outline-my(enum-args: (:), padding: 0pt) = locate(loc => {
  let sections = sections-state.final(loc)
  
  pad(padding, enum(
    tight: false,
    spacing: 80% / sections.len(),
    ..enum-args,
    ..sections.map(section => link(section.loc, section.body)),
  ))
})
