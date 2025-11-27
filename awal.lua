--[[ 
    FISH IT ULTIMATE - V6 DELTA GUI FIX
    Fix: ZIndex Force Layering (Anti Black Screen)
    Features: All V6 Features (Mobile Support)
]]

local Library = {}
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- // KONFIGURASI // --
local Config = {
    InstantWin = false, DelayWin = 0.5,
    AutoCast = false, HoldTime = 0.1, LoopDelay = 2.0,
    AutoClick = false, ClickMS = 100
}

-- // UI MAKER (ZINDEX EXTREME FIX) \\ --
function Library:CreateGUI()
    for _, v in pairs(CoreGui:GetChildren()) do
        if v.Name == "FishItDeltaFix" then v:Destroy() end
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FishItDeltaFix"
    -- Cek parent terbaik buat Delta
    if gethui then ScreenGui.Parent = gethui() else ScreenGui.Parent = CoreGui end

    -- MAIN FRAME (LAYER PALING BAWAH: 1)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 260, 0, 250)
    MainFrame.Position = UDim2.new(0.5, -130, 0.5, -125)
    MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
    MainFrame.BorderSizePixel = 2
    MainFrame.BorderColor3 = Color3.fromRGB(0, 150, 255)
    MainFrame.ZIndex = 1 -- BACKGROUND WAJIB 1
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    -- JUDUL (LAYER ATAS: 10)
    local Title = Instance.new("TextLabel")
    Title.Text = "FISH IT - V6 DELTA"
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    Title.TextColor3 = Color3.white
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 16
    Title.ZIndex = 10 -- TULISAN WAJIB DIATAS
    Title.Parent = MainFrame

    -- CONTAINER (LAYER: 5)
    local function CreateContainer(yPos)
        local C = Instance.new("Frame")
        C.Size = UDim2.new(1, -20, 0, 40)
        C.Position = UDim2.new(0, 10, 0, yPos)
        C.BackgroundTransparency = 1
        C.ZIndex = 5
        C.Parent = MainFrame
        return C
    end

    -- [[ FITUR 1: INSTANT WIN ]]
    local C1 = CreateContainer(40)
    
    local L1 = Instance.new("TextLabel")
    L1.Text = "Instant Win"
    L1.Size = UDim2.new(0, 90, 1, 0)
    L1.BackgroundTransparency = 1
    L1.TextColor3 = Color3.white
    L1.TextXAlignment = Enum.TextXAlignment.Left
    L1.ZIndex = 10
    L1.Parent = C1

    local Box1 = Instance.new("TextBox")
    Box1.Size = UDim2.new(0, 40, 0, 25)
    Box1.Position = UDim2.new(0, 95, 0.5, -12)
    Box1.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Box1.Text = tostring(Config.DelayWin)
    Box1.TextColor3 = Color3.fromRGB(255, 255, 0)
    Box1.ZIndex = 10
    Box1.Parent = C1
    
    Box1:GetPropertyChangedSignal("Text"):Connect(function()
        local num = tonumber(Box1.Text:gsub(",", "."))
        if num then Config.DelayWin = num end
    end)

    local Btn1 = Instance.new("TextButton")
    Btn1.Text = "OFF"
    Btn1.Size = UDim2.new(0, 50, 0, 25)
    Btn1.Position = UDim2.new(1, -55, 0.5, -12)
    Btn1.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    Btn1.TextColor3 = Color3.white
    Btn1.ZIndex = 10
    Btn1.Parent = C1

    Btn1.MouseButton1Click:Connect(function()
        Config.InstantWin = not Config.InstantWin
        Btn1.Text = Config.InstantWin and "ON" or "OFF"
        Btn1.BackgroundColor3 = Config.InstantWin and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    end)

    -- [[ FITUR 2: AUTO CAST ]]
    local C2 = CreateContainer(80)
    
    local L2 = Instance.new("TextLabel")
    L2.Text = "Auto Cast"
    L2.Size = UDim2.new(0, 90, 1, 0)
    L2.BackgroundTransparency = 1
    L2.TextColor3 = Color3.white
    L2.TextXAlignment = Enum.TextXAlignment.Left
    L2.ZIndex = 10
    L2.Parent = C2

    local Btn2 = Instance.new("TextButton")
    Btn2.Text = "OFF"
    Btn2.Size = UDim2.new(0, 50, 0, 25)
    Btn2.Position = UDim2.new(1, -55, 0.5, -12)
    Btn2.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    Btn2.TextColor3 = Color3.white
    Btn2.ZIndex = 10
    Btn2.Parent = C2

    Btn2.MouseButton1Click:Connect(function()
        Config.AutoCast = not Config.AutoCast
        Btn2.Text = Config.AutoCast and "ON" or "OFF"
        Btn2.BackgroundColor3 = Config.AutoCast and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    end)

    -- Sub Settings Cast (Hold & Loop)
    local C2_Sub = CreateContainer(115) -- Baris baru dibawahnya
    
    local BoxHold = Instance.new("TextBox")
    BoxHold.PlaceholderText = "Hold"
    BoxHold.Size = UDim2.new(0, 40, 0, 25)
    BoxHold.Position = UDim2.new(0, 0, 0, 0)
    BoxHold.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    BoxHold.Text = tostring(Config.HoldTime)
    BoxHold.TextColor3 = Color3.fromRGB(0, 255, 255)
    BoxHold.ZIndex = 10
    BoxHold.Parent = C2_Sub
    BoxHold:GetPropertyChangedSignal("Text"):Connect(function() local n = tonumber(BoxHold.Text:gsub(",", ".")); if n then Config.HoldTime = n end end)

    local L_Hold = Instance.new("TextLabel")
    L_Hold.Text = "Hold(s)"
    L_Hold.Size = UDim2.new(0, 40, 0, 25)
    L_Hold.Position = UDim2.new(0, 45, 0, 0)
    L_Hold.BackgroundTransparency = 1
    L_Hold.TextColor3 = Color3.fromRGB(150,150,150)
    L_Hold.TextXAlignment = Enum.TextXAlignment.Left
    L_Hold.ZIndex = 10
    L_Hold.Parent = C2_Sub

    local BoxLoop = Instance.new("TextBox")
    BoxLoop.PlaceholderText = "Delay"
    BoxLoop.Size = UDim2.new(0, 40, 0, 25)
    BoxLoop.Position = UDim2.new(0, 110, 0, 0)
    BoxLoop.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    BoxLoop.Text = tostring(Config.LoopDelay)
    BoxLoop.TextColor3 = Color3.fromRGB(255, 100, 100)
    BoxLoop.ZIndex = 10
    BoxLoop.Parent = C2_Sub
    BoxLoop:GetPropertyChangedSignal("Text"):Connect(function() local n = tonumber(BoxLoop.Text:gsub(",", ".")); if n then Config.LoopDelay = n end end)

    local L_Loop = Instance.new("TextLabel")
    L_Loop.Text = "Jeda(s)"
    L_Loop.Size = UDim2.new(0, 40, 0, 25)
    L_Loop.Position = UDim2.new(0, 155, 0, 0)
    L_Loop.BackgroundTransparency = 1
    L_Loop.TextColor3 = Color3.fromRGB(150,150,150)
    L_Loop.TextXAlignment = Enum.TextXAlignment.Left
    L_Loop.ZIndex = 10
    L_Loop.Parent = C2_Sub


    -- [[ FITUR 3: AUTO CLICKER ]]
    local C3 = CreateContainer(160)
    
    local L3 = Instance.new("TextLabel")
    L3.Text = "Clicker (ms)"
    L3.Size = UDim2.new(0, 90, 1, 0)
    L3.BackgroundTransparency = 1
    L3.TextColor3 = Color3.white
    L3.TextXAlignment = Enum.TextXAlignment.Left
    L3.ZIndex = 10
    L3.Parent = C3

    local Box3 = Instance.new("TextBox")
    Box3.Size = UDim2.new(0, 40, 0, 25)
    Box3.Position = UDim2.new(0, 95, 0.5, -12)
    Box3.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Box3.Text = tostring(Config.ClickMS)
    Box3.TextColor3 = Color3.fromRGB(0, 255, 0)
    Box3.ZIndex = 10
    Box3.Parent = C3
    Box3:GetPropertyChangedSignal("Text"):Connect(function() local n = tonumber(Box3.Text:gsub(",", ".")); if n then Config.ClickMS = n end end)

    local Btn3 = Instance.new("TextButton")
    Btn3.Text = "OFF"
    Btn3.Size = UDim2.new(0, 50, 0, 25)
    Btn3.Position = UDim2.new(1, -55, 0.5, -12)
    Btn3.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    Btn3.TextColor3 = Color3.white
    Btn3.ZIndex = 10
    Btn3.Parent = C3

    Btn3.MouseButton1Click:Connect(function()
        Config.AutoClick = not Config.AutoClick
        Btn3.Text = Config.AutoClick and "ON" or "OFF"
        Btn3.BackgroundColor3 = Config.AutoClick and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    end)

    -- CLOSE BUTTON
    local Close = Instance.new("TextButton")
    Close.Text = "X"
    Close.Size = UDim2.new(0, 30, 0, 30)
    Close.Position = UDim2.new(1, -30, 0, 0)
    Close.BackgroundColor3 = Color3.red
    Close.TextColor3 = Color3.white
    Close.ZIndex = 20 -- PALING ATAS
    Close.Parent = MainFrame
    Close.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
end

Library:CreateGUI()

-- =================================================================
-- LOGIKA (HP FIX + NO ERROR)
-- =================================================================

local function GetRemote(name)
    for _, v in pairs(ReplicatedStorage:GetDescendants()) do if v.Name == name then return v end end
    return nil
end
local RemoteFinish = GetRemote("RE/FishingCompleted")

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

-- HELPER: ACTIVATE TOOL (HP TAP)
local function ActivateTool()
    if LocalPlayer.Character then
        local t = LocalPlayer.Character:FindFirstChildOfClass("Tool")
        if t then t:Activate() end
    end
end

-- AUTO CAST LOOP
task.spawn(function()
    while true do
        if Config.AutoCast then
            ActivateTool()
            task.wait(Config.LoopDelay)
        else
            task.wait(1)
        end
    end
end)

-- AUTO CLICKER LOOP
task.spawn(function()
    while true do
        if Config.AutoClick then
            ActivateTool()
            
            -- FALLBACK PC (VirtualInput) - Pakai pcall biar ga error di HP
            pcall(function()
                VirtualInputManager:SendMouseButtonEvent(0,0, 0, true, game, 1)
                VirtualInputManager:SendMouseButtonEvent(0,0, 0, false, game, 1)
            end)
            
            task.wait(Config.ClickMS / 1000)
        else
            task.wait(1)
        end
    end
end)

-- ANTI IDLE
LocalPlayer.Idled:Connect(function()
    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
        task.wait()
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
    end)
end)

print("✅ GUI ZINDEX FIXED")
