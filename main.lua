-- 147.185.221.20:60573

Lume = require "lume"
local socket = require("socket")
require("server")
require("client")
local mode = nil
Server = {}
Client = {}
local serverPort = 60573
local serverip = 'localhost'
SendRate = 0.01 

function love.load()
    print("Press 1 to host as server, 2 to connect as client")
end

function love.keypressed(key)
    if key == "1" and not mode then
        -- Setup server
        love.mouse.setVisible( false )
        mode = "server"
        Server.tcp = socket.bind("*", serverPort)
        Server.tcp:settimeout(0)
        print("Server started on port " .. serverPort)
    elseif key == "2" and not mode then
        -- Setup client
        love.mouse.setVisible( false )
        mode = "client"
        Client.tcp = socket.connect(serverip, serverPort)
        Client.tcp:settimeout(0)
        print("Connected to server on port " .. serverPort)
        
    end
end


function love.update(dt)
    if mode == "server" then
        ServerUpdate(dt)
    elseif mode == "client" then
        ClientUpdate(dt)
    end
end


function love.draw()
    if mode == "server" then
        ServerDraw()
    elseif mode == "client" then
        ClientDraw()
    else
        love.graphics.print("Select mode: 1 for server, 2 for client", 10, 10)
    end
end


