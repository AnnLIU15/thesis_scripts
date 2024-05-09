// #import "@preview/polylux:0.3.1": *

// #import logic:*
// #import utils:*
#import "my-func.typ": *
// University theme
//
// Originally contributed by Pol Dellaiera - https://github.com/drupol
//
// Please feel free to improve this theme
// by submitting a PR in https://github.com/andreasKroepelin/typst-slides

#let uni-colors = state("uni-colors", (:))
#let uni-title = state("uni-title", none)
#let uni-authors = state("uni-authors", (:))
#let uni-emails = state("uni-emails", (:))
#let uni-institutions = state("uni-institutions", (:))
#let uni-short-date = state("uni-short-date", none)
#let uni-progress-bar = state("uni-progress-bar", true)
#let uni-logo = state("uni-logo", none)
#let uni-inv-logo = state("uni-inv-logo", none)
#let uni-institution = state("uni-institution", none)
#let uni-lang = state("uni-lang", none)

#let university-theme(
  aspect-ratio: "16-9",
  title: none,
  authors: ("author"),
  emails: ("email"),
  institutions: ("institution"),
  date: none,
  color-a: rgb("#0C6291"),
  color-b: rgb("#A63446"),
  color-c: rgb("#FBFEF9"),
  progress-bar: true,
  logo: none,
  inv-logo: none,
  lang: "Chinese",
  init-section: true,
  ref: none,
  cls: none,
  body,
) = {
  set page(
    paper: "presentation-" + aspect-ratio,
    margin: 0em,
    header: none,
    footer: none,
  )
  // set text(size: 25pt)
  set text(
    lang: "zh",
    font: ("Linux Libertine", "Source Han Sans SC"), // , "Source Han Serif SC" // Static Language Specific OTCs!!!
    size: 25pt,
    overhang: true,
    cjk-latin-spacing: auto,
  )
  show footnote.entry: set text(size: .6em)
  if ref != none {
    show bibliography: none
    if cls != none {
      bibliography(
        "../" + ref,
        title: none,
        style: if cls != none { "../" + cls } else { "ieee" },
        full: false,
      )
    }
  }

  // show math.equation: set text(font: "latinmodern-math")
  uni-progress-bar.update(progress-bar)
  uni-colors.update((a: color-a, b: color-b, c: color-c))
  uni-title.update(title)
  uni-authors.update(authors)
  uni-emails.update(emails)
  uni-institutions.update(institutions)
  if lang == "Chinese" {
    uni-short-date.update(date.display("[year]-[month repr:numerical]-[day]"))
  } else {
    uni-short-date.update(date.display("[month repr:short] [day], [year]"))
  }
  uni-logo.update(logo)
  uni-inv-logo.update(inv-logo)
  uni-lang.update(lang)
  if init-section {
    if lang == "Chinese" {
      utils.register-section([背景])
    } else {
      utils.register-section([Background])
    }
  }
  body
}

#let title-slide(institution-name: "University") = {
  let content = locate(
    loc => {
      let colors = uni-colors.at(loc)
      let logo = uni-logo.at(loc)
      let title = uni-title.at(loc)
      let authors = uni-authors.at(loc)
      let emails = uni-emails.at(loc)
      let institutions = uni-institutions.at(loc)
      let date = uni-short-date.at(loc)
      if logo != none {
        // pad(x: 0.5em, y: 0.5em, align(right, logo))
        place(top + right, dx: -0.5em, dy: 0.5em, logo)
        // place(
        //   top + right,dy:0.5em,
        //   locate(loc => [
        //   #loc.position()
        // ])
        // )
      }
      place(
        top + center,
        dy: 20%,
        text(size: 2.4em, fill: colors.a, strong(title)),
      )
      // align(center + horizon, {
      //   block(inset: 0em, breakable: false, {
      //     text(size: 2em, fill: colors.a, strong(title))
      //   })
      // })
      align(center + bottom, {
        set text(size: 1em)
        if type(authors) == "array" {
          grid(
            columns: (1fr,) * calc.min(authors.len(), 3),
            column-gutter: 1em,
            row-gutter: 1em,
            // authors,
            ..authors.map(author => text(fill: black, author)),
            ..emails.map(email => text(fill: black, email)),
            ..institutions.map(institution => text(fill: black, institution)),
          )
        } else {
          grid(
            column-gutter: 1em,
            row-gutter: 1em,
            // authors,
            authors,
            emails,
            institutions,
          )
        }
        v(2em)
        if date != none {
          parbreak()
          text(size: 1em, date)
        }
        v(5%)
      })
    },
  )
  content
  // logic.polylux-slide(content) // 注释掉不统计页数
}

#let new-section-slide(footer: none, name) = {
  let progress-barline = locate(
    loc => {
      if uni-progress-bar.at(loc) {
        let cell = block.with(width: 100%, height: 100%, above: 0pt, below: 0pt, breakable: false)
        let colors = uni-colors.at(loc)

        utils.polylux-progress(ratio => {
          grid(
            rows: 2pt,
            columns: (ratio * 100%, 1fr),
            cell(fill: colors.b),
            cell(fill: colors.a),
          )
        })
      } else { [] }
    },
  )
  let header = {
    set align(top)
    counter(footnote).update(0) // 重置footnote的序号
    grid(rows: (auto, auto), row-gutter: 3mm, progress-barline)
  }

  let content = locate(loc => {
    let color = uni-colors.at(loc)
    let sections = sections-state.at(loc)
    let sections_num = sections.len() + 1
    // let color_grad = gradient.linear(color.a, color.b).sharp(2)
    set align(center + horizon)
    show: block.with(stroke: (bottom: 1mm + color.a), inset: 1em)
    set text(size: 1.5em)
    v(-10%)
    utils.register-section(name)
    strong([#text(fill: color.a)[#sections_num.]#h(4%)#name])
  })
  let footer = {
    set text(size: 10pt)
    set align(center + bottom)
    let cell(fill: none, it) = rect(
      width: 100%,
      height: 100%,
      inset: 1mm,
      outset: 0mm,
      fill: fill,
      stroke: none,
      align(horizon, text(fill: white, it)),
    )
    if footer != none {
      footer
    } else {
      locate(loc => {
        let colors = uni-colors.at(loc)
        let authors = uni-authors.at(loc)
        let sections = sections-state.at(loc)
        let lang = uni-lang.at(loc)
        // pad(padding, enum(tight: false, spacing: 80%/sections.len(),))
        let authors_str = ""
        for val in authors{
          if val == authors.last() {
            authors_str = authors_str + val
          } else {
            authors_str = authors_str + val + h(5%)
          }
        }
        show: block.with(width: 100%, height: auto, fill: colors.b)
        grid(
          columns: (20%, 1fr, 12%, 8%),
          // columns: (20%, 1fr, 20%),
          rows: (1.5em, auto),
          cell(fill: colors.a, authors_str),
          cell(utils.current-section),
          cell(uni-short-date.display()),
          // cell(""),
          if lang == "Chinese" {
            cell([第#chinesenumber(sections.len())节])
          } else {
            cell([Section~#Romannumber(sections.len())])
          },
        )
      })
    }
  }
  set page(
    margin: (top: 2em, bottom: 1em, x: 0em),
    header: header,
    footer: footer,
    footer-descent: 0em,
    header-ascent: .6em,
  )
  content
  // logic.polylux-slide(content)
}

#let content-slide() = {
  let body = pad(x: 2em, y: .5em, polylux-outline-my(padding: 0%))

  let progress-barline = locate(
    loc => {
      if uni-progress-bar.at(loc) {
        let cell = block.with(width: 100%, height: 100%, above: 0pt, below: 0pt, breakable: false)
        let colors = uni-colors.at(loc)

        utils.polylux-progress(ratio => {
          grid(
            rows: 2pt,
            columns: (ratio * 100%, 1fr),
            cell(fill: colors.b),
            cell(fill: colors.a),
          )
        })
      } else { [] }
    },
  )

  let header-text = {
    locate(
      loc => {
        let colors = uni-colors.at(loc)
        let lang = uni-lang.at(loc)
        let title = if lang == "Chinese" { [目录] } else { [Contents] }
        block(
          fill: colors.c,
          inset: (x: .5em),
          grid(
            columns: (100%,),
            // columns: (100%, 40%),
            align(top + left, heading(level: 1, text(fill: colors.a, title))),
            // align(top + right, text(fill: colors.a.lighten(65%), utils.current-section)),
          ),
        )
      },
    )
  }

  let header = {
    set align(top)
    counter(footnote).update(0)
    grid(rows: (auto, auto), row-gutter: 5mm, progress-barline, header-text)
  }

  let footer = {
    set text(size: 10pt)
    set align(center + bottom)
    let cell(fill: none, it) = rect(
      width: 100%,
      height: 100%,
      inset: 1mm,
      outset: 0mm,
      fill: fill,
      stroke: none,
      align(horizon, text(fill: white, it)),
    )
    locate(loc => {
      let colors = uni-colors.at(loc)
      let authors = uni-authors.at(loc)
      let lang = uni-lang.at(loc)
      let title = uni-title.at(loc)
      let authors_str = ""
      for val in authors{
        if val == authors.last() {
          authors_str = authors_str + val
        } else {
          authors_str = authors_str + val + h(5%)
        }
      }
      show: block.with(width: 100%, height: auto, fill: colors.b)
      grid(
        columns: (20%, 1fr, 12%, 8%),
        // columns: (25%, 1fr, 15%),
        rows: (1.5em, auto),
        cell(fill: colors.a, authors_str),
        if type(title) == str {
          cell(str(title).replace("\n", ""))
        } else {
          cell(to-string(title))
        },
        cell(""),
        // cell(uni-short-date.display()),
        if lang == "Chinese" {
          cell([目录])
        } else {
          cell([Contents])
        },
      )
    })
  }
  set page(
    margin: (top: 2em, bottom: 1em, x: 0em),
    header: header,
    footer: footer,
    footer-descent: 0em,
    header-ascent: .6em,
  )
  align(horizon)[#body]
  // logic.polylux-slide(align(horizon)[#body]) // 注释掉不统计页数
}

#let slide(title: none, header: none, footer: none, header-percent: 70%, body) = {
  let body = pad(x: 2em, y: 1em, body)
  show figure.caption: it => [#it.body] // 去除图xxx
  // set footnote(numbering: "[1]")
  let progress-barline = locate(
    loc => {
      if uni-progress-bar.at(loc) {
        let cell = block.with(width: 100%, height: 100%, above: 0pt, below: 0pt, breakable: false)
        let colors = uni-colors.at(loc)

        utils.polylux-progress(ratio => {
          grid(
            rows: 2pt,
            columns: (ratio * 100%, 1fr),
            cell(fill: colors.b),
            cell(fill: colors.a),
          )
        })
      } else { [] }
    },
  )

  let header-text = {
    if header != none {
      header
    } else if title != none {
      locate(
        loc => {
          let colors = uni-colors.at(loc)
          block(
            fill: colors.c,
            inset: (x: .5em),
            grid(
              columns: (header-percent, 100% - header-percent),
              align(top + left, heading(level: 2, text(fill: colors.a, title))),
              align(top + right, text(fill: colors.a.lighten(65%), utils.current-section)),
            ),
          )
        },
      )
    } else { [] }
  }

  let header = {
    set align(top)
    counter(footnote).update(0)
    grid(rows: (auto, auto), row-gutter: 5mm, progress-barline, header-text)
  }

  let footer = {
    set text(size: 10pt)
    set align(center + bottom)
    let cell(fill: none, it) = rect(
      width: 100%,
      height: 100%,
      inset: 1mm,
      outset: 0mm,
      fill: fill,
      stroke: none,
      align(horizon, text(fill: white, it)),
    )
    if footer != none {
      footer
    } else {
      locate(
        loc => {
          let colors = uni-colors.at(loc)
          let authors = uni-authors.at(loc)
          let authors_str = ""
          for val in authors{
            if val == authors.last() {
              authors_str = authors_str + val
            } else {
              authors_str = authors_str + val + h(5%)
            }
          }
          show: block.with(width: 100%, height: auto, fill: colors.b)
          grid(
            columns: (20%, 1fr, 12%, 8%),
            // columns: (20%, 1fr, 20%),
            rows: (1.5em, auto),
            cell(fill: colors.a, authors_str),
            cell(utils.current-section),
            // cell(""),
            cell(uni-short-date.display()),
            cell([#logic.logical-slide.display()~/~#utils.last-slide-number]),
            // cell(logic.logical-slide.display() + [~/~] + utils.last-slide-number),
          )
        },
      )
    }
  }

  set page(
    margin: (top: 2em, bottom: 1em, x: 0em),
    header: header,
    footer: footer,
    footer-descent: 0em,
    header-ascent: .6em,
  )

  logic.polylux-slide(body)
}

#let focus-slide(background-color: none, background-img: none, body) = {
  let background-color = if background-img == none and background-color == none {
    rgb("#A63446")
  } else {
    background-color
  }

  set page(fill: background-color, margin: 0em) if background-color != none
  set page(background: {
    set image(fit: "stretch", width: 100%, height: 100%)
    background-img
  }, margin: 1em) if background-img != none

  let content = locate(
    loc => {
      let logo = uni-inv-logo.at(loc)
      let title = uni-title.at(loc)
      let authors = uni-authors.at(loc)
      let emails = uni-emails.at(loc)
      let institutions = uni-institutions.at(loc)
      let date = uni-short-date.at(loc)
      let lang = uni-lang.at(loc)
      if logo != none {
        place(top + right, dx: -0.5em, dy: 0.5em, logo)
      }
      set text(fill: white, size: if lang == "Chinese" { 3.5em } else { 2em })
      align(center + horizon, body)
      // logic.polylux-slide(align(center + horizon, body))
      // 注释掉不统计页数
    },
  )
  content
}

#let matrix-slide(
  title: none,
  columns: none,
  rows: none,
  vertical-para: center,
  horizon-para: horizon,
  inset_percent: 20%,
  ..bodies,
) = {
  let bodies = bodies.pos()

  let columns = if type(columns) == "integer" {
    (1fr,) * columns
  } else if columns == none {
    (1fr,) * bodies.len()
  } else {
    columns
  }
  let num-cols = columns.len()
  let rows = if type(rows) == "integer" {
    (1fr,) * rows
  } else if rows == none {
    let quotient = calc.quo(bodies.len(), num-cols)
    let correction = if calc.rem(bodies.len(), num-cols) == 0 { 0 } else { 1 }
    (1fr,) * (quotient + correction)
  } else {
    rows
  }
  let num-rows = rows.len()

  if num-rows * num-cols < bodies.len() {
    panic(
      "number of rows (" + str(num-rows) + ") * number of columns (" + str(num-cols) + ") must at least be number of content arguments (" + str(bodies.len()) + ")",
    )
  }

  let cart-idx(i) = (calc.quo(i, num-cols), calc.rem(i, num-cols))
  let color-body(idx-body) = {
    let (idx, body) = idx-body
    let (row, col) = cart-idx(idx)
    let color = white //if calc.even(row + col) { white } else { silver }
    set align(vertical-para + horizon-para)
    rect(
      inset: inset_percent / num-rows,
      width: auto,
      height: auto,
      fill: color,
      body,
    )
  }

  let progress-barline = locate(
    loc => {
      if uni-progress-bar.at(loc) {
        let cell = block.with(width: 100%, height: 100%, above: 0pt, below: 0pt, breakable: false)
        let colors = uni-colors.at(loc)

        utils.polylux-progress(ratio => {
          grid(
            rows: 2pt,
            columns: (ratio * 100%, 1fr),
            cell(fill: colors.b),
            cell(fill: colors.a),
          )
        })
      } else { [] }
    },
  )

  let header-text = {
    if title != none {
      locate(
        loc => {
          let colors = uni-colors.at(loc)
          block(
            fill: colors.c,
            inset: (x: .5em),
            grid(
              columns: (70%, 30%),
              align(top + left, heading(level: 2, text(fill: colors.a, title))),
              align(top + right, text(fill: colors.a.lighten(65%), utils.current-section)),
            ),
          )
        },
      )
    } else { [] }
  }

  let header = {
    set align(top)
    counter(footnote).update(0)
    grid(rows: (auto, auto), row-gutter: 5mm, progress-barline, header-text)
  }

  let footer = {
    set text(size: 10pt)
    set align(center + bottom)
    let cell(fill: none, it) = rect(
      width: 100%,
      height: 100%,
      inset: 1mm,
      outset: 0mm,
      fill: fill,
      stroke: none,
      align(horizon, text(fill: white, it)),
    )
    locate(
      loc => {
        let colors = uni-colors.at(loc)
        let authors = uni-authors.at(loc)
        let institutions = uni-institutions.at(loc)
        let authors_str = ""

        for (idx, val) in authors.enumerate(){
          if val == authors.last() {
            authors_str = authors_str + val // + [ (#institutions.at(idx))]
          } else {
            authors_str = authors_str + val + h(5%)
          }
        }
        show: block.with(width: 100%, height: auto, fill: colors.b)
        grid(
          columns: (20%, 1fr, 12%, 8%),
          // columns: (20%, 1fr, 20%),
          rows: (1.5em, auto),
          cell(fill: colors.a, authors_str),
          cell(utils.current-section),
          cell(uni-short-date.display()),
          // cell(""),
          cell([#logic.logical-slide.display()~/~#utils.last-slide-number]),
          // cell(logic.logical-slide.display() + [~/~] + utils.last-slide-number),
        )
      },
    )
  }

  let content = grid(
    columns: columns,
    rows: rows,
    gutter: 0pt,
    ..bodies.enumerate().map(color-body),
  )
  set page(
    margin: (top: 2em, bottom: 1em, x: 0em),
    header: header,
    footer: footer,
    footer-descent: 0em,
    header-ascent: .6em,
  )
  logic.polylux-slide(content)
}