;; extends

(jsx_element
  open_tag: (jsx_opening_element
              "<" @jsx_bracket
              ">" @jsx_bracket)
  close_tag: (jsx_closing_element
               "</" @jsx_bracket
               ">" @jsx_bracket)) @jsx_container

(jsx_element
  open_tag: (jsx_opening_element
              "<" @jsx_bracket
              ">" @jsx_bracket)
  close_tag: (jsx_closing_element
              "</" @jsx_bracket
              ">" @jsx_bracket)) @jsx_container

(jsx_self_closing_element
  "<" @jsx_bracket
  "/>" @jsx_bracket) @jsx_container

(jsx_self_closing_element
  "<" @jsx_bracket
  "/>" @jsx_bracket) @jsx_container
[
    "interface"
    "type"
    "const"
    "var"
    "let"
] @keyword_but_not_like_that
(import_statement
    "type" @import_type
)
(type_annotation
    ":" @type_annotation_colon
)
