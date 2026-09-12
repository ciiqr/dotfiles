vim.wo.foldmethod = "expr"

-- line_num is one based
_G.note_indent_fold = function(line_num)
    -- Determine file's indent size
    local indent_size = 4 -- fallback value
    if vim.bo.shiftwidth > 0 then
        indent_size = vim.bo.shiftwidth
    elseif vim.bo.tabstop > 0 then
        indent_size = vim.bo.tabstop
    end

    -- Find the next (non blank) line
    local next_line_num = line_num + 1
    local total_lines = vim.api.nvim_buf_line_count(0)
    while next_line_num <= total_lines do
        local next_line_text = vim.fn.getline(next_line_num)
        if not next_line_text:match("^%s*$") then
            break
        end
        next_line_num = next_line_num + 1
    end

    -- Get the indent level of the next line
    -- NOTE: on the last line of a file will return -1, if the last line of the
    -- file is blank we'll end up returning -1 for the indent (inherit from
    -- nearby)
    local next_indent = vim.fn.indent(next_line_num)

    -- Blank lines match the indentation of following line, thus preventing
    -- blank lines from being folded into any previous blocks (unless they're in
    -- the middle of an indented section)
    local line = vim.fn.getline(line_num)
    if line:match("^%s*$") then
        return math.floor(next_indent / indent_size)
    end

    -- If the next valid line is deeper, then this line starts a fold
    local current_indent = vim.fn.indent(line_num)
    if next_indent > current_indent then
        return ">" .. math.floor(next_indent / indent_size)
    end

    -- All other lines are at the expected fold level for their indentation
    return math.floor(current_indent / indent_size)
end

vim.wo.foldexpr = "v:lua.note_indent_fold(v:lnum)"
