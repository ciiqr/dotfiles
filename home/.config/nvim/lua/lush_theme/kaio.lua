--
-- Built with,
--
--        ,gggg,
--       d8" "8I                         ,dPYb,
--       88  ,dP                         IP'`Yb
--    8888888P"                          I8  8I
--       88                              I8  8'
--       88        gg      gg    ,g,     I8 dPgg,
--  ,aa,_88        I8      8I   ,8'8,    I8dP" "8I
-- dP" "88P        I8,    ,8I  ,8'  Yb   I8P    I8
-- Yb,_,d88b,,_   ,d8b,  ,d8b,,8'_   8) ,d8     I8,
--  "Y8P"  "Y888888P'"Y88P"`Y8P' "YY8P8P88P     `Y8
--

local lush = require("lush")
local hsl = lush.hsl
local string = hsl("#FDDD6C")
local keyword = hsl("#DB2777")
local argument = hsl("#F59E0B")
local func = hsl("#A3E635")
local number = hsl("#A78BFA")
local declaration = hsl("#67E8F9")
local error = hsl("#F43F5E")
local text = hsl("#F5F5F4")
-- local buttons = hsl("#373330")
local background = hsl("#292524")
local comment = hsl("#78716C")
local braces = hsl("#FCD34D")
local line_bg = hsl("#44403C")
-- local border = hsl("#373533")

local accents = {
    yellow = "#FCD34D",
    purple = "#8B5CF6",
    blue = "#22D3EE",
    red = "#BE185D",
    orange = "#D97706",
    green = "#84CC16",
}

-- LSP/Linters mistakenly show `undefined global` errors in the spec, they may
-- support an annotation like the following. Consult your server documentation.
---@diagnostic disable: undefined-global
local theme = lush(function(injected_functions)
    local sym = injected_functions.sym
    return {
        -- The following are the Neovim (as of 0.8.0-dev+100-g371dfb174) highlight
        -- groups, mostly used for styling UI elements.
        -- Comment them out and add your own properties to override the defaults.
        -- An empty definition `{}` will clear all styling, leaving elements looking
        -- like the 'Normal' group.
        -- To be able to link to a group, it must already be defined, so you may have
        -- to reorder items as you go.
        --
        -- See :h highlight-groups
        --
        -- ColorColumn    { }, -- Columns set with 'colorcolumn'
        -- Conceal        { }, -- Placeholder characters substituted for concealed text (see 'conceallevel')
        -- Cursor         { }, -- Character under the cursor
        -- CurSearch      { }, -- Highlighting a search pattern under the cursor (see 'hlsearch')
        -- lCursor        { }, -- Character under the cursor when |language-mapping| is used (see 'guicursor')
        -- CursorIM       { }, -- Like Cursor, but used when in IME mode |CursorIM|
        -- CursorColumn   { }, -- Screen-column at the cursor, when 'cursorcolumn' is set.
        -- CursorLine     { }, -- Screen-line at the cursor, when 'cursorline' is set. Low-priority if foreground (ctermfg OR guifg) is not set.
        Directory({ fg = accents.yellow }), -- Directory names (and other special names in listings)
        -- DiffAdd({ fg = background, bg = func }), -- Diff mode: Added line |diff.txt|
        -- DiffChange({ fg = background, bg = braces }), -- Diff mode: Changed line |diff.txt|
        -- DiffDelete({ fg = background, bg = keyword }), -- Diff mode: Deleted line |diff.txt|
        -- GitSignsChange({ fg = braces }),
        -- DiffText       { }, -- Diff mode: Changed text within a changed line |diff.txt|
        -- EndOfBuffer    { }, -- Filler lines (~) after the end of the buffer. By default, this is highlighted like |hl-NonText|.
        -- TermCursor     { }, -- Cursor in a focused terminal
        -- TermCursorNC   { }, -- Cursor in an unfocused terminal
        -- ErrorMsg       { }, -- Error messages on the command line
        -- VertSplit      { }, -- Column separating vertically split windows
        -- Folded         { }, -- Line used for closed folds
        -- FoldColumn     { }, -- 'foldcolumn'
        -- SignColumn     { }, -- Column where |signs| are displayed
        -- IncSearch      { }, -- 'incsearch' highlighting; also used for the text replaced with ":s///c"
        -- Substitute     { }, -- |:substitute| replacement text highlighting
        -- LineNr         { }, -- Line number for ":number" and ":#" commands, and when 'number' or 'relativenumber' option is set.
        -- LineNrAbove    { }, -- Line number for when the 'relativenumber' option is set, above the cursor line
        -- LineNrBelow    { }, -- Line number for when the 'relativenumber' option is set, below the cursor line
        -- CursorLineNr   { }, -- Like LineNr when 'cursorline' or 'relativenumber' is set for the cursor line.
        -- CursorLineFold { }, -- Like FoldColumn when 'cursorline' is set for the cursor line
        -- CursorLineSign { }, -- Like SignColumn when 'cursorline' is set for the cursor line
        -- MatchParen     { }, -- Character under the cursor or just before it, if it is a paired bracket, and its match. |pi_paren.txt|
        -- ModeMsg        { }, -- 'showmode' message (e.g., "-- INSERT -- ")
        -- MsgArea        { }, -- Area for messages and cmdline
        -- MsgSeparator   { }, -- Separator for scrolled messages, `msgsep` flag of 'display'
        -- MoreMsg        { }, -- |more-prompt|
        -- NonText        { }, -- '@' at the end of the window, characters from 'showbreak' and other characters that do not really exist in the text (e.g., ">" displayed when a double-wide character doesn't fit at the end of the line). See also |hl-EndOfBuffer|.
        Normal({ bg = background, fg = text, guisp = "undercurl" }), -- Normal text
        NormalFloat({ bg = background, fg = text }), -- Normal text in floating windows.
        FloatBorder({ fg = accents.yellow }), -- Border of floating windows.
        -- FloatTitle     { }, -- Title of floating windows.
        -- NormalNC       { }, -- normal text in non-current windows
        Pmenu({ bg = background, fg = text }), -- Popup menu: Normal item.
        PmenuBorder({ fg = accents.yellow }),
        PmenuSel({ bg = line_bg }), -- Popup menu: Selected item.
        -- PmenuKind      { }, -- Popup menu: Normal item "kind"
        -- PmenuKindSel   { }, -- Popup menu: Selected item "kind"
        -- PmenuExtra     { }, -- Popup menu: Normal item "extra text"
        -- PmenuExtraSel  { }, -- Popup menu: Selected item "extra text"
        PmenuExtraBorder({ fg = accents.yellow }),
        -- PmenuSbar      { }, -- Popup menu: Scrollbar.
        PmenuThumb({ bg = accents.yellow, fg = accents.red }), -- Popup menu: Thumb of the scrollbar.
        -- Question       { }, -- |hit-enter| prompt and yes/no questions
        -- QuickFixLine   { }, -- Current |quickfix| item in the quickfix window. Combined with |hl-CursorLine| when the cursor is there.
        -- Search         { }, -- Last search pattern highlighting (see 'hlsearch'). Also used for similar items that need to stand out.
        -- SpecialKey     { }, -- Unprintable characters: text displayed differently from what it really is. But not 'listchars' whitespace. |hl-Whitespace|
        -- SpellBad       { }, -- Word that is not recognized by the spellchecker. |spell| Combined with the highlighting used otherwise.
        -- SpellCap       { }, -- Word that should start with a capital. |spell| Combined with the highlighting used otherwise.
        -- SpellLocal     { }, -- Word that is recognized by the spellchecker as one that is used in another region. |spell| Combined with the highlighting used otherwise.
        -- SpellRare      { }, -- Word that is recognized by the spellchecker as one that is hardly ever used. |spell| Combined with the highlighting used otherwise.
        -- StatusLine     { }, -- Status line of current window
        -- StatusLineNC   { }, -- Status lines of not-current windows. Note: If this is equal to "StatusLine" Vim will use "^^^" in the status line of the current window.
        -- TabLine        { }, -- Tab pages line, not active tab page label
        -- TabLineFill    { }, -- Tab pages line, where there are no labels
        -- TabLineSel     { }, -- Tab pages line, active tab page label
        -- Title          { }, -- Titles for output from ":set all", ":autocmd" etc.
        -- Visual({ bg = func }), -- Visual mode selection
        -- VisualNOS      { }, -- Visual mode selection when vim is "Not Owning the Selection".
        WarningMsg({ fg = accents.yellow }), -- Warning messages
        -- Whitespace     { }, -- "nbsp", "space", "tab" and "trail" in 'listchars'
        -- Winseparator   { }, -- Separator between window splits. Inherts from |hl-VertSplit| by default, which it will replace eventually.
        -- WildMenu       { }, -- Current match in 'wildmenu' completion
        -- WinBar         { }, -- Window bar of current window
        -- WinBarNC       { }, -- Window bar of not-current windows

        -- Common vim syntax groups used for all kinds of code and markup.
        -- Commented-out groups should chain up to their preferred (*) group
        -- by default.
        --
        -- See :h group-name
        --
        -- Uncomment and edit if you want more specific syntax highlighting.

        Comment({ fg = comment }), -- Any comment

        Constant({ fg = number }), -- (*) Any constant
        String({ fg = string }), --   A string constant: "this is a string"
        -- Character      { }, --   A character constant: 'c', '\n'
        -- Number         { }, --   A number constant: 234, 0xff
        -- Boolean        { }, --   A boolean constant: TRUE, false
        -- Float          { }, --   A floating point constant: 2.3e10

        Identifier({ fg = text }), -- (*) Any variable name
        Function({ fg = func }), --   Function name (also: methods for classes)

        SnacksPickerListCursorLine({ bg = line_bg }),
        SnacksPickerDir({ fg = comment }),

        RainbowDelimiterOne({ fg = accents.yellow }),
        RainbowDelimiterTwo({ fg = accents.purple }),
        RainbowDelimiterThree({ fg = accents.blue }),
        RainbowDelimiterFour({ fg = accents.red }),
        RainbowDelimiterFive({ fg = accents.orange }),
        RainbowDelimiterSix({ fg = accents.green }),

        -- Statement      { }, -- (*) Any statement
        Conditional({ fg = keyword }), --   if, then, else, endif, switch, etc.
        Repeat({ fg = keyword }), --   for, do, while, etc.
        Label({ fg = keyword }), --   case, default, etc.
        Operator({ fg = keyword }), --   "sizeof", "+", "*", etc.
        Keyword({ fg = keyword }), --   any other keyword
        Exception({ fg = keyword }), --   try, catch, throw

        -- PreProc        { }, -- (*) Generic Preprocessor
        -- Include        { }, --   Preprocessor #include
        -- Define         { }, --   Preprocessor #define
        -- Macro          { }, --   Same as Define
        -- PreCondit      { }, --   Preprocessor #if, #else, #endif, etc.

        Type({ fg = func }), -- (*) int, long, char, etc.
        -- StorageClass   { }, --   static, register, volatile, etc.
        -- Structure      { }, --   struct, union, enum, etc.
        -- Typedef        { }, --   A typedef

        Special({ fg = text }), -- (*) Any special symbol
        -- SpecialChar    { }, --   Special character in a constant
        Tag({ fg = declaration, gui = "NONE" }), --   You can use CTRL-] on this
        Delimiter({ fg = text }), --   Character that needs attention
        -- SpecialComment { }, --   Special things inside a comment (e.g. '\n')
        -- Debug          { }, --   Debugging statements

        -- Underlined     { gui = "underline" }, -- Text that stands out, HTML links
        -- Ignore         { }, -- Left blank, hidden |hl-Ignore| (NOTE: May be invisible here in template)
        -- Error          { }, -- Any erroneous construct
        -- Todo           { }, -- Anything that needs extra attention; mostly the keywords TODO FIXME and XXX

        -- These groups are for the native LSP client and diagnostic system. Some
        -- other LSP clients may use these groups, or use their own. Consult your
        -- LSP client's documentation.

        -- See :h lsp-highlight, some groups may not be listed, submit a PR fix to lush-template!
        --
        -- LspReferenceText            { } , -- Used for highlighting "text" references
        -- LspReferenceRead            { } , -- Used for highlighting "read" references
        -- LspReferenceWrite           { } , -- Used for highlighting "write" references
        -- LspCodeLens                 { } , -- Used to color the virtual text of the codelens. See |nvim_buf_set_extmark()|.
        -- LspCodeLensSeparator        { } , -- Used to color the seperator between two or more code lens.
        -- LspSignatureActiveParameter { } , -- Used to highlight the active parameter in the signature help. See |vim.lsp.handlers.signature_help()|.

        -- See :h diagnostic-highlights, some groups may not be listed, submit a PR fix to lush-template!
        --
        DiagnosticError({ fg = error }), -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
        DiagnosticWarn({ fg = accents.yellow }), -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
        DiagnosticInfo({ fg = accents.blue }), -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
        -- DiagnosticHint             { } , -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
        -- DiagnosticOk               { } , -- Used as the base highlight group. Other Diagnostic highlights link to this by default (except Underline)
        -- DiagnosticVirtualTextError { } , -- Used for "Error" diagnostic virtual text.
        -- DiagnosticVirtualTextWarn  { } , -- Used for "Warn" diagnostic virtual text.
        -- DiagnosticVirtualTextInfo  { } , -- Used for "Info" diagnostic virtual text.
        -- DiagnosticVirtualTextHint  { } , -- Used for "Hint" diagnostic virtual text.
        -- DiagnosticVirtualTextOk    { } , -- Used for "Ok" diagnostic virtual text.
        -- DiagnosticUnderlineError({ sp = accents.yellow, gui = "undercurl" }), -- Used to underline "Error" diagnostics.
        DiagnosticUnderlineWarn({ sp = accents.yellow, gui = "undercurl" }), -- Used to underline "Warn" diagnostics.
        -- DiagnosticUnderlineInfo({ sp = accents.yellow, gui = "undercurl" }), -- Used to underline "Info" diagnostics.
        -- DiagnosticUnderlineHint({ sp = accents.yellow, gui = "undercurl" }), -- Used to underline "Hint" diagnostics.
        -- DiagnosticUnderlineOk({ sp = accents.yellow, gui = "undercurl" }), -- Used to underline "Ok" diagnostics.
        -- DiagnosticFloatingError    { } , -- Used to color "Error" diagnostic messages in diagnostics float. See |vim.diagnostic.open_float()|
        -- DiagnosticFloatingWarn     { } , -- Used to color "Warn" diagnostic messages in diagnostics float.
        -- DiagnosticFloatingInfo     { } , -- Used to color "Info" diagnostic messages in diagnostics float.
        -- DiagnosticFloatingHint     { } , -- Used to color "Hint" diagnostic messages in diagnostics float.
        -- DiagnosticFloatingOk       { } , -- Used to color "Ok" diagnostic messages in diagnostics float.
        -- DiagnosticSignError        { } , -- Used for "Error" signs in sign column.
        -- DiagnosticSignWarn         { } , -- Used for "Warn" signs in sign column.
        -- DiagnosticSignInfo         { } , -- Used for "Info" signs in sign column.
        -- DiagnosticSignHint         { } , -- Used for "Hint" signs in sign column.
        -- DiagnosticSignOk           { } , -- Used for "Ok" signs in sign column.

        -- Note language
        NoteComment({ fg = comment }),
        NoteSection({ fg = string }),
        NoteDone({ fg = func }),
        NoteTodo({ fg = argument }),
        NoteQuestion({ fg = declaration, italic = true }),
        NotePartial({ fg = declaration }),
        NoteImportant({ fg = keyword }),
        NoteUrgent({ fg = keyword, bold = true, gui = "underline" }),

        -- Tree-Sitter syntax groups.
        --
        -- See :h treesitter-highlight-groups, some groups may not be listed,
        -- submit a PR fix to lush-template!
        --
        -- Tree-Sitter groups are defined with an "@" symbol, which must be
        -- specially handled to be valid lua code, we do this via the special
        -- sym function. The following are all valid ways to call the sym function,
        -- for more details see https://www.lua.org/pil/5.html
        --
        -- sym("@text.literal")
        -- sym('@text.literal')
        -- sym"@text.literal"
        -- sym'@text.literal'
        --
        -- For more information see https://github.com/rktjmp/lush.nvim/issues/109

        -- sym"@text.literal"      { }, -- Comment
        -- sym"@text.reference"    { }, -- Identifier
        -- sym"@text.title"        { }, -- Title
        -- sym"@text.uri"          { }, -- Underlined
        -- sym"@text.underline"    { }, -- Underlined
        -- sym"@text.todo"         { }, -- Todo
        -- sym"@comment"           { }, -- Comment
        -- sym"@punctuation"       { }, -- Delimiter
        sym("@punctuation.bracket")({ fg = braces }),
        -- sym"@constant"          { }, -- Special
        sym("@constant.builtin")({ fg = number }), -- Constant
        -- sym"@constant.macro"    { }, -- Define
        -- sym"@define"            { }, -- Define
        -- sym"@macro"             { }, -- Macro
        -- sym"@string"            { }, -- String
        -- sym"@string.escape"     { }, -- SpecialChar
        -- sym"@string.special"    { }, -- SpecialChar
        -- sym"@character"         { }, -- Character
        -- sym"@character.special" { }, -- SpecialChar
        -- sym"@number"            { }, -- Number
        -- sym"@boolean"           { }, -- Boolean
        -- sym"@float"             { }, -- Float
        -- sym"@function"          { }, -- Function
        sym("@function.builtin")({ fg = declaration }), -- Special
        -- sym"@function.macro"    { }, -- Macro
        -- sym"@parameter"         { }, -- Identifier
        -- sym"@method"            { }, -- Function
        -- sym"@field"             { }, -- Identifier
        -- sym"@property"          { }, -- Identifier
        -- sym"@constructor"       { }, -- Special
        -- sym"@conditional"       { }, -- Conditional
        -- sym"@repeat"            { }, -- Repeat
        -- sym"@label"             { }, -- Label
        -- sym"@operator"          { }, -- Operator
        sym("@lsp.type.interface")({ fg = func, gui = "underline" }), -- Keyword
        sym("@lsp.type.type")({ fg = func, gui = "underline" }), -- Keyword
        -- sym("@keyword")({ fg = keyword }), -- Keyword
        -- sym("@keyword.typescript")({ fg = declaration }), -- Keyword
        -- sym("@keyword.exception.typescript")({ fg = keyword }), -- Keyword
        -- sym("@keyword.import.typescript")({ fg = keyword }), -- Keyword
        sym("@punctuation.special")({ fg = keyword }), -- Keyword
        sym("@keyword.function")({ fg = declaration, gui = "italic" }), -- Keyword
        -- sym"@exception"         { }, -- Exception
        -- sym"@variable"          { }, -- Identifier
        sym("@lsp.type.parameter")({ fg = argument, gui = "italic" }), -- Keyword
        -- sym("@lsp.typemod.parameter.declaration.typescript")({ fg = argument, gui = "italic" }), -- Keyword
        sym("@lsp.typemod.function.declaration.typescript")({ fg = func }), -- Keyword
        sym("@lsp.typemod.function.defaultLibrary")({ fg = declaration }), -- Keyword
        sym("@lsp.typemod.class.defaultLibrary.typescript")({ fg = declaration }), -- Keyword
        sym("@keyword_but_not_like_that")({ fg = declaration, gui = "italic" }),
        sym("@joker_baby")({ fg = keyword, gui = "NONE" }),
        sym("@import_type")({ fg = keyword, gui = "nocombine,NONE" }),
        sym("@type.builtin")({ fg = declaration, gui = "italic" }), -- Keyword
        sym("@type_annotation_colon")({ fg = keyword }),
        -- sym("@_jsx_element")({ fg = declaration }), -- Keyword
        sym("@tag")({ fg = declaration, gui = "italic" }), -- Keyword
        sym("@tag.attribute")({ fg = func }), -- Keyword
        sym("@tag.builtin")({ fg = keyword, gui = "NONE" }), -- Keyword
        sym("@jsx_bracket")({ fg = text }),
        sym("@type")({ fg = text }), -- Type
        -- sym"@type.definition"   { }, -- Typedef
        -- sym"@storageclass"      { }, -- StorageClass
        -- sym"@structure"         { }, -- Structure
        -- sym"@namespace"         { }, -- Identifier
        -- sym"@include"           { }, -- Include
        -- sym"@preproc"           { }, -- PreProc
        -- sym"@debug"             { }, -- Debug
        -- SQL
        sym("@attribute.sql")({ fg = keyword }),
        sym("@constructor.lua")({ fg = braces }),
        sym("@string.escape")({ fg = number }),
    }
end)

-- Return our parsed theme for extension or use elsewhere.
return theme

-- vi:nowrap
