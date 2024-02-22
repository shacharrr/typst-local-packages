// Importing required libraries
#import "@preview/cetz:0.2.0": canvas, draw, angle
#import "@preview/oxifmt:0.2.0": strfmt

// Function to rotate a vector by a given angle
#let rotate_vector((x, y), angle) = {
  let rotated_x = x * calc.cos(angle) - y * calc.sin(angle)
  let rotated_y = x * calc.sin(angle) + y * calc.cos(angle)
  return (rotated_x, rotated_y)
}

// Function to draw a vector line
#let vector(
  (x0, y0), (x1, y1),
  stroke: (paint: black), 
  angle-style: (),
  angle-invert: false,
  components: (stroke: none),
  label: none,
  name: none
) = {
  if name == none {
    name = "vec"
  }

  // Draw the angle
  if x0 != x1 and y0 != y1 {
    let point_b = if calc.abs(y1) < calc.abs(x1) { (x1, 0) } else { (0, y1) }
    if angle-invert {
      point_b = if point_b == (0, y1) { (x1, 0) } else { (0, y1) }
    }
    angle.angle((0, 0), (x1, y1), point_b, ..angle-style)
  }

  // Draw vector components
  draw.line((x1, 0), (x1, y1), ..components)
  draw.line((0, y1), (x1, y1), ..components)

  // Draw the vector
  draw.line((x0, y0), (x1, y1), mark: (end: (symbol: "stealth", fill: stroke.paint, scale: 0.5)), stroke: stroke, name: name)

  // Draw the label
  if label != none {
    let anch = if y1 > y0 { "south" } else { "north" }
    draw.content(strfmt("{}.end", name), text(stroke.paint)[#label], anchor: anch, padding: 0.05)
  }
}

// Function to draw axes
#let axis(
  (xmin, xmax), (ymin, ymax),
  stroke: (paint: black),
  horizontal_label: $x$,
  vertical_label: $y$,
  labels: true
) = {
  vector((xmin, 0), (xmax, 0), stroke: stroke, name: "horizontal")
  vector((0, ymin), (0, ymax), stroke: stroke, name: "vertical")

  // Draw labels if enabled
  if labels {
    draw.content("horizontal.end", text(stroke.paint)[#horizontal_label], anchor: "west", padding: 0.05)
    draw.content("vertical.end", text(stroke.paint)[#vertical_label], anchor: "south", padding: 0.1)
  }
}
