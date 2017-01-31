local component = require('component')
local sides = require('sides')
local transposer = component.transposer

--me interface blocking mode should be set to 'do not push'
--alchemic chemistry set/input chest/output chest position relative to transposer
local SET_P = sides.down
local IN_P = sides.east
local OUT_P = sides.up
local TRANS_P = sides.west
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

function run()
    while 1 do
        repeat
        until transposer.getStackInSlot(IN_P, 1) ~= nil
        for targetSlot = 2, 6 do
            local moveResult = tryMoveTo(IN_P, SET_P, 1, targetSlot)
            if moveResult == false then
                break
            end
        end
        for transCount = 2, 6 do
            tryMoveTo(IN_P, TRANS_P, 1, transCount - 1)
        end
--        repeat
--        until transposer.getStackInSlot(SET_P, 7) ~= nil
        --note: can not move out items from slot 2~6
        --so it's impossible to automate recipe using water/lave bucket since they will left empty bucket in slot
        move(SET_P, OUT_P, 64, 7)
    end
end

run()


