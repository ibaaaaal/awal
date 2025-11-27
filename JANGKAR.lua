--[[ 
    FISH IT ULTIMATE - V6 FINAL MOBILE FIX
    Fitur: 
    1. Instant Win (Fix Logic + Real Time Input)
    2. Auto Cast (Support HP - Tool Activate)
    3. Auto Clicker (Support HP - Tool Activate + MS Setting)
    Tampilan: Classic V5 Style
]]

local Library = {}
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local VirtualInputManager = game:GetService("VirtualInputManager") -- Fallback buat PC

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
        if v.Name == "FishItFinalFixMobile" then v:Destroy() end
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FishItFinalFixMobile"
    if gethui then ScreenGui.Parent = gethui() else ScreenGui.Parent = CoreGui end

    -- Main Frame
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 260, 0, 230)
    MainFrame.Position = UDim2.new(0.5, -130, 0.5, -115)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35) -- Warna Classic
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    local UICorner = Instance.new("UICorner")
    UICorner.CornerRadius = UDim.new(0, 12)
    UICorner.Parent = MainFrame

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Color = Color3.fromRGB(60, 60, 65)
    UIStroke.Thickness = 1
    UIStroke.Parent = MainFrame

    -- Title
    local Title = Instance.new("TextLabel")
    Title.Text = "FISH IT - MOBILE FIX"
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.white
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.Parent = MainFrame

    -- [[ BAGIAN 1: INSTANT WIN ]]
    local Container1 = Instance.new("Frame")
    Container1.Size = UDim2.new(1, -20, 0, 40)
    Container1.Position = UDim2.new(0, 10, 0, 40)
    Container1.BackgroundTransparency = 1
    Container1.Parent = MainFrame

    local Label1 = Instance.new("TextLabel")
    Label1.Text = "Instant Win"
    Label1.Size = UDim2.new(0, 90, 1, 0)
    Label1.BackgroundTransparency = 1
    Label1.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label1.Font = Enum.Font.GothamSemibold
    Label1.TextSize = 13
    Label1.TextXAlignment = Enum.TextXAlignment.Left
    Label1.Parent = Container1

    local DelayBox = Instance.new("TextBox")
    DelayBox.Size = UDim2.new(0, 40, 0, 24)
    DelayBox.Position = UDim2.new(0, 95, 0.5, -12)
    DelayBox.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    DelayBox.Text = tostring(Config.DelayWin)
    DelayBox.TextColor3 = Color3.fromRGB(255, 255, 0)
    DelayBox.Font = Enum.Font.GothamBold
    DelayBox.TextSize = 12
    DelayBox.Parent = Container1
    local BoxCorner1 = Instance.new("UICorner"); BoxCorner1.CornerRadius = UDim.new(0,6); BoxCorner1.Parent = DelayBox

    -- FIX: REAL TIME UPDATE (Gak Perlu Enter)
    DelayBox:GetPropertyChangedSignal("Text"):Connect(function()
        local num = tonumber(DelayBox.Text:gsub(",", "."))
        if num then Config.DelayWin = num end
    end)

    local SwitchBg1 = Instance.new("TextButton")
    SwitchBg1.Text = ""
    SwitchBg1.Size = UDim2.new(0, 50, 0, 26)
    SwitchBg1.Position = UDim2.new(1, -55, 0.5, -13)
    SwitchBg1.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    SwitchBg1.AutoButtonColor = false
    SwitchBg1.Parent = Container1
    local Corn1 = Instance.new("UICorner"); Corn1.CornerRadius = UDim.new(1,0); Corn1.Parent = SwitchBg1
    local Knob1 = Instance.new("Frame")
    Knob1.Size = UDim2.new(0, 20, 0, 20)
    Knob1.Position = UDim2.new(0, 3, 0.5, -10)
    Knob1.BackgroundColor3 = Color3.white
    Knob1.Parent = SwitchBg1
    local KCorn1 = Instance.new("UICorner"); KCorn1.CornerRadius = UDim.new(1,0); KCorn1.Parent = Knob1

    SwitchBg1.MouseButton1Click:Connect(function()
        Config.InstantWin = not Config.InstantWin
        local targetColor = Config.InstantWin and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(60, 60, 60)
        local targetPos = Config.InstantWin and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
        SwitchBg1.BackgroundColor3 = targetColor
        Knob1.Position = targetPos
    end)

    -- [[ BAGIAN 2: AUTO CAST (HP) ]]
    local Container2 = Instance.new("Frame")
    Container2.Size = UDim2.new(1, -20, 0, 80)
    Container2.Position = UDim2.new(0, 10, 0, 85)
    Container2.BackgroundTransparency = 1
    Container2.Parent = MainFrame

    local Label2 = Instance.new("TextLabel")
    Label2.Text = "Auto Cast (HP)"
    Label2.Size = UDim2.new(0, 150, 0, 30)
    Label2.BackgroundTransparency = 1
    Label2.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label2.Font = Enum.Font.GothamSemibold
    Label2.TextSize = 13
    Label2.TextXAlignment = Enum.TextXAlignment.Left
    Label2.Parent = Container2

    local SwitchBg2 = Instance.new("TextButton")
    SwitchBg2.Text = ""
    SwitchBg2.Size = UDim2.new(0, 50, 0, 26)
    SwitchBg2.Position = UDim2.new(1, -55, 0, 2)
    SwitchBg2.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    SwitchBg2.AutoButtonColor = false
    SwitchBg2.Parent = Container2
    local Corn2 = Instance.new("UICorner"); Corn2.CornerRadius = UDim.new(1,0); Corn2.Parent = SwitchBg2
    local Knob2 = Instance.new("Frame")
    Knob2.Size = UDim2.new(0, 20, 0, 20)
    Knob2.Position = UDim2.new(0, 3, 0.5, -10)
    Knob2.BackgroundColor3 = Color3.white
    Knob2.Parent = SwitchBg2
    local KCorn2 = Instance.new("UICorner"); KCorn2.CornerRadius = UDim.new(1,0); KCorn2.Parent = Knob2

    SwitchBg2.MouseButton1Click:Connect(function()
        Config.AutoCast = not Config.AutoCast
        local targetColor = Config.AutoCast and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(60, 60, 60)
        local targetPos = Config.AutoCast and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
        SwitchBg2.BackgroundColor3 = targetColor
        Knob2.Position = targetPos
    end)

    -- Label & Input Hold
    local LabelHold = Instance.new("TextLabel")
    LabelHold.Text = "Tahan (s)"
    LabelHold.Position = UDim2.new(0, 0, 0, 40)
    LabelHold.Size = UDim2.new(0, 60, 0, 20)
    LabelHold.BackgroundTransparency = 1
    LabelHold.TextColor3 = Color3.fromRGB(180, 180, 180)
    LabelHold.Font = Enum.Font.Gotham
    LabelHold.TextSize = 11
    LabelHold.Parent = Container2

    local ChargeBox = Instance.new("TextBox")
    ChargeBox.Size = UDim2.new(0, 40, 0, 24)
    ChargeBox.Position = UDim2.new(0, 60, 0, 38)
    ChargeBox.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    ChargeBox.Text = tostring(Config.HoldTime)
    ChargeBox.TextColor3 = Color3.fromRGB(0, 255, 255)
    ChargeBox.Font = Enum.Font.GothamBold
    ChargeBox.TextSize = 12
    ChargeBox.Parent = Container2
    local BoxCorner2 = Instance.new("UICorner"); BoxCorner2.CornerRadius = UDim.new(0,6); BoxCorner2.Parent = ChargeBox
    
    -- FIX: REAL TIME UPDATE
    ChargeBox:GetPropertyChangedSignal("Text"):Connect(function()
        local num = tonumber(ChargeBox.Text:gsub(",", "."))
        if num then Config.HoldTime = num end
    end)

    -- Label & Input Jeda
    local LabelLoop = Instance.new("TextLabel")
    LabelLoop.Text = "Jeda (s)"
    LabelLoop.Position = UDim2.new(0, 110, 0, 40)
    LabelLoop.Size = UDim2.new(0, 60, 0, 20)
    LabelLoop.BackgroundTransparency = 1
    LabelLoop.TextColor3 = Color3.fromRGB(180, 180, 180)
    LabelLoop.Font = Enum.Font.Gotham
    LabelLoop.TextSize = 11
    LabelLoop.Parent = Container2

    local LoopBox = Instance.new("TextBox")
    LoopBox.Size = UDim2.new(0, 40, 0, 24)
    LoopBox.Position = UDim2.new(0, 160, 0, 38)
    LoopBox.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    LoopBox.Text = tostring(Config.LoopDelay)
    LoopBox.TextColor3 = Color3.fromRGB(255, 100, 100)
    LoopBox.Font = Enum.Font.GothamBold
    LoopBox.TextSize = 12
    LoopBox.Parent = Container2
    local BoxCorner3 = Instance.new("UICorner"); BoxCorner3.CornerRadius = UDim.new(0,6); BoxCorner3.Parent = LoopBox
    
    -- FIX: REAL TIME UPDATE
    LoopBox:GetPropertyChangedSignal("Text"):Connect(function()
        local num = tonumber(LoopBox.Text:gsub(",", "."))
        if num then Config.LoopDelay = num end
    end)

    -- [[ BAGIAN 3: AUTO CLICKER (HP) ]]
    local Container3 = Instance.new("Frame")
    Container3.Size = UDim2.new(1, -20, 0, 40)
    Container3.Position = UDim2.new(0, 10, 0, 175)
    Container3.BackgroundTransparency = 1
    Container3.Parent = MainFrame

    local Label3 = Instance.new("TextLabel")
    Label3.Text = "Auto Clicker"
    Label3.Size = UDim2.new(0, 90, 1, 0)
    Label3.BackgroundTransparency = 1
    Label3.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label3.Font = Enum.Font.GothamSemibold
    Label3.TextSize = 13
    Label3.TextXAlignment = Enum.TextXAlignment.Left
    Label3.Parent = Container3

    local MSBox = Instance.new("TextBox")
    MSBox.Size = UDim2.new(0, 40, 0, 24)
    MSBox.Position = UDim2.new(0, 95, 0.5, -12)
    MSBox.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    MSBox.Text = tostring(Config.ClickMS)
    MSBox.TextColor3 = Color3.fromRGB(0, 255, 0)
    MSBox.Font = Enum.Font.GothamBold
    MSBox.TextSize = 12
    MSBox.Parent = Container3
    local BoxCornerMS = Instance.new("UICorner"); BoxCornerMS.CornerRadius = UDim.new(0,6); BoxCornerMS.Parent = MSBox
    
    -- FIX: REAL TIME UPDATE
    MSBox:GetPropertyChangedSignal("Text"):Connect(function()
        local num = tonumber(MSBox.Text:gsub(",", "."))
        if num then Config.ClickMS = num end
    end)

    local LabelMS = Instance.new("TextLabel")
    LabelMS.Text = "ms"
    LabelMS.Size = UDim2.new(0, 20, 0, 24)
    LabelMS.Position = UDim2.new(0, 138, 0.5, -12)
    LabelMS.BackgroundTransparency = 1
    LabelMS.TextColor3 = Color3.fromRGB(150, 150, 150)
    LabelMS.Font = Enum.Font.Gotham
    LabelMS.TextSize = 11
    LabelMS.Parent = Container3

    local SwitchBg3 = Instance.new("TextButton")
    SwitchBg3.Text = ""
    SwitchBg3.Size = UDim2.new(0, 50, 0, 26)
    SwitchBg3.Position = UDim2.new(1, -55, 0.5, -13)
    SwitchBg3.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    SwitchBg3.AutoButtonColor = false
    SwitchBg3.Parent = Container3
    local Corn3 = Instance.new("UICorner"); Corn3.CornerRadius = UDim.new(1,0); Corn3.Parent = SwitchBg3
    local Knob3 = Instance.new("Frame")
    Knob3.Size = UDim2.new(0, 20, 0, 20)
    Knob3.Position = UDim2.new(0, 3, 0.5, -10)
    Knob3.BackgroundColor3 = Color3.white
    Knob3.Parent = SwitchBg3
    local KCorn3 = Instance.new("UICorner"); KCorn3.CornerRadius = UDim.new(1,0); KCorn3.Parent = Knob3

    SwitchBg3.MouseButton1Click:Connect(function()
        Config.AutoClick = not Config.AutoClick
        local targetColor = Config.AutoClick and Color3.fromRGB(46, 204, 113) or Color3.fromRGB(60, 60, 60)
        local targetPos = Config.AutoClick and UDim2.new(1, -23, 0.5, -10) or UDim2.new(0, 3, 0.5, -10)
        SwitchBg3.BackgroundColor3 = targetColor
        Knob3.Position = targetPos
    end)

    -- Draggable
    local dragging, dragInput, dragStart, startPos
    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
    MainFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dragStart = input.Position; startPos = MainFrame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    MainFrame.InputChanged:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end end)
    UserInputService.InputChanged:Connect(function(input) if input == dragInput and dragging then update(input) end end)
end

Library:CreateGUI()

-- ===================================================================================
-- LOGIC 1: INSTANT WIN (FIXED)
-- ===================================================================================

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
            local results = {oldNamecall(self, unpack(args))} -- Capture return values
            
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

-- ===================================================================================
-- LOGIC 2: AUTO CAST (FIXED FOR HP - Activate)
-- ===================================================================================

task.spawn(function()
    while true do
        if Config.AutoCast then
            if LocalPlayer.Character then
                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then 
                    tool:Activate() -- Tap Layar
                end
            end
            task.wait(Config.LoopDelay)
        else
            task.wait(1)
        end
    end
end)

-- ===================================================================================
-- LOGIC 3: AUTO CLICKER (FIXED FOR HP - Activate + MS)
-- ===================================================================================

task.spawn(function()
    while true do
        if Config.AutoClick then
            -- 1. Metode Utama: Tool Activate (Tap)
            if LocalPlayer.Character then
                local tool = LocalPlayer.Character:FindFirstChildOfClass("Tool")
                if tool then 
                    tool:Activate()
                end
            end
            
            -- 2. Metode Cadangan (PC Fallback - Kali aja support)
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

-- Anti Idle (Support Mobile)
LocalPlayer.Idled:Connect(function()
    pcall(function()
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
        task.wait()
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
    end)
end)

print("✅ FISH IT MOBILE FIXED LOADED")
