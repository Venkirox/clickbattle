sendTimerClient = 0
otherClients = {}
serverInfo = {
    cursorX = 0,
    cursorY = 0,
}

function clientLoad()
    
end

function updateClientState(dt)
    if client.tcp then
        local data, err = client.tcp:receive()
        if data then
            -- local receivedServerCursorX, receivedServerCursorY = data:match("([^,]+),([^,]+)")
            local serverCursor = lume.deserialize(data)
            if serverCursor.x and serverCursor.y then
			-- 	receivedServerCursorX = tonumber(receivedServerCursorX)
			-- 	receivedServerCursorY = tonumber(receivedServerCursorY)
            --     serverInfo.cursorX  = receivedServerCursorX
            --     serverInfo.cursorY = receivedServerCursorY
            serverInfo.cursorX = serverCursor.x
            serverInfo.cursorY = serverCursor.y
			end
        end
    end
end

function sendMousePosition()
    -- local clientCursorX, clientCursorY = love.mouse.getPosition()
    -- local msg = tostring(clientCursorX) .. "," .. tostring(clientCursorY)
    local clientCursor = {}
    clientCursor.X, clientCursor.Y = love.mouse.getPosition()
    local msg = lume.serialize(clientCursor)
        client.tcp:send(msg .. "\n")
end

function clientUpdate(dt)
        selfClientCursorX, selfClientCursorY = love.mouse.getPosition()

        updateClientState(dt)
        sendTimerClient = sendTimerClient + dt
        if sendTimerClient >= sendRate then
            sendMousePosition()
            sendTimerClient = sendTimerClient - sendRate
        end
end

function clientDraw()
        love.graphics.print("Client mode", 10, 10)
        love.graphics.clear(0.1, 0.1, 0.1)
        love.graphics.setColor(1, 1, 1)
        love.graphics.print("Sending mouse position to server: " .. tostring(client.tcp:getpeername()), 10, 10)
        -- Draw mouse positions
        love.graphics.setColor(0, 1, 0)
        love.graphics.circle("fill", selfClientCursorX, selfClientCursorY, 10)
        if serverInfo.cursorX and serverInfo.cursorY then
            love.graphics.setColor(1, 0, 0)
            love.graphics.circle("fill", serverInfo.cursorX, serverInfo.cursorY, 10)
        end
end