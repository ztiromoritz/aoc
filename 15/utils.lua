function dump(o)
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
end

function dump_2d(t)
    local s=''
    for i,l in ipairs(t) do
        s= s .. table.concat(l,' ') .. '\n'
    end
    return s
end

function dump_1d(t)
    local s='{\n'
    for i,l in pairs(t) do
        s= s .. "  "..i ..":".. l .. '\n'
    end
    s=s..'}'
    return s
end