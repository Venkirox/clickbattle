local sendTimerServer = 0
local serverCursorX, serverCursorY
local clients = {}

local function broadcastServerState()
	local serverCursor = {x = serverCursorX, y = serverCursorY}
	local msg = Lume.serialize(serverCursor)
    for _, client in ipairs(clients) do
        client.socket:send(msg .. "\n")
    end
end

function ServerUpdate(dt)
	local clientInfo = Server.tcp:accept()
	if clientInfo then
		clientInfo:settimeout(0)
		local newClient = {
			socket = clientInfo,
			clientCursorX = 0,
			clientCursorY = 0,
		}
		table.insert(clients, newClient)
		print("New client connected")
	end

	for i = #clients, 1, -1 do
		client = clients[i]
		local data, err = client.socket:receive()
        sendTimerServer = sendTimerServer + dt
        if sendTimerServer >= SendRate then
            broadcastServerState()
            sendTimerServer = 0
        end
		if data then
			local clientCursor = Lume.deserialize(data)
				client.clientCursorX = clientCursor.x
				client.clientCursorY = clientCursor.y
		elseif err == "closed" then
			print("Client " .. i .. " disconnected")
			table.remove(clients, i)
		end
	end
	serverCursorX, serverCursorY = love.mouse.getPosition()
end

function ServerDraw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Server mode", 10, 10)
	love.graphics.print("Clients connected: " .. #clients, 10, 30)

	for i, client in ipairs(clients) do
		if client.clientCursorX and client.clientCursorY then
			love.graphics.setColor(0, 1, 0)
			love.graphics.circle("fill", client.clientCursorX, client.clientCursorY, 10)
		end
	end
	love.graphics.setColor(1, 0, 0)
	love.graphics.circle("fill", serverCursorX, serverCursorY, 10)
end