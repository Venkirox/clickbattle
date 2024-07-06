-- 147.185.221.20:60573

lume = require "lume"
local socket = require("socket")
require("server")
require("client")
local mode = nil -- 'server' or 'client'
server = {}
client = {}
clients = {}
serverPort = 60573
serverip = 'localhost'
sendRate = 0.01  -- Send mouse position every x milliseconds

function love.load()
    print("Press 1 to host as server, 2 to connect as client")
end

function love.keypressed(key)
    if key == "1" and not mode then
        -- Setup server
        love.mouse.setVisible( false )
        mode = "server"
        server.tcp = socket.bind("*", serverPort)
        server.tcp:settimeout(0)
        print("Server started on port " .. serverPort)
    elseif key == "2" and not mode then
        -- Setup client
        love.mouse.setVisible( false )
        mode = "client"
        client.tcp = socket.connect(serverip, serverPort)
        client.tcp:settimeout(0)
        print("Connected to server on port " .. serverPort)
        
    end
end


function love.update(dt)
    if mode == "server" then
        serverUpdate(dt)
    elseif mode == "client" then
        clientUpdate(dt)
    end
end


function love.draw()
    if mode == "server" then
        serverDraw()
    elseif mode == "client" then
        clientDraw()
    else
        love.graphics.print("Select mode: 1 for server, 2 for client", 10, 10)
    end
end


