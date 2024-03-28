---@param theme starfrost.types.theme
---@param config starfrost.types.config
---@return starfrost.types.hlgroups
return function(theme, config)
  return {
    ['@tag.svelte'] = { link = "@tag.html" },
    ['@tag.delimiter.svelte'] = { link = "@tag.delimiter.html" },
    ['@tag.attribute.svelte'] = { link = "@tag.attribute.html" },
    ['@string.svelte'] = { link = "@string.html" },
  }
end
