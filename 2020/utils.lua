local utils =  {}

function utils.split(inputstr, sep)
  if sep == nil then
    sep = '%s'
  end
  local result = {}
  for str in string.gmatch(inputstr, '([^'..sep..']+)') do
    table.insert(result, str)
  end
  return table.unpack(result)
end

return utils
