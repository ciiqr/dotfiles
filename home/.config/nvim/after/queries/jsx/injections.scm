;; extends
;; SQL template string injections for sql, tx, and sqlClient

;; Pattern 1: Direct call without type parameters
;; Example: sql`SELECT * FROM users`
(call_expression
  function: (identifier) @_name
  arguments: (template_string) @injection.content
  (#any-of? @_name "sql" "tx" "sqlClient")
  (#set! injection.language "sql")
  (#set! injection.include-children))

;; Pattern 2: Awaited call without type parameters
;; Example: await sql`SELECT * FROM users`
((await_expression
  (call_expression
    function: (identifier) @_name
    arguments: (template_string) @injection.content))
  (#any-of? @_name "sql" "tx" "sqlClient")
  (#set! injection.language "sql")
  (#set! injection.include-children))
