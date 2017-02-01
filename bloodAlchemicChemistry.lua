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

function tryMoveTo(sourceSide, sinkSide, count, sinkSlot)
    for i = 1, 27 do
        if transposer.getStackInSlot(sourceSide, i) ~= nil then
            local moveResult = move(sourceSide, sinkSide, count, i, sinkSlot)
            if moveResult == true then
                return true
            end
        end
    end
    return false
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
        for targetSlot = 2, 6 do
            tryMoveTo(IN_P, SET_P, 1, targetSlot)
        end
        checkInventory(TRANS_P)
        repeat
            move(SET_P, OUT_P, 64, 7)
        until transposer.getStackInSlot(IN_P, 1) ~= nil
        for waitTick = 1, 60 do
            move(SET_P, OUT_P, 64, 7)
        end
        for transCount = 2, 6 do
            pcall(tryMoveTo, IN_P, TRANS_P, 1, transCount - 1)
        end
        --        repeat
        --        until transposer.getStackInSlot(SET_P, 7) ~= nil
        --note: can not move out items from slot 2~6
        --so it's impossible to automate recipe using water/lave bucket since they will left empty bucket in slot
    end
end

run()


