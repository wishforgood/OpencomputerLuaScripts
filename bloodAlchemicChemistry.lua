local sides = {
    down = 0,
    up = 1,
    north = 2,
    south = 3,
    west = 4,
    east = 5,
}


local transposer = component.proxy(component.list('transposer')())

--me interface blocking mode should be set to 'do not push'
--alchemic chemistry set/input chest/output chest position relative to transposer
local SET_P = sides.down
local IN_P = sides.west
local OUT_P = sides.up
local TRANS_P = sides.east
local move = transposer.transferItem

function tryMoveTo(sourceSide, sinkSide, count, trans)
    local sourceCount = 1
    for moveCount = 2, 6 do
        local itemTable = transposer.getStackInSlot(sourceSide, sourceCount)
        if itemTable ~= nil then
            if trans == false then
                move(sourceSide, sinkSide, count, sourceCount, moveCount)
            else
                move(sourceSide, sinkSide, count, sourceCount, moveCount - 1)
            end
            if itemTable.size ~= 1 then
                sourceCount = sourceCount - 1
            end
        end
        sourceCount = sourceCount + 1
    end
end

function checkInventory(targetSide)
    for i = 1, 27 do
        repeat
        until transposer.getStackInSlot(targetSide, i) == nil
    end
end

function run()
    while 1 do
        repeat
            move(SET_P, OUT_P, 64, 7)
        until transposer.getStackInSlot(IN_P, 1) ~= nil
        for waitTick = 1, 60 do
            move(SET_P, OUT_P, 64, 7)
        end
        tryMoveTo(IN_P, SET_P, 1, false)
        checkInventory(TRANS_P)
        repeat
            move(SET_P, OUT_P, 64, 7)
        until transposer.getStackInSlot(IN_P, 1) ~= nil
        for waitTick = 1, 60 do
            move(SET_P, OUT_P, 64, 7)
        end
        pcall(function()
            tryMoveTo(IN_P, TRANS_P, 1, true)
        end)
        --        repeat
        --        until transposer.getStackInSlot(SET_P, 7) ~= nil
        --note: can not move out items from slot 2~6
        --so it's impossible to automate recipe using water/lave bucket since they will left empty bucket in slot
    end
end

run()


