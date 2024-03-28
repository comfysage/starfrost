---@class starfrost.types.styleconfig
---@field tabline { reverse: boolean, color: starfrost.types.colors.enum }
---@field search { reverse: boolean, inc_reverse: boolean }
---@field types { italic: boolean }
---@field keyword { italic: boolean }
---@field comment { italic: boolean }

---@class starfrost.types.theme
---@field none starfrost.types.color
---@field colors starfrost.types.colors
---@field base { fg: starfrost.types.color, bg: starfrost.types.color }
---@field bg starfrost.types.color
---@field fg starfrost.types.color
---@field bg0 starfrost.types.color
---@field bg1 starfrost.types.color
---@field bg2 starfrost.types.color
---@field bg3 starfrost.types.color
---@field fg0 starfrost.types.color
---@field fg1 starfrost.types.color
---@field fg2 starfrost.types.color
---@field sakura  starfrost.types.color
---@field sage    starfrost.types.color
---@field sukai   starfrost.types.color
---@field shinme  starfrost.types.color
---@field sakaeru starfrost.types.color
---@field taiyo starfrost.types.color
---@field seiun   starfrost.types.color
---@field ike     starfrost.types.color
---@field jade     starfrost.types.color
---@field syntax starfrostSyntax
---@field diagnostic { ['ok'|'error'|'warn'|'info'|'hint']: starfrost.types.color }
---@field diff { ['add'|'delete'|'change']: starfrost.types.color }
---@field style starfrost.types.styleconfig
---@field sign starfrost.types.color
---@field comment starfrost.types.color
---@field bg_accent starfrost.types.color
---@field fg_accent starfrost.types.color

---@class starfrostSyntax
---@field keyword starfrost.types.color
---@field object starfrost.types.color
---@field type starfrost.types.color
---@field context starfrost.types.color
---@field constant starfrost.types.color
---@field call starfrost.types.color
---@field string starfrost.types.color
---@field macro starfrost.types.color
---@field annotation starfrost.types.color

local M = {}

---@param colors starfrost.types.colors
---@param config starfrost.types.config
---@return starfrost.types.theme
function M.setup(colors, config)
  local theme   = {}

  theme.none    = { 'NONE', 0 }
  theme.colors  = colors

  theme.bg      = theme.none
  if not config.transparent_background then
    theme.bg = colors.bg0
    if config.contrast_dark == 'hard' then
      theme.bg = colors.bg0_hard
    end
    if config.contrast_dark == 'soft' then
      theme.bg = colors.bg0_soft
    end
  end
  theme.base    = { fg = colors.bg0, bg = theme.bg }
  theme.fg      = colors.fg

  theme.bg0     = colors.bg0
  theme.bg1     = colors.bg1
  theme.bg2     = colors.bg2
  theme.bg3     = colors.bg3

  theme.fg0     = colors.grey0
  theme.fg1     = colors.fg
  theme.fg2     = colors.grey1

  local sign_colors = { soft = theme.bg3 }
  theme.sign      = sign_colors[config.contrast_dark] or theme.none
  theme.comment   = theme.fg2
  theme.bg_accent = theme.bg1
  theme.fg_accent = colors.bg4

  theme.ike     = colors.aqua
  theme.jade    = colors.jade
  theme.shinme  = colors.green
  theme.sakura  = colors.red
  theme.taiyo   = colors.orange
  theme.sakaeru = colors.yellow
  theme.sukai   = colors.blue
  theme.sage    = colors.sage
  theme.seiun   = colors.purple

  theme.syntax  = {
    keyword = theme.seiun,
    object = theme.fg1,
    type = theme.ike,
    context = theme.fg0,
    constant = theme.seiun,
    call = theme.jade,
    string = theme.shinme,
    macro = theme.sage,
    annotation = theme.sage,
  }
  theme.diagnostic = {
    ok = theme.shinme,
    error = theme.sakura,
    warn = theme.sakaeru,
    info = theme.sage,
    hint = theme.sukai,
  }
  theme.diff = {
    add = theme.shinme,
    delete = theme.sakura,
    change = theme.sage,
  }

  theme.style = {
    search = { reverse = true }
  }
  theme.style = vim.tbl_deep_extend('force', theme.style, config.style)

  return theme
end

return M
