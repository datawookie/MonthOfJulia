# MARKDOWN ============================================================================================================

# https://github.com/one-more-minute/Markdown.jl
# https://github.com/JuliaLang/julia/blob/master/test/markdown.jl

# Mardown is now part of Base.

# This file is a part of Julia. License is MIT: http://julialang.org/license

using Base.Markdown
import Base.Markdown: MD, Paragraph, Header, Italic, Bold, LineBreak, plain, term, html, Table, Code, LaTeX, writemime

d1 = md"foo *italic foo* **bold foo** `code foo`"
typeof(d1)
d2 = MD(Paragraph(["foo ", Italic("italic foo"), " ", Bold("bold foo"), " ", Code("code foo")]))
d1 == d2

# Formatting functions only work on Base.Markdown.MD not a simple string!
#
d1 |> plain
html(d1)
latex(d1)

# Headers.
#
d3 = md"""# Chapter Title
## Section Title
### Subsection Title""";
d4 = MD(Header{2}("Section Title"));
d3 |> html
latex(d4)

# Code.
#
md"""```python
x = 1
if x == 1:
    print "x is 1."
```"""

# Unordered list.
#
md"""
* first unordered item
* second unordered item
* third unordered item
"""

# Ordered list.
#
md"""
1. first ordered item
2. second ordered item
3. third ordered item
"""

d5 = md"""
# Title

> Lorem ipsum dolor sit amet, consectetur adipiscing elit.

- item
- another item
""";

writemime(STDOUT, "text/plain", d5)
writemime(STDOUT, "text/html", d5)

# Looking at package documentation.
#
readme("Quandl")

# Parsing a markdown file.
#
d6 = Markdown.parse_file(joinpath(homedir(), ".julia/v0.4/NaNMath/README.md"));
html(d6)
print(d6 |> latex)
