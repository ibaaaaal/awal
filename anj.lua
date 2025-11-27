--[[ 
    FISH IT ULTIMATE - V6 FINAL FIX (NO ERROR)
    Fitur: 
    1. Instant Win (Logic Fix)
    2. Auto Cast (Mobile Support)
    3. Auto Clicker (Mobile Support)
    Gui: Anti-Black (Layering Fix)
    Fix: Input Angka Aman (Anti Base Error)
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
    InstantWin = false,
    DelayWin = 0.5,
    AutoCast = false,
    HoldTime = 0.1,
    LoopDelay = 2.0,
    AutoClick = false,
    ClickMS = 100
}

-- // UI MAKER (TAMPILAN TETAP SAMA) \\ --
function Library:CreateGUI()
    for _, v in pairs(CoreGui:GetChildren()) do
        if v.Name == "FishItFinalFixMobile" then v:Destroy() end
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FishItFinalFixMobile"
    if gethui then ScreenGui.Parent = gethui() else ScreenGui.Parent = CoreGui end

    -- MAIN FRAME
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 260, 0, 250)
    MainFrame.Position = UDim2.new(0.5, -130, 0.5, -125)
    MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    MainFrame.BorderSizePixel = 2
    MainFrame.BorderColor3 = Color3.fromRGB(0, 150, 255)
    MainFrame.ZIndex = 1
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    -- JUDUL
    local Title = Instance.new("TextLabel")
    Title.Text = "FISH IT - V6 FIX"
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    Title.TextColor3 = Color3.white
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 16
    Title.ZIndex = 2
    Title.Parent = MainFrame

    -- [[ FITUR 1: INSTANT WIN ]]
    local Label1 = Instance.new("TextLabel")
    Label1.Text = "Instant Win (Delay)"
    Label1.Position = UDim2.new(0, 10, 0, 40)
    Label1.Size = UDim2.new(0, 120, 0, 20)
    Label1.BackgroundTransparency = 1
    Label1.TextColor3 = Color3.white
    Label1.TextXAlignment = Enum.TextXAlignment.Left
    Label1.ZIndex = 2
    Label1.Parent = MainFrame

    local DelayBox = Instance.new("TextBox")
    DelayBox.Size = UDim2.new(0, 40, 0, 25)
    DelayBox.Position = UDim2.new(0, 130, 0, 38)
    DelayBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    DelayBox.Text = tostring(Config.DelayWin)
    DelayBox.TextColor3 = Color3.fromRGB(255, 255, 0)
    DelayBox.Font = Enum.Font.GothamBold
    DelayBox.TextSize = 14
    DelayBox.ZIndex = 2
    DelayBox.Parent = MainFrame

    -- FIX: Bungkus gsub dengan kurung tambahan agar tidak bocor ke tonumber
    DelayBox:GetPropertyChangedSignal("Text"):Connect(function()
        local textBersih = DelayBox.Text:gsub(",", ".") -- Simpan dulu ke variabel
        local num = tonumber(textBersih)
        if num then Config.DelayWin = num end
    end)

    local Btn1 = Instance.new("TextButton")
    Btn1.Text = "OFF"
    Btn1.Size = UDim2.new(0, 60, 0, 25)
    Btn1.Position = UDim2.new(0, 180, 0, 38)
    Btn1.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    Btn1.TextColor3 = Color3.white
    Btn1.Font = Enum.Font.GothamBold
    Btn1.ZIndex = 2
    Btn1.Parent = MainFrame
    
    Btn1.MouseButton1Click:Connect(function()
        Config.InstantWin = not Config.InstantWin
        Btn1.Text = Config.InstantWin and "ON" or "OFF"
        Btn1.BackgroundColor3 = Config.InstantWin and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    end)

    -- [[ FITUR 2: AUTO CAST ]]
    local Label2 = Instance.new("TextLabel")
    Label2.Text = "Auto Cast (HP)"
    Label2.Position = UDim2.new(0, 10, 0, 80)
    Label2.Size = UDim2.new(0, 120, 0, 20)
    Label2.BackgroundTransparency = 1
    Label2.TextColor3 = Color3.white
    Label2.TextXAlignment = Enum.TextXAlignment.Left
    Label2.ZIndex = 2
    Label2.Parent = MainFrame

    local Btn2 = Instance.new("TextButton")
    Btn2.Text = "OFF"
    Btn2.Size = UDim2.new(0, 60, 0, 25)
    Btn2.Position = UDim2.new(0, 180, 0, 78)
    Btn2.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    Btn2.TextColor3 = Color3.white
    Btn2.Font = Enum.Font.GothamBold
    Btn2.ZIndex = 2
    Btn2.Parent = MainFrame
    
    Btn2.MouseButton1Click:Connect(function()
        Config.AutoCast = not Config.AutoCast
        Btn2.Text = Config.AutoCast and "ON" or "OFF"
        Btn2.BackgroundColor3 = Config.AutoCast and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    end)

    -- Sub-Setting 2: Jeda & Tahan
    local LoopBox = Instance.new("TextBox")
    LoopBox.PlaceholderText = "Jeda"
    LoopBox.Size = UDim2.new(0, 40, 0, 25)
    LoopBox.Position = UDim2.new(0, 130, 0, 78)
    LoopBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    LoopBox.Text = tostring(Config.LoopDelay)
    LoopBox.TextColor3 = Color3.fromRGB(255, 100, 100)
    LoopBox.ZIndex = 2
    LoopBox.Parent = MainFrame

    -- FIX: Bungkus gsub
    LoopBox:GetPropertyChangedSignal("Text"):Connect(function()
        local textBersih = LoopBox.Text:gsub(",", ".")
        local num = tonumber(textBersih)
        if num then Config.LoopDelay = num end
    end)

    local HoldBox = Instance.new("TextBox")
    HoldBox.PlaceholderText = "Hold"
    HoldBox.Size = UDim2.new(0, 40, 0, 25)
    HoldBox.Position = UDim2.new(0, 85, 0, 78)
    HoldBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    HoldBox.Text = tostring(Config.HoldTime)
    HoldBox.TextColor3 = Color3.fromRGB(0, 255, 255)
    HoldBox.ZIndex = 2
    HoldBox.Parent = MainFrame

    -- FIX: Bungkus gsub
    HoldBox:GetPropertyChangedSignal("Text"):Connect(function()
        local textBersih = HoldBox.Text:gsub(",", ".")
        local num = tonumber(textBersih)
        if num then Config.HoldTime = num end
    end)


    -- [[ FITUR 3: AUTO CLICKER ]]
    local Label3 = Instance.new("TextLabel")
    Label3.Text = "Auto Click (ms)"
    Label3.Position = UDim2.new(0, 10, 0, 120)
    Label3.Size = UDim2.new(0, 120, 0, 20)
    Label3.BackgroundTransparency = 1
    Label3.TextColor3 = Color3.white
    Label3.TextXAlignment = Enum.TextXAlignment.Left
    Label3.ZIndex = 2
    Label3.Parent = MainFrame

    local MSBox = Instance.new("TextBox")
    MSBox.Size = UDim2.new(0, 40, 0, 25)
    MSBox.Position = UDim2.new(0, 130, 0, 118)
    MSBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    MSBox.Text = tostring(Config.ClickMS)
    MSBox.TextColor3 = Color3.fromRGB(0, 255, 0)
    MSBox.ZIndex = 2
    MSBox.Parent = MainFrame

    -- FIX: Bungkus gsub
    MSBox:GetPropertyChangedSignal("Text"):Connect(function()
        local textBersih = MSBox.Text:gsub(",", ".")
        local num = tonumber(textBersih)
        if num then Config.ClickMS = num end
    end)

    local Btn3 = Instance.new("TextButton")
    Btn3.Text = "OFF"
    Btn3.Size = UDim2.new(0, 60, 0, 25)
    Btn3.Position = UDim2.new(0, 180, 0, 118)
    Btn3.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    Btn3.TextColor3 = Color3.white
    Btn3.Font = Enum.Font.GothamBold
    Btn3.ZIndex = 2
    Btn3.Parent = MainFrame
    
    Btn3.MouseButton1Click:Connect(function()
        Config.AutoClick = not Config.AutoClick
        Btn3.Text = Config.AutoClick and "ON" or "OFF"
        Btn3.BackgroundColor3 = Config.AutoClick and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    end)
    
    -- TOMBOL CLOSE (X)
    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Text = "X"
    CloseBtn.Size = UDim2.new(0, 40, 0, 30)
    CloseBtn.Position = UDim2.new(1, -40, 0, 0)
    CloseBtn.BackgroundColor3 = Color3.red
    CloseBtn.TextColor3 = Color3.white
    CloseBtn.ZIndex = 3
    CloseBtn.Parent = MainFrame
    CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
end

Library:CreateGUI()

-- =================================================================
-- LOGIKA SYSTEM
-- =================================================================

-- 1. INSTANT WIN
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

-- 2. AUTO CAST (HP)
task.spawn(function()
    while true do
        if Config.AutoCast then
            if LocalPlayer.Character then
                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end
            end
            task.wait(Config.LoopDelay)
        else
            task.wait(1)
        end
    end
end)

-- 3. AUTO CLICKER (HP)
task.spawn(function()
    while true do
        if Config.AutoClick then
            if LocalPlayer.Character then
                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end
            end
            
            pcall(function() -- Fallback PC
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

print("✅ FISH IT - V6 FINAL NO ERROR")
