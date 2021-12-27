require('utils')

function loadData()
    local data = {}
    local lines = love.filesystem.lines("15.input.txt")
    local WIDTH = 0
    local HEIGHT = 0
    for line in lines do
        if WIDTH == 0 then
            WIDTH = #line -- -1 because of \n
        end
        HEIGHT = HEIGHT + 1
        local row = {}
        for c in string.gmatch(line, "%d") do
            table.insert(row, c)
        end
        table.insert(data, row)
    end
    --WIDTH=10
    return data, WIDTH, HEIGHT
end

function pos(X, Y)
    return (X - 1) * 6, (Y - 1) * 6
end

function enqueue(t, v)
    insert(t,v,0)
end

function dequeue(t)
    local entry = table.remove(t, #t)
    return entry[1]
end

function _dequeue(t)
    local entry = table.remove(t, 1)
    return entry[1]
end

function insert(t, value, priority)
    if #t == 0 then
        table.insert(t,{value, priority})
    else
        local added = false
        for i = 1, #t, -1 do
            if t[i][2] <= priority then 
                table.insert(t,i+1,{value,priority})
                added = true
                break        
            end
        end 
        if not added then
            table.insert(t,1,{value,priority})
        end
    end
end

function tools(width, height)
    function map2idx(X, Y)
        return (X * (height + 1)) + Y
    end
    function idx2map(index)
        local X = math.floor(index / (height + 1))
        local Y = index % (height + 1)
        return X, Y
    end
    function getNeighbours(X, Y)
        local result = {}
        if X > 1 then
            table.insert(result, {X - 1, Y})
        end
        if X < width then
            table.insert(result, {X + 1, Y})
        end
        if Y > 1 then
            table.insert(result, {X, Y - 1})
        end
        if Y < height then
            table.insert(result, {X, Y + 1})
        end
        return result
    end
    return map2idx, idx2map, getNeighbours
end

--manhatten
function h_m(idxA, idxB)
    
    local XA,YA = idx2map(idxA)
    local XB,YB = idx2map(idxB)
    return 10 * (math.abs(XA-XB)+math.abs(YA-YB));
end


-- A*
tick =
    coroutine.wrap(
    function(data, width, height)
        local frontier = {}
        local came_from = {}
        local path = {}
        local visited = {}
        local cost_so_far = {}
        local state = {
            frontier = frontier,
            visited = visited,
            came_from = came_from,
            done = false,
            path = path,
            cost_so_far = cost_so_far
        }
        local map2idx, idx2map, getNeighbours = tools(width, height)
        local start = map2idx(1, 1)
        local target = map2idx(width, height)
        cost_so_far[start] = 0
        enqueue(frontier, start,0)
        local p = 0
        while #frontier > 0 do
            local current = dequeue(frontier)
            if(current == target) then break end
            local X, Y = idx2map(current)
            local neighbours = getNeighbours(X, Y)
            local cost_current = cost_so_far[current]
            for i, n in pairs(neighbours) do
                n_idx = map2idx(n[1], n[2])
                local cost = cost_current + data[n[2]][n[1]]
                if cost_so_far[n_idx] == nil 
                or cost_so_far[n_idx] > cost  
                then
                    came_from[n_idx] = current
                    cost_so_far[n_idx] = cost
                    insert(frontier, n_idx, cost+h_m(n_idx, target))
                    table.insert(visited, n_idx)
                end
            end
            coroutine.yield(state)
        end

        -- build path
        local target = map2idx(width, height)
        local current = target
        repeat
            table.insert(path, current)
            current = came_from[current]
            coroutine.yield(state)
        until (current == start)
        table.insert(path, start)

        state.done = true
        coroutine.yield(state)
    end
)

function love.load()
    font = love.graphics.newFont("SourceCodePro.ttf", 6)
    love.graphics.setFont(font)
    love.window.setMode(1600, 900, flags)
    love.graphics.setBackgroundColor(1, 1, 1)

    speed = 900
    cam_x = 50
    cam_y = 50

    data, WIDTH, HEIGHT = loadData()
    map2idx, idx2map = tools(WIDTH, HEIGHT)

    state = tick(data, WIDTH, HEIGHT)
end

function love.update(dt)
    if love.keyboard.isDown("up") then
        cam_y = cam_y + speed * dt
    end
    if love.keyboard.isDown("down") then
        cam_y = cam_y - speed * dt
    end
    if love.keyboard.isDown("right") then
        cam_x = cam_x - speed * dt
    end
    if love.keyboard.isDown("left") then
        cam_x = cam_x + speed * dt
    end
    for i = 1,50 do
        if not state.done then
            state = tick(data, WIDTH, HEIGHT)
        end
    end
end

function love.draw()
    --love.graphics.push()
    love.graphics.translate(cam_x, cam_y)
    love.graphics.setColor(1, 0.6, 0.9, 0.3)

    for i, entry in pairs(state.frontier or {}) do 
        local X, Y = idx2map(entry[1])
        local x, y = pos(X, Y)
        -- love.graphics.print(" "..x..":"..y, 0, -40)
        love.graphics.circle("fill", x + 6, y + 13, 10)
    end

    love.graphics.setColor(0.9, 0.2, 0.9, 0.3)
    for i, index in pairs(state.path or {}) do
        local X, Y = idx2map(index)
        local x, y = pos(X, Y)
        -- love.graphics.print(" "..x..":"..y, 0, -40)
        love.graphics.circle("fill", x + 6, y + 13, 10)
    end

    love.graphics.setColor(0.2, 1, 0.2, 0.7)
    for i, index in pairs(state.visited or {}) do
        local X, Y = idx2map(index)
        local x, y = pos(X, Y)
        -- love.graphics.print(" "..x..":"..y, 0, -40)
        love.graphics.circle("fill", x + 6, y + 13, 3)
    end

    love.graphics.setColor(0.3, 0.1, 0.6)
    for Y, row in ipairs(data) do
        for X, c in ipairs(row) do
            local x, y = pos(X, Y)
            love.graphics.print(c, x, y)
        end
    end

    local target = state.path[1]
    love.graphics.print(#state.frontier, -30, 0)
    love.graphics.print(state.cost_so_far[target] or 'nil',0, -30)
end
