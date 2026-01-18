// Touying University Theme with Chinese Support
// 完整移植 Polylux university theme 功能
// Built for Touying 0.6.x API

#import "@preview/touying:0.6.1": *
#import "@preview/cetz:0.4.2"

// Re-export cetz functions for convenience
#let canvas = cetz.canvas
#let draw = cetz.draw

// ============== CeTZ Integration for Touying ==============

// Simple wrapper for cetz canvas that works in Touying context
// Note: For progressive reveal, use touying's uncover/only inside the canvas
#let cetz-canvas = cetz.canvas

// ============== Utility Functions ==============

// Image top-aligned wrapper - fixes baseline alignment issue between text and image
// Usage: #img-top(image("path/to/image.svg", height: 30pt))
// Without this wrapper, images align their bottom with text baseline, causing visual offset
#let img-top(img) = {
  box(place(top, img))
}

// Image positioned at absolute coordinates relative to slide content area
// Accounts for slide margin (top: 1.8em)
// Usage: #place-img(image("path/to/image.svg", height: 50pt), dx: 100pt, dy: 50pt)
#let place-img(img, dx: 0pt, dy: 0pt) = {
  place(top + left, dx: dx, dy: dy, img)
}

// State to track section number (increments for each new-section-slide)
#let section-counter = state("section-counter", 0)

// Convert number to Chinese
#let chinesenumber(num) = {
  let chars = ("零", "一", "二", "三", "四", "五", "六", "七", "八", "九", "十")
  if num < 10 {
    chars.at(num)
  } else if num < 20 {
    if num == 10 { "十" } else { "十" + chars.at(num - 10) }
  } else if num < 100 {
    let tens = int(num / 10)
    let ones = num - tens * 10
    if ones == 0 { chars.at(tens) + "十" } else { chars.at(tens) + "十" + chars.at(ones) }
  } else {
    str(num)
  }
}

// Convert number to Roman
#let Romannumber(num) = {
  let romans = (
    "I", "II", "III", "IV", "V", "VI", "VII", "VIII", "IX", "X",
    "XI", "XII", "XIII", "XIV", "XV", "XVI", "XVII", "XVIII", "XIX", "XX"
  )
  if num <= romans.len() and num > 0 {
    romans.at(num - 1)
  } else {
    str(num)
  }
}

// Custom outline with section numbers
#let polylux-outline-my(padding: 0%) = {
  locate(loc => {
    let sections = query(heading.where(level: 2)).at(loc)
    if sections.len() > 0 {
      enum(
        tight: false,
        spacing: 80% / sections.len(),
        ..sections.enumerate().map(((idx, section)) => {
          let num = chinesenumber(idx + 1)
          [(#num #h(4%)#section)]
        })
      )
    }
  })
}

// ============== Component Functions ==============

// Helper for footer cell
#let footer-cell(fill, fill_text, it) = rect(
  width: 100%,
  height: 100%,
  inset: 1mm,
  outset: 0mm,
  fill: fill,
  stroke: none,
  align(horizon, text(fill: fill_text, it)),
)

// Progress bar component - uses Touying's built-in progress-bar
#let progress-bar(self, flag: true) = {
  if flag {
    // Use built-in progress bar component
    context {
      components.progress-bar(
        height: 2pt,
        self.colors.secondary,
        self.colors.primary,
      )
    }
  }
}

// ============== Slide Functions ==============

// Title Slide
#let title-slide(
  config: (:),
  subtitle: none,
  date: datetime.today(),
  dy-title: 25%,
) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config,
    config-common(freeze-slide-counter: true),
  )
  let info = self.info
  let authors = if "authors" in info { info.authors } else { info.author }
  let emails = if "emails" in info { info.emails } else { self.store.emails }
  let institutions = if "institutions" in info { info.institutions } else { info.institution }

  let body = {
    // Logo
    if info.logo != none {
      place(top + right, dx: -0.6em, dy: 0.5em, info.logo)
    }

    // Title position based on line count or dy-title parameter
    let title-text = text(size: 2.4em, fill: self.colors.secondary, strong(info.title))
    let title-dy = if self.store.dy-title != auto {
      self.store.dy-title
    } else if type(info.title) == "content" {
      context {
        let lines = info.title.text.split("\n").len()
        if lines >= 2 { 35% } else { 25% }
      }
    } else { 25% }

    place(
      top + center,
      dy: title-dy,
      title-text
    )

    // Bottom area: authors, emails, institutions, date
    align(center + bottom, {
      set text(size: 1em)
      if type(authors) == "array" {
        grid(
          columns: (1fr,) * calc.min(authors.len(), 3),
          column-gutter: 1em,
          row-gutter: 1em,
          ..authors.map(author => text(fill: black, author)),
          ..if type(emails) == array {
            emails.map(email => text(fill: black, link("mailto:" + email, email)))
          } else if emails != none {
            (text(fill: black, link("mailto:" + emails, emails)),)
          } else { () },
          ..if type(institutions) == array {
            institutions.map(institution => text(fill: black, institution))
          } else {
            (text(fill: black, institutions),)
          },
        )
      } else {
        grid(
          column-gutter: 1em,
          row-gutter: 1em,
          authors,
          if emails != none { link("mailto:" + emails, emails) },
          institutions,
        )
      }
      v(0.5em)
      if date != none {
        let date-str = if "lang" in self.store and self.store.lang == "Chinese" {
          date.display("[year] 年 [month repr:numerical] 月 [day] 日")
        } else {
          date.display("[month repr:short] [day], [year]")
        }
        text(size: 1em, date-str)
      }
      v(5%)
    })
  }

  touying-slide(self: self, config: config, body)
})

// New Section Slide
#let new-section-slide(
  config: (:),
  name,
) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config,
    config-common(freeze-slide-counter: true),
  )

  let lang = self.store.lang

  // Section number - increment and display from state
  let num-text = context {
    let section-num = section-counter.at(here())
    section-num
  }

  let info = self.info

  let body = {
    // Update section counter for next section
    section-counter.update(n => n + 1)

    // Cache section name to store for footer

    // Logo
    if info.logo != none {
      place(top + right, dx: -0.6em, dy: 0.5em, info.logo)
    }

    set align(center + horizon)

    // No progress bar for section slide (match Polylux)
    v(-10%)

    // Heading: number + title
    block(
      stroke: (bottom: 1mm + self.store.gradient),
      inset: 1em,
      heading(level: 2,  [#num-text. #name])
    )
  }

  touying-slide(self: self, config: config, body)
})

// Content Slide (Table of Contents)
#let content-slide(config: (:)) = touying-slide-wrapper(self => {
  self = utils.merge-dicts(
    self,
    config,
    config-page(
      margin: (top: 2em, bottom: 1em, x: 2em),
      header-ascent: 0.6em,
      footer-descent: 0em,
    ),
  )

  let body = {
    // Header with progress bar
    set align(top)
    counter(footnote).update(0)

    let header-content = {
      progress-bar(self, flag: self.store.progress-barline_flag)
      let title = if self.store.lang == "Chinese" { [目录] } else { [Contents] }
      block(inset: (x: 0.5em), heading(level: 1, title))
    }

    // Footer
    set text(size: 10pt)
    set align(center + bottom)

    let footer-content = {
      grid(
        columns: (15%, 1fr, 15%),
        rows: 1.5em,
        footer-cell(rgb("#f6f5f4"), rgb("77767b"), self.info.author),
        footer-cell(rgb("#f6f5f4"), rgb("77767b"),
          locate(loc => {
            let sections = query(heading.where(level: 1)).at(loc)
            if sections.len() > 0 {
              sections.last()
            }
          })
        ),
        footer-cell(self.colors.tertiary, white,
          if self.store.lang == "Chinese" { [目录] } else { [Contents] }
        ),
      )
    }

    // TOC body
    align(horizon, pad(x: 2em, y: 0.5em, polylux-outline-my(padding: 0%)))
  }

  self = utils.merge-dicts(self, config-page(header: {}, footer: footer-content))

  touying-slide(self: self, body)
})


// Main Slide Function
#let slide(
  config: (:),
  repeat: auto,
  setting: body => body,
  composer: auto,
  title: none,
  header-percent: 70%,
  left-s: 2em,
  right-s: 2em,
  ..bodies,
) = touying-slide-wrapper(self => {
  let info = self.info

  // Setup header
  let header(self) = {
    set align(top)
    counter(footnote).update(0)

    // Progress bar line
    progress-bar(self, flag: self.store.progress-barline_flag)

    // Header content
    let header-text = if title != none {
      align(bottom, [
        #show: block.with(
          stroke: (bottom: 1mm + self.store.gradient),
          inset: 0.6em,
          height: 50pt,
        )
        #heading(level: 3, text(fill: self.colors.secondary, title))
      ])
    } else { [] }

    // Combine with locate for config access
    context {
      let flag = self.store.progress-barline_flag
      let logo = self.info.logo
      if flag {
        place(top + left, dx: 0em, dy: 0.7em, [
          #grid(rows: (auto, auto), row-gutter: 4.9mm, [], [
          #grid(rows: (auto), columns:(1em, auto), [], header-text)
        ])])
      } else {
        place(top + left, dx: 0em, dy: 0.7em, [
          #grid(rows: (auto), columns:(1em, auto), [], header-text)
        ])
      }
      place(top + right, dx: -0.6em, dy: 0.5em, logo)
    }
  }

  // Setup footer - show current section name
  let footer(self) = {
    set text(size: 10pt)
    set align(center + bottom)

    grid(
      columns: (15%, 1fr, 15%),
      rows: 1.5em,
      footer-cell(rgb("#f6f5f4"), rgb("77767b"), self.info.author),
      footer-cell(rgb("#f6f5f4"), rgb("77767b"),
        utils.display-current-heading(level: 2, numbered: false)
      ),
      footer-cell(self.colors.tertiary, white,
        context {
          if self.store.lang == "Chinese" {
            [#utils.slide-counter.display()~/~#utils.last-slide-number 页]
          } else {
            [Page~#utils.slide-counter.display()~/~#utils.last-slide-number]
          }
        }
      ),
    )
  }

  self = utils.merge-dicts(
    self,
    config-page(
      header: header,
      footer: footer,
      margin: (top: 1.8em, bottom: 0.9em, x: 0em),
      header-ascent: 0em,
      footer-descent: 0em,
    ),
    config-common(subslide-preamble: self.store.subslide-preamble),
  )

  let new-setting = body => {
    show: setting
    show figure.caption: it => [#it.body]
    set footnote.entry(gap: 0.3em)
    // 全局顶部对齐，确保 text 和 image 的 baseline 一致
    show: align.with(top)
    pad(left: left-s, right: right-s, y: 0em, body)
  }

  touying-slide(
    self: self,
    config: config,
    repeat: repeat,
    setting: new-setting,
    composer: composer,
    ..bodies,
  )
})

// Focus Slide
#let focus-slide(
  config: (:),
  background-color: none,
  background-img: none,
  body,
) = touying-slide-wrapper(self => {
  let bg-color = if background-img == none and background-color == none {
    self.colors.tertiary
  } else {
    background-color
  }

  self = utils.merge-dicts(
    self,
    config,
    config-common(freeze-slide-counter: true),
  )

  let fill-args = (:)
  if bg-color != none {
    fill-args.fill = bg-color
  }
  // Header with logo (same as regular slides)

    // Use inv-logo for dark background (white text)
    let logo-to-use = if "inv-logo" in self.info and self.info.inv-logo != none {
      self.info.inv-logo
    } else if self.info.logo != none {
      self.info.logo
    } else {
      none
    }
  // Footer with author and email
  let footer(self) = {
    set text(size: 26pt)
    set align(center + bottom)
    let authors = if "authors" in self.info { self.info.authors } else { self.info.author }
    let emails = self.store.emails
    let date = self.info.date
    let date-str = if "lang" in self.store and self.store.lang == "Chinese" {
      date.display("[year] 年 [month repr:numerical] 月 [day] 日")
    } else {
      date.display("[month repr:short] [day], [year]")
    }

    grid(
      columns: (auto,1fr, 1fr, auto),
      rows: 1.0em,
      [#h(1.5em)],
      align(left, text([#authors，#date-str], fill: white)),
      align(right, text(if emails != none { link("mailto:" + emails, emails) }, fill: white)),
      [#h(1.5em)],
      []
    )
  }

  self = utils.merge-dicts(
    self,
    config-page(
      margin: 0em,
      header: none,
      header-ascent: 0.0em,
      footer: footer,
      footer-descent: -10em,
      ..fill-args,
    ),
  )

  if background-img != none {
    self = utils.merge-dicts(self, config-page(background: {
      set image(fit: "stretch", width: 100%, height: 100%)
      background-img
    }))
  }

  // Body content
  let slide-body = {
    // Title size based on language
    let lang = self.store.lang
    if logo-to-use != none {
      place(top + right, dx: -0.6em, dy: 0.5em, logo-to-use)
    }
    let title-size = { 100pt }
    show text: c => text(c, fill: white, weight: "bold", size: title-size)
    align(center + horizon, body)
  }

  touying-slide(self: self, config: config, slide-body)
})

// Matrix Slide (checkerboard)
#let matrix-slide(
  config: (:),
  title: none,
  columns: none,
  rows: none,
  inset-percent: 20%,
  ..bodies,
) = touying-slide-wrapper(self => {
  let bodies = bodies.pos()

  // Calculate columns
  let columns = if type(columns) == "integer" {
    (1fr,) * columns
  } else if columns == none {
    (1fr,) * bodies.len()
  } else {
    columns
  }
  let num-cols = columns.len()

  // Calculate rows
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
    panic("Matrix dimensions too small for content")
  }

  let cart-idx(i) = (calc.quo(i, num-cols), calc.rem(i, num-cols))
  let color-body(idx-body) = {
    let (idx, body) = idx-body
    set align(center)
    rect(
      inset: inset-percent / num-rows,
      width: auto,
      height: auto,
      fill: white,
      stroke: none,
      body,
    )
  }

  let header(self) = {
    set align(top)
    counter(footnote).update(0)
    progress-bar(self, flag: self.store.progress-barline_flag)

    let header-text = if title != none {
      block(
        fill: self.colors.tertiary,
        inset: (x: 0.5em),
        grid(
          columns: (70%, 30%),
          align(top + left, heading(level: 2, text(fill: self.colors.primary, title))),
          align(top + right, text(fill: self.colors.primary.lighten(65%),
            locate(loc => {
              let sections = query(heading.where(level: 1)).at(loc)
              if sections.len() > 0 {
                sections.last()
              }
            })
          )),
        ),
      )
    } else { [] }

    grid(rows: (auto, auto), row-gutter: 5mm, progress-bar(self, flag: true), header-text)
  }

  let footer(self) = {
    set text(size: 10pt)
    set align(center + bottom)

    grid(
      columns: (15%, 1fr, 15%),
      rows: 1.5em,
      footer-cell(rgb("#f6f5f4"), rgb("77767b"), self.info.author),
      footer-cell(rgb("#f6f5f4"), rgb("77767b"),
        context {
          let sections = query(heading.where(level: 1))
          if sections.len() > 0 {
            sections.last()
          }
        }
      ),
      footer-cell(self.colors.tertiary, white,
        context {
          if self.store.lang == "Chinese" {
            [#utils.slide-counter.display()~/~#utils.last-slide-number 页]
          } else {
            [Page~#utils.slide-counter.display()~/~#utils.last-slide-number]
          }
        }
      ),
    )
  }

  let content = grid(
    columns: columns,
    rows: rows,
    gutter: 0pt,
    ..bodies.enumerate().map(color-body),
  )

  self = utils.merge-dicts(
    self,
    config-page(
      header: header,
      footer: footer,
      margin: (top: 2em, bottom: 1em, x: 0em),
      header-ascent: 0.6em,
      footer-descent: 0em,
    ),
  )

  touying-slide(self: self, config: config, content)
})

// ============== Main Theme Function ==============
#let university-theme(
  aspect-ratio: "16-9",
  // Additional config
  logo: none,
  inv-logo: none,
  lang: "Chinese",
  init-section: true,
  progress-barline_flag: true,
  emails: none,
  dy-title: auto,
  // Colors (backward compatibility)
  color-a: rgb("#0C6291"),
  color-b: rgb("#A63446"),
  color-c: rgb("#00561F"),
  color-c1: rgb("#A9D18E"),
  color-c2: rgb("#C5E0B4"),
  // Typography
  text-size: 25pt,
  font: ("Source Han Sans SC", "Noto Sans SC", "SimHei", "Microsoft YaHei", "Arial", "Segoe UI"),
  // Capture config functions via ..args
  ..args,
  body,
) = {
  // Create gradient using default colors
  let grad = gradient.linear(color-c, color-c, color-c, color-c, color-c1, color-c2)

  show: touying-slides.with(
    config-page(
      paper: "presentation-" + aspect-ratio,
      margin: 0em,
      header: none,
      footer: none,
    ),
    config-common(
      slide-fn: slide,
      new-section-slide-fn: new-section-slide,
    ),
    config-methods(
      init: (self: none, body) => {
        set text(size: text-size, font: font, lang: "zh")
        show footnote.entry: set text(size: 0.6em)
        show heading.where(level: 2): set text(fill: self.colors.secondary, size: 50pt)
        show heading.where(level: 3): set text(fill: self.colors.secondary, size: 32pt)
        show heading.where(level: 4): set text(fill: self.colors.primary)
        body
      },
      alert: utils.alert-with-primary-color,
    ),
    config-colors(
      primary: color-b,
      secondary: color-a,
      tertiary: color-c,
      neutral-lightest: white,
      neutral-darkest: black,
    ),
    // Store custom values
    config-store(
      lang: lang,
      logo: logo,
      inv-logo: inv-logo,
      emails: emails,
      progress-barline_flag: progress-barline_flag,
      gradient: grad,
      dy-title: dy-title,
      subslide-preamble: block(
        below: 1.5em,
        text(1.2em, weight: "bold",
          context {
            let sections = query(heading.where(level: 1))
            if sections.len() > 0 {
              sections.last()
            }
          }
        ),
      ),
    ),
    ..args,
  )

  // Initialize first section if needed
  if init-section {
    if lang == "Chinese" {
      // Section tracking via headings([背景])
    } else {
      // Section tracking via headings([Background])
    }
  }

  body
}
