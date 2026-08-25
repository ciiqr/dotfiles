;; extends
;; SQL template string injections for sql, tx, and sqlClient

;; Match sql/tx/sqlClient calls with template strings
;; Handles both direct calls (sql`...`) and generic calls (sql<Type>`...`)
;; Note: TypeScript parses sql<Type> as non_null_expression(instantiation_expression(...))
;; When using await sql<Type>, the await_expression is inside the instantiation_expression
(call_expression
  function: [
    (identifier) @_name
    (await_expression (identifier) @_name)
    (instantiation_expression function: (identifier) @_name)
    (non_null_expression
      (instantiation_expression
        [
         (identifier) @_name
         (await_expression (identifier) @_name)
         ]
      )
    )
  ]
  arguments: (template_string (string_fragment) @injection.content)
  (#any-of? @_name "sql" "tx" "sqlClient")
  (#set! injection.language "sql")
  (#set! injection.include-children))

; Multi-line generic in ternary - consequence branch
(
  (ternary_expression
    consequence: (binary_expression
      left: (binary_expression
        left: (await_expression
          (identifier) @_name))
      right: (template_string (string_fragment) @injection.content)))
  (#any-of? @_name "sql" "tx" "sqlClient")
  (#set! injection.language "sql")
  (#set! injection.include-children)
)

;; Multi-line generic in ternary - alternative branch
(
  (ternary_expression
    alternative: (binary_expression
      left: (binary_expression
        left: (await_expression
          (identifier) @_name))
      right: (template_string (string_fragment) @injection.content)))
  (#any-of? @_name "sql" "tx" "sqlClient")
  (#set! injection.language "sql")
  (#set! injection.include-children)
)

;; Match standalone binary_expression (not in ternary)
;; Multi-line generics create nested binary expressions:
;; binary(await sql, binary(type, binary(type, template_string)))
(binary_expression
  left: (await_expression
    (identifier) @_name)
  right: (binary_expression
    right: (binary_expression
      right: (template_string (string_fragment) @injection.content)))
  (#any-of? @_name "sql" "tx" "sqlClient")
  (#set! injection.language "sql")
  (#set! injection.include-children)
)

;; Match standalone binary_expression (not in ternary)
;; Multi-line generics create nested binary expressions:
;; binary(await sql, binary(type, binary(type, template_string)))
(binary_expression
  left: (binary_expression
    left: (await_expression
      (identifier) @_name))
  right: (template_string (string_fragment) @injection.content)
  (#any-of? @_name "sql" "tx" "sqlClient")
  (#set! injection.language "sql")
  (#set! injection.include-children)
)

;; Ternary as function - alternative branch
;; Structure: call_expression with ternary inside non_null_expression as function
;; The alternative branch is an instantiation_expression, and template_string is outer arguments
(call_expression
  function: (non_null_expression
    (ternary_expression
      alternative: (instantiation_expression
        (await_expression
          (identifier) @_name))))
  arguments: (template_string (string_fragment) @injection.content)
  (#any-of? @_name "sql" "tx" "sqlClient")
  (#set! injection.language "sql")
  (#set! injection.include-children)
)

(call_expression
  function: (await_expression
    (member_expression
      object: (identifier) @_name
      property: (property_identifier)))
  arguments: (template_string
    (string_fragment) @injection.content)
  (#any-of? @_name "sql" "tx" "sqlClient")
  (#set! injection.language "sql")
  (#set! injection.include-children)
)
