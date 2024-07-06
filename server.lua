sendTimerServer = 0
clientId = 0

function serverLoad()
    
end

function broadcastServerState()
	-- Send server mouse position from server to all clients
    local msg = tostring(serverCursorX) .. "," .. tostring(serverCursorY)
    for _, client in ipairs(clients) do
        client.socket:send(msg .. "\n")
    end
end

function serverUpdate(dt)
        -- Accept new clients
	local clientInfo = server.tcp:accept()
	if clientInfo then
		clientInfo:settimeout(0)
		clientId = clientId + 1
		local newClient = {
			socket = clientInfo,
			clientCursorX = 0,
			clientCursorY = 0,
			-- id = clientId,
			-- size = 10
		}
		table.insert(clients, newClient)
		print("New client connected")

		-- Send welcome message to the new client
		newClient.socket:send("Hello, this is the server!\n")
	end

	-- Handle incoming data from clients
	for i = #clients, 1, -1 do
		local clientInfo = clients[i]
		local data, err = clientInfo.socket:receive()
        sendTimerServer = sendTimerServer + dt
		-- Send server state to clients
        if sendTimerServer >= sendRate then
            broadcastServerState()
            sendTimerServer = 0
        end
		if data then
			local clientCursor = lume.deserialize(data)
			print(clientCursor.X, clientCursor.Y)
				clientInfo.clientCursorX = clientCursor.X
				clientInfo.clientCursorY = clientCursor.Y
		elseif err == "closed" then
			print("Client " .. i .. " disconnected")
			table.remove(clients, i)
		end
	end
	-- Get mouse position from server
	serverCursorX, serverCursorY = love.mouse.getPosition()
end

function serverDraw()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("Server mode", 10, 10)
	love.graphics.print("Clients connected: " .. #clients, 10, 30)

	-- Draw client mouse positions
	for i, client in ipairs(clients) do
		if client.clientCursorX and client.clientCursorY then
			love.graphics.setColor(0, 1, 0)
			love.graphics.circle("fill", client.clientCursorX, client.clientCursorY, 10)
			-- love.graphics.print("Client " .. client.id, client.clientCursorX - client.size, client.clientCursorY + 20)
		end
	end
	-- Draw server mouse position
	love.graphics.setColor(1, 0, 0)
	love.graphics.circle("fill", serverCursorX, serverCursorY, 10)
end