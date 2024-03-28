---@param theme starfrost.types.theme
---@param config starfrost.types.config
---@return starfrost.types.hlgroups
return function(theme, config)
  return {
    ['@tag.html'] = { theme.syntax.keyword },
    ['@tag.delimiter.html'] = { theme.syntax.context },
    ['@tag.attribute.html'] = { theme.fg0 },
    ['@string.html'] = { theme.sukai },
  }
end
