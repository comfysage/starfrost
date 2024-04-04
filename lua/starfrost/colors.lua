---@class starfrost.types.color { [1]: string, [2]: number }

---@alias starfrost.types.colors.enum 'bg0_hard'|'bg0_soft'|'bg0'|'bg1'|'bg2'|'bg3'|'bg4'|'bg_red'|'bg_green'|'bg_blue'|'bg_yellow'|'fg'|'red'|'orange'|'yellow'|'green'|'aqua'|'jade'|'blue'|'sage'|'purple'|'grey0'|'grey1'|'grey2'
---@alias starfrost.types.colors { [starfrost.types.colors.enum]: starfrost.types.color }

---@type starfrost.types.colors
_G.starfrost_colors = {
  bg0_hard    = { "#1E2129", 0 },
  bg0         = { "#272B33", 0 },
  bg0_soft    = { "#2F333D", 0 },
  bg1         = { "#323842", 8 },
  bg2         = { "#414A57", 8 },
  bg3         = { "#4E5861", 8 },
  bg4         = { "#5A636B", 8 },
  fg          = { "#BEC2CC", 7 },
  red         = { "#C97373", 1 },
  orange      = { "#D79E7D", 11 },
  yellow      = { "#E3BF88", 3 },
  green       = { "#B3C2A3", 2 },
  aqua        = { "#9FBDA9", 6 },
  jade        = { "#89ADA9", 14 },
  blue        = { "#8FACC2", 4 },
  sage        = { "#8F9FC2", 12 },
  purple      = { "#AD9BC2", 5 },
  grey0       = { "#787C84", 8 },
  grey1       = { "#747C8E", 15 },
}

local M = {}

function M.colors()
  return _G.starfrost_colors
end

---@param config starfrost.types.config?
---@return starfrost.types.theme
function M.setup(config)
  ---@type starfrost.types.config
  config = vim.tbl_extend("force", _G.starfrost_config, config or {})
  return require 'starfrost.theme'.setup(M.colors(), config)
end

return M
