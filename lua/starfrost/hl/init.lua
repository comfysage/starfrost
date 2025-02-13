local M = {}

---@alias starfrost.types.colorspec { [1]: Color, [2]: Color, link: string, reverse: boolean }
---@alias starfrost.types.hlgroups { [string]: starfrost.types.colorspec }

---@param theme starfrost.types.theme
---@param config starfrost.types.config
function M.setup(theme, config)
  ---@type starfrost.types.hlgroups
  local hl_groups = {
    Normal = { theme.fg, theme.bg },

    Cursor = { theme.sakaeru },
    CursorLine   = { theme.none, theme.bg1 },
    CursorColumn = { theme.none, theme.bg1 },
    QuickFixLine = { theme.none, theme.bg1 },

    Visual = { theme.none, theme.bg3 },

    LineNr = { theme.bg2 },
    CursorLineNr = { theme.comment },
    SignColumn = { theme.none, theme.sign },
    WinSeparator = { theme.bg2 },
    VertSplit    = { link = "WinSeparator" },
    TabLineSel = config.style.tabline.reverse and { theme.base.fg, theme.colors[config.style.tabline.color] } or { theme.colors[config.style.tabline.color] },
    TabLine = { theme.comment },
    TabLineFill = { link = 'TabLine' },
    Title = { theme.comment },
    NonText = { theme.fg_accent },
    Folded = { theme.comment },
    FoldColumn = { theme.bg1 },

    NormalFloat        = { theme.fg, theme.bg_accent },
    FloatBorder        = { theme.bg2 },
    StatusLine         = { theme.fg2, theme.none },
    StatusLineNC       = { theme.fg2, theme.bg1 },
    FloatShadow        = { theme.none, theme.none },
    FloatShadowThrough = { theme.none, theme.none },

    OkText       = { theme.diagnostic.ok,    theme.none      },
    ErrorText    = { theme.diagnostic.error, theme.none      },
    WarningText  = { theme.diagnostic.warn,  theme.none      },
    InfoText     = { theme.diagnostic.info,  theme.none      },
    HintText     = { theme.diagnostic.hint,  theme.none      },
    OkFloat      = { theme.diagnostic.ok,    theme.bg_accent },
    ErrorFloat   = { theme.diagnostic.error, theme.bg_accent },
    WarningFloat = { theme.diagnostic.warn,  theme.bg_accent },
    InfoFloat    = { theme.diagnostic.info,  theme.bg_accent },
    HintFloat    = { theme.diagnostic.hint,  theme.bg_accent },

    Question = { theme.comment },

    Search = { theme.taiyo, reverse = config.style.search.reverse },
    CurSearch = { theme.taiyo, reverse = config.style.search.inc_reverse },
    IncSearch = { link = 'CurSearch' },

    Error      = { theme.diagnostic.error },
    ErrorMsg   = { link = "Error" },
    WarningMsg = { theme.diagnostic.warn },
    MoreMsg = { theme.comment },
    ModeMsg = { theme.bg2, theme.none },

    ColorColumn = { theme.none, theme.bg1 },

    Directory = { theme.colors.grey1 },

    Underlined = { theme.none, theme.none },

    -- Completion Menu
    Pmenu = { theme.fg1, theme.bg2 },
    PmenuSel = { theme.bg2, theme.shinme, reverse = theme.style.search.reverse },
    PmenuSbar = { theme.none, theme.bg2 },
    PmenuThumb = { theme.none, theme.fg2 },

    -- Diffs
    DiffAdd    = { theme.diff.add,    theme.bg },
    DiffDelete = { theme.diff.delete, theme.bg },
    DiffChange = { theme.diff.change, theme.bg },
    DiffText   = { theme.fg0, theme.bg },
    diffAdded   = { link = "@diff.add"    },
    diffRemoved = { link = "@diff.delete" },
    diffChanged = { link = "@diff.change" },
    diffFile    = { theme.syntax.object },
    diffNewFile = { theme.syntax.object },
    diffLine    = { theme.syntax.context },
    Added   = { link = "@diff.add"    },
    Removed = { link = "@diff.delete" },
    Changed = { link = "@diff.change" },

    -- Spell
    SpellCap   = { theme.shinme },
    SpellBad   = { theme.sage },
    SpellLocal = { theme.sage },
    SpellRare  = { theme.seiun },
  }

  -- merge syntax hl groups
  hl_groups = vim.tbl_extend('force', hl_groups, require 'starfrost.hl.syntax'(theme, config))

  -- merge treesitter hl groups
  hl_groups = vim.tbl_extend('force', hl_groups, require 'starfrost.hl.treesitter'(theme, config))

  -- merge diagnostic hl groups
  hl_groups = vim.tbl_extend('force', hl_groups, require 'starfrost.hl.diagnostics'(theme, config))

  -- lsp
  hl_groups['@constructor.lua'] = { theme.syntax.context }

  for _, ft in ipairs { 'html', 'css', 'svelte' } do
    local ok, hl_ft_fn = pcall(require, ('starfrost.hl.ft.%s'):format(ft))
    if ok then
      ---@diagnostic disable-next-line: redefined-local
      local ok, hl_imports = pcall(hl_ft_fn, theme, config)
      if ok then
        hl_groups = vim.tbl_deep_extend('force', hl_groups, hl_imports)
      end
    end
  end

  hl_groups['@lsp.type.macro.rust'] = { theme.syntax.macro }

  -- fix lsp hover doc
  hl_groups['@none.markdown'] = { theme.none, theme.none }

  -- hl_groups['@include.typescript'] = { theme.syntax.keyword }

  hl_groups['markdownH1'] = { link = '@text.title.1' }
  hl_groups['markdownH2'] = { link = '@text.title.2' }
  hl_groups['markdownH3'] = { link = '@text.title.3' }
  hl_groups['markdownH4'] = { link = '@text.title.4' }
  hl_groups['markdownH5'] = { link = '@text.title.5' }
  hl_groups['markdownH6'] = { link = '@text.title.6' }

  -- markdown
  hl_groups['markdownBold'] = { link = '@markup.strong' }
  hl_groups['markdownItalic'] = { link = '@markup.italic' }
  hl_groups['markdownUrl'] = { link = '@markup.link.url' }

  -- Telescope
  hl_groups['TelescopeNormal']         = { theme.syntax.context }
  -- hl_groups['TelescopeNormal'] = { link = 'Normal' }
  hl_groups['TelescopePromptPrefix']   = { link = "Constant" }
  hl_groups['TelescopePromptNormal'] = { 'none', 'none' }
  hl_groups['TelescopeSelection']      = { link = "Identifier" }
  hl_groups['TelescopeSelection'] = { 'none', theme.bg_accent }
  hl_groups['TelescopeSelectionCaret'] = { link = "TelescopeNormal" }
  hl_groups['TelescopeMatching']       = { link = "Search" }
  hl_groups['TelescopeMatching'] = { link = 'Search' }
  hl_groups['TelescopeTitle'] = { link = 'FloatTitle' }
  hl_groups['TelescopeBorder'] = { link = 'FloatBorder' }

  hl_groups['TelescopeBorder']        = { theme.bg2 }
  hl_groups['TelescopePromptBorder']  = { link = "TelescopeBorder" }
  hl_groups['TelescopeResultsBorder'] = { link = "TelescopeBorder" }
  hl_groups['TelescopePreviewBorder'] = { link = "TelescopeBorder" }

  -- GitSigns
  hl_groups['GitGutterAdd']    = { theme.diff.add,    theme.sign }
  hl_groups['GitGutterChange'] = { theme.diff.change, theme.sign }
  hl_groups['GitGutterDelete'] = { theme.diff.delete, theme.sign }
  hl_groups['GitGutterChangeDelete'] = { link = 'GitGutterChange' }

  -- Cmp
  hl_groups['CmpItemMenu'] = { theme.syntax.constant, italic = true }

  hl_groups['CmpItemKindText']  = { theme.fg1 }
  hl_groups['CmpItemKindMethod']  = { theme.syntax.constant }
  hl_groups['CmpItemKindFunction']  = { theme.syntax.call }
  hl_groups['CmpItemKindConstructor']  = { theme.syntax.type }
  hl_groups['CmpItemKindField']  = { theme.syntax.object }
  hl_groups['CmpItemKindVariable']  = { theme.syntax.object }
  hl_groups['CmpItemKindClass']  = { theme.syntax.type }
  hl_groups['CmpItemKindInterface']  = { theme.syntax.type }
  hl_groups['CmpItemKindModule']  = { theme.syntax.keyword }
  hl_groups['CmpItemKindProperty']  = { theme.syntax.keyword }
  hl_groups['CmpItemKindUnit']  = { theme.syntax.constant }
  hl_groups['CmpItemKindValue']  = { theme.syntax.constant }
  hl_groups['CmpItemKindEnum']  = { theme.syntax.constant }
  hl_groups['CmpItemKindKeyword']  = { theme.syntax.keyword }
  hl_groups['CmpItemKindSnippet']  = { theme.syntax.macro }
  hl_groups['CmpItemKindColor']  = { theme.syntax.constant }
  hl_groups['CmpItemKindFile']  = { theme.syntax.type }
  hl_groups['CmpItemKindReference']  = { theme.fg0 }
  hl_groups['CmpItemKindFolder']  = { theme.syntax.type }
  hl_groups['CmpItemKindEnumMember']  = { theme.syntax.constant }
  hl_groups['CmpItemKindConstant']  = { theme.syntax.constant }
  hl_groups['CmpItemKindStruct']  = { theme.syntax.type }
  hl_groups['CmpItemKindEvent']  = { theme.syntax.keyword }
  hl_groups['CmpItemKindOperator']  = { link = "Operator" }
  hl_groups['CmpItemKindTypeParameter']  = { theme.syntax.type }

  hl_groups['CmpItemAbbrDeprecated'] = { link = "Comment" }

  hl_groups['CmpItemAbbrMatch']      = { link = "Search" }
  hl_groups['CmpItemAbbrMatchFuzzy'] = { link = "CmpItemAbbrMatch" }

  -- lukas-reineke/indent-blankline.nvim
  hl_groups['@ibl.indent.char.1'] = { theme.bg2, nocombine = true }
  hl_groups['@ibl.indent.char.2'] = { theme.colors.red, nocombine = true }
  hl_groups['@ibl.indent.char.3'] = { theme.bg2, nocombine = true }
  hl_groups['@ibl.indent.char.4'] = { theme.colors.orange, nocombine = true }
  hl_groups['@ibl.indent.char.3'] = { theme.bg2, nocombine = true }
  hl_groups['@ibl.indent.char.4'] = { theme.colors.yellow, nocombine = true }
  hl_groups['@ibl.indent.char.5'] = { theme.bg2, nocombine = true }
  hl_groups['@ibl.indent.char.6'] = { theme.colors.green, nocombine = true }
  hl_groups['@ibl.indent.char.7'] = { theme.bg2, nocombine = true }
  hl_groups['@ibl.indent.char.8'] = { theme.colors.aqua, nocombine = true }
  hl_groups['@ibl.indent.char.9'] = { theme.bg2, nocombine = true }
  hl_groups['@ibl.indent.char.10'] = { theme.colors.blue, nocombine = true }
  hl_groups['@ibl.indent.char.11'] = { theme.bg2, nocombine = true }
  hl_groups['@ibl.indent.char.12'] = { theme.colors.purple, nocombine = true }

  -- simrat39/symbols-outline.nvim
  hl_groups['FocusedSymbol'] = { theme.syntax.call }

  if config.override_terminal then
    require 'starfrost.hl.terminal'(theme, theme.colors)
  end

  for hl, override in pairs(config.overrides or {}) do
    if hl_groups[hl] and not vim.tbl_isempty(override) then
      hl_groups[hl].link = nil
    end
    hl_groups[hl] = vim.tbl_deep_extend("force", hl_groups[hl] or {}, override)
  end

  return hl_groups
end

return M
