--[[ 
    FISH IT ULTIMATE - V6 REAL TIME FIX
    Fitur: 
    1. Instant Win (Update nilai langsung saat ketik)
    2. Auto Cast HP (Update nilai langsung saat ketik)
    3. Auto Clicker HP (Update nilai langsung saat ketik)
    Status: LOG AKTIF (Supaya kamu bisa cek kalau angkanya berubah)
]]

local Library = {}
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

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

-- // UI MAKER FUNCTIONS \\ --
function Library:CreateGUI()
    for _, v in pairs(CoreGui:GetChildren()) do
        if v.Name == "FishItRealTime" then v:Destroy() end
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FishItRealTime"
    if gethui then ScreenGui.Parent = gethui() else ScreenGui.Parent = CoreGui end

    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 260, 0, 230)
    MainFrame.Position = UDim2.new(0.5, -130, 0.5, -115)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    -- Judul
    local Title = Instance.new("TextLabel")
    Title.Text = "FISH IT - REAL TIME INPUT"
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.white
    Title.Font = Enum.Font.GothamBlack
    Title.TextSize = 16
    Title.Parent = MainFrame

    -- [[ FITUR 1: INSTANT WIN ]]
    local Label1 = Instance.new("TextLabel")
    Label1.Text = "Instant Win (Delay)"
    Label1.Position = UDim2.new(0, 10, 0, 40)
    Label1.Size = UDim2.new(0, 100, 0, 20)
    Label1.BackgroundTransparency = 1
    Label1.TextColor3 = Color3.white
    Label1.TextXAlignment = Enum.TextXAlignment.Left
    Label1.Parent = MainFrame

    local DelayBox = Instance.new("TextBox")
    DelayBox.Size = UDim2.new(0, 40, 0, 24)
    DelayBox.Position = UDim2.new(0, 120, 0, 38)
    DelayBox.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    DelayBox.Text = tostring(Config.DelayWin)
    DelayBox.TextColor3 = Color3.fromRGB(255, 255, 0)
    DelayBox.Parent = MainFrame

    -- LOGIKA BARU: REAL TIME UPDATE (Gak pake Enter)
    DelayBox:GetPropertyChangedSignal("Text"):Connect(function()
        local num = tonumber(DelayBox.Text:gsub(",", ".")) -- Ubah koma jadi titik
        if num then 
            Config.DelayWin = num
            print("✅ UPDATE: Delay Win jadi " .. num) -- Cek F9
        end
    end)

    local Switch1 = Instance.new("TextButton")
    Switch1.Text = "OFF"
    Switch1.Size = UDim2.new(0, 50, 0, 24)
    Switch1.Position = UDim2.new(0, 180, 0, 38)
    Switch1.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    Switch1.Parent = MainFrame
    
    Switch1.MouseButton1Click:Connect(function()
        Config.InstantWin = not Config.InstantWin
        Switch1.Text = Config.InstantWin and "ON" or "OFF"
        Switch1.BackgroundColor3 = Config.InstantWin and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    end)

    -- [[ FITUR 2: AUTO CAST ]]
    local Label2 = Instance.new("TextLabel")
    Label2.Text = "Auto Cast (HP)"
    Label2.Position = UDim2.new(0, 10, 0, 80)
    Label2.Size = UDim2.new(0, 100, 0, 20)
    Label2.BackgroundTransparency = 1
    Label2.TextColor3 = Color3.white
    Label2.TextXAlignment = Enum.TextXAlignment.Left
    Label2.Parent = MainFrame

    -- Input Loop Delay
    local LoopBox = Instance.new("TextBox")
    LoopBox.PlaceholderText = "Jeda"
    LoopBox.Size = UDim2.new(0, 40, 0, 24)
    LoopBox.Position = UDim2.new(0, 120, 0, 78)
    LoopBox.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    LoopBox.Text = tostring(Config.LoopDelay)
    LoopBox.TextColor3 = Color3.fromRGB(255, 100, 100)
    LoopBox.Parent = MainFrame

    -- REAL TIME UPDATE
    LoopBox:GetPropertyChangedSignal("Text"):Connect(function()
        local num = tonumber(LoopBox.Text:gsub(",", "."))
        if num then 
            Config.LoopDelay = num
            print("✅ UPDATE: Jeda Cast jadi " .. num)
        end
    end)

    local Switch2 = Instance.new("TextButton")
    Switch2.Text = "OFF"
    Switch2.Size = UDim2.new(0, 50, 0, 24)
    Switch2.Position = UDim2.new(0, 180, 0, 78)
    Switch2.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    Switch2.Parent = MainFrame
    
    Switch2.MouseButton1Click:Connect(function()
        Config.AutoCast = not Config.AutoCast
        Switch2.Text = Config.AutoCast and "ON" or "OFF"
        Switch2.BackgroundColor3 = Config.AutoCast and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    end)

    -- [[ FITUR 3: AUTO CLICKER ]]
    local Label3 = Instance.new("TextLabel")
    Label3.Text = "Auto Click (ms)"
    Label3.Position = UDim2.new(0, 10, 0, 120)
    Label3.Size = UDim2.new(0, 100, 0, 20)
    Label3.BackgroundTransparency = 1
    Label3.TextColor3 = Color3.white
    Label3.TextXAlignment = Enum.TextXAlignment.Left
    Label3.Parent = MainFrame

    local MSBox = Instance.new("TextBox")
    MSBox.Size = UDim2.new(0, 40, 0, 24)
    MSBox.Position = UDim2.new(0, 120, 0, 118)
    MSBox.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    MSBox.Text = tostring(Config.ClickMS)
    MSBox.TextColor3 = Color3.fromRGB(0, 255, 0)
    MSBox.Parent = MainFrame

    -- REAL TIME UPDATE
    MSBox:GetPropertyChangedSignal("Text"):Connect(function()
        local num = tonumber(MSBox.Text:gsub(",", "."))
        if num then 
            Config.ClickMS = num
            print("✅ UPDATE: Speed Click jadi " .. num .. "ms")
        end
    end)

    local Switch3 = Instance.new("TextButton")
    Switch3.Text = "OFF"
    Switch3.Size = UDim2.new(0, 50, 0, 24)
    Switch3.Position = UDim2.new(0, 180, 0, 118)
    Switch3.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    Switch3.Parent = MainFrame
    
    Switch3.MouseButton1Click:Connect(function()
        Config.AutoClick = not Config.AutoClick
        Switch3.Text = Config.AutoClick and "ON" or "OFF"
        Switch3.BackgroundColor3 = Config.AutoClick and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
    end)
end

Library:CreateGUI()

-- =================================================================
-- LOGIKA SYSTEM (SUDAH FIX LOGIKA ERROR)
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
                -- Menggunakan Config.DelayWin yang sudah update otomatis
                task.wait(Config.DelayWin) 
                if RemoteFinish then RemoteFinish:FireServer() end
            end)
            return unpack(results)
        end
    end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- 2. AUTO CAST (HP - TOOL ACTIVATE)
task.spawn(function()
    while true do
        if Config.AutoCast then
            if LocalPlayer.Character then
                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end
            end
            task.wait(Config.LoopDelay) -- Menggunakan Config yang update otomatis
        else
            task.wait(1)
        end
    end
end)

-- 3. AUTO CLICKER (HP - TOOL ACTIVATE SPAM)
task.spawn(function()
    while true do
        if Config.AutoClick then
            if LocalPlayer.Character then
                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end
            end
            
            -- Konversi MS ke detik
            task.wait(Config.ClickMS / 1000)
        else
            task.wait(1)
        end
    end
end)

print("Script Loaded. Coba ketik angka, lalu cek Console (F9) apakah ada tulisan UPDATE.")
