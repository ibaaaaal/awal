--[[ 
    FISH IT ULTIMATE - MOBILE / DELTA VERSION
    Fitur: Instant Win & Auto Tool Activate (Pengganti Klik Mouse)
]]

local Library = {}
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local Config = {
    InstantWin = false,
    DelayWin = 0.5,
    
    AutoCast = false,   -- Di HP, ini akan spam "Activate Tool"
    LoopDelay = 2.0
}

function Library:CreateGUI()
    for _, v in pairs(CoreGui:GetChildren()) do
        if v.Name == "FishItMobileGUI" then v:Destroy() end
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FishItMobileGUI"
    if gethui then ScreenGui.Parent = gethui() else ScreenGui.Parent = CoreGui end

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 200, 0, 180) -- Ukuran pas buat HP
    MainFrame.Position = UDim2.new(0.1, 0, 0.2, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    MainFrame.Active = true
    MainFrame.Draggable = true -- Bisa digeser pake jari
    MainFrame.Parent = ScreenGui

    local Title = Instance.new("TextLabel")
    Title.Text = "FISH IT - MOBILE"
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.white
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 16
    Title.Parent = MainFrame

    -- TOMBOL INSTANT WIN
    local BtnInstant = Instance.new("TextButton")
    BtnInstant.Size = UDim2.new(0.9, 0, 0, 40)
    BtnInstant.Position = UDim2.new(0.05, 0, 0, 40)
    BtnInstant.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    BtnInstant.Text = "Instant Win: OFF"
    BtnInstant.TextColor3 = Color3.white
    BtnInstant.Font = Enum.Font.GothamBold
    BtnInstant.TextSize = 14
    BtnInstant.Parent = MainFrame
    
    BtnInstant.MouseButton1Click:Connect(function()
        Config.InstantWin = not Config.InstantWin
        if Config.InstantWin then
            BtnInstant.Text = "Instant Win: ON"
            BtnInstant.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        else
            BtnInstant.Text = "Instant Win: OFF"
            BtnInstant.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        end
    end)

    -- TOMBOL AUTO CAST (ACTIVATE)
    local BtnCast = Instance.new("TextButton")
    BtnCast.Size = UDim2.new(0.9, 0, 0, 40)
    BtnCast.Position = UDim2.new(0.05, 0, 0, 90)
    BtnCast.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    BtnCast.Text = "Auto Cast (HP): OFF"
    BtnCast.TextColor3 = Color3.white
    BtnCast.Font = Enum.Font.GothamBold
    BtnCast.TextSize = 14
    BtnCast.Parent = MainFrame

    BtnCast.MouseButton1Click:Connect(function()
        Config.AutoCast = not Config.AutoCast
        if Config.AutoCast then
            BtnCast.Text = "Auto Cast (HP): ON"
            BtnCast.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        else
            BtnCast.Text = "Auto Cast (HP): OFF"
            BtnCast.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
        end
    end)

    -- TOMBOL TUTUP
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Text = "X"
    CloseBtn.Size = UDim2.new(0, 30, 0, 30)
    CloseBtn.Position = UDim2.new(1, -30, 0, 0)
    CloseBtn.BackgroundColor3 = Color3.red
    CloseBtn.Parent = MainFrame
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
end

Library:CreateGUI()

-- LOGIC 1: INSTANT WIN (Mobile Friendly)
local RemoteFinish = nil
for _, v in pairs(ReplicatedStorage:GetDescendants()) do 
    if v.Name == "RE/FishingCompleted" then RemoteFinish = v break end 
end

local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if method == "InvokeServer" and self.Name == "RF/RequestFishingMinigameStarted" then
        if Config.InstantWin then 
            local results = {oldNamecall(self, unpack(args))}
            task.spawn(function()
                task.wait(Config.DelayWin) 
                if RemoteFinish then RemoteFinish:FireServer() end
            end)
            return unpack(results)
        end
    end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- LOGIC 2: AUTO CAST KHUSUS HP (Tool Activate)
task.spawn(function()
    while true do
        if Config.AutoCast then
            if LocalPlayer.Character then
                local Tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if Tool then
                    Tool:Activate() -- Cara klik paling aman di HP
                end
            end
            task.wait(Config.LoopDelay)
        else
            task.wait(1)
        end
    end
end)