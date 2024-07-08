local sendTimerClient = 0
local serverInfo = {
    cursorX = 0,
    cursorY = 0,
}
local selfClientCursorX, selfClientCursorY

local function updateClientState(dt)
    if Client.tcp then
        local data, err = Client.tcp:receive()
        if data then
            local serverCursor = Lume.deserialize(data)
            if serverCursor.x and serverCursor.y then
            serverInfo.cursorX = serverCursor.x
            serverInfo.cursorY = serverCursor.y
			end
        end
    end
end

local function sendMousePosition()
    local clientCursor = {}
    clientCursor.x, clientCursor.y = love.mouse.getPosition()
    local msg = Lume.serialize(clientCursor)
        Client.tcp:send(msg .. "\n")
end

function ClientUpdate(dt)
        selfClientCursorX, selfClientCursorY = love.mouse.getPosition()

        updateClientState(dt)
        sendTimerClient = sendTimerClient + dt
        if sendTimerClient >= SendRate then
            sendMousePosition()
            sendTimerClient = sendTimerClient - SendRate
        end
end

function ClientDraw()
        love.graphics.print("Client mode", 10, 10)
        love.graphics.clear(0.1, 0.1, 0.1)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Sending mouse position to server: " .. tostring(Client.tcp:getpeername()), 10, 10)
        love.graphics.setColor(0, 1, 0)
        love.graphics.circle("fill", selfClientCursorX, selfClientCursorY, 10)
        if serverInfo.cursorX and serverInfo.cursorY then
            love.graphics.setColor(1, 0, 0)
            love.graphics.circle("fill", serverInfo.cursorX, serverInfo.cursorY, 10)
        end
end