local Library = {}
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local VirtualInputManager = game:GetService("VirtualInputManager")

-- // GLOBAL VARIABLES // --
_G.InstantWinAktif = false   -- Saklar 1 (Instant Win)
_G.AutoCastAktif = false     -- Saklar 2 (Auto Cast Pencet)

-- // SETTINGAN DEFAULT // --
_G.InstantDelay = 0.7        -- Delay Menang (Instant Win)
_G.CastCharge = 0.1          -- Berapa lama nahan klik (Hold)
_G.CastDelay = 2.0           -- Jeda antar lemparan (Loop)

-- // UI MAKER FUNCTIONS \\ --
function Library:CreateGUI()
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "FishItUltimateV5_Pencet"
    
    if gethui then ScreenGui.Parent = gethui()
    elseif syn and syn.protect_gui then syn.protect_gui(ScreenGui) ScreenGui.Parent = CoreGui
    else ScreenGui.Parent = CoreGui end

    -- Main Frame (Diperbesar sedikit ke bawah untuk muat input baru)
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 260, 0, 190) -- Tinggi diubah jadi 190
    MainFrame.Position = UDim2.new(0.5, -130, 0.5, -95)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
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
    Title.Text = "FISH IT - AUTO CAST (PENCET)"
    Title.Size = UDim2.new(1, 0, 0, 30)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.Position = UDim2.new(0, 0, 0, 5)
    Title.Parent = MainFrame

    -- =========================================================
    -- [[ BAGIAN 1: INSTANT WIN ]]
    -- =========================================================
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

    -- INPUT: Instant Delay
    local DelayBox = Instance.new("TextBox")
    DelayBox.Size = UDim2.new(0, 40, 0, 24)
    DelayBox.Position = UDim2.new(0, 95, 0.5, -12)
    DelayBox.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    DelayBox.Text = tostring(_G.InstantDelay)
    DelayBox.TextColor3 = Color3.fromRGB(255, 255, 0) -- Kuning
    DelayBox.Font = Enum.Font.GothamBold
    DelayBox.TextSize = 12
    DelayBox.Parent = Container1
    local BoxCorner1 = Instance.new("UICorner"); BoxCorner1.CornerRadius = UDim.new(0,6); BoxCorner1.Parent = DelayBox

    -- Logic Input Angka
    DelayBox.FocusLost:Connect(function()
        local num = tonumber(DelayBox.Text:gsub(",", "."))
        if num then _G.InstantDelay = num; DelayBox.Text = tostring(num)
        else DelayBox.Text = tostring(_G.InstantDelay) end
    end)

    -- SAKLAR 1
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
    Knob1.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob1.Parent = SwitchBg1
    local KCorn1 = Instance.new("UICorner"); KCorn1.CornerRadius = UDim.new(1,0); KCorn1.Parent = Knob1

    SwitchBg1.MouseButton1Click:Connect(function()
        _G.InstantWinAktif = not _G.InstantWinAktif
        if _G.InstantWinAktif then
            TweenService:Create(SwitchBg1, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(46, 204, 113)}):Play()
            TweenService:Create(Knob1, TweenInfo.new(0.2), {Position = UDim2.new(1, -23, 0.5, -10)}):Play()
        else
            TweenService:Create(SwitchBg1, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
            TweenService:Create(Knob1, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -10)}):Play()
        end
    end)

    -- =========================================================
    -- [[ BAGIAN 2: AUTO CAST (PENCET) ]]
    -- =========================================================
    local Container2 = Instance.new("Frame")
    Container2.Size = UDim2.new(1, -20, 0, 80) -- Lebih tinggi untuk muat input settings
    Container2.Position = UDim2.new(0, 10, 0, 85)
    Container2.BackgroundTransparency = 1
    Container2.Parent = MainFrame

    local Label2 = Instance.new("TextLabel")
    Label2.Text = "Auto Cast (Pencet)"
    Label2.Size = UDim2.new(0, 150, 0, 30)
    Label2.BackgroundTransparency = 1
    Label2.TextColor3 = Color3.fromRGB(220, 220, 220)
    Label2.Font = Enum.Font.GothamSemibold
    Label2.TextSize = 13
    Label2.TextXAlignment = Enum.TextXAlignment.Left
    Label2.Parent = Container2

    -- SAKLAR 2 (ON/OFF Auto Cast)
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
    Knob2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob2.Parent = SwitchBg2
    local KCorn2 = Instance.new("UICorner"); KCorn2.CornerRadius = UDim.new(1,0); KCorn2.Parent = Knob2

    SwitchBg2.MouseButton1Click:Connect(function()
        _G.AutoCastAktif = not _G.AutoCastAktif
        if _G.AutoCastAktif then
            TweenService:Create(SwitchBg2, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(46, 204, 113)}):Play()
            TweenService:Create(Knob2, TweenInfo.new(0.2), {Position = UDim2.new(1, -23, 0.5, -10)}):Play()
        else
            TweenService:Create(SwitchBg2, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
            TweenService:Create(Knob2, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -10)}):Play()
        end
    end)

    -- SETTING LABEL: Hold
    local LabelHold = Instance.new("TextLabel")
    LabelHold.Text = "Tahan (s)"
    LabelHold.Size = UDim2.new(0, 60, 0, 20)
    LabelHold.Position = UDim2.new(0, 0, 0, 40)
    LabelHold.BackgroundTransparency = 1
    LabelHold.TextColor3 = Color3.fromRGB(180, 180, 180)
    LabelHold.Font = Enum.Font.Gotham
    LabelHold.TextSize = 11
    LabelHold.TextXAlignment = Enum.TextXAlignment.Left
    LabelHold.Parent = Container2

    -- INPUT BOX: Hold Time (Charge)
    local ChargeBox = Instance.new("TextBox")
    ChargeBox.Size = UDim2.new(0, 40, 0, 24)
    ChargeBox.Position = UDim2.new(0, 60, 0, 38)
    ChargeBox.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    ChargeBox.Text = tostring(_G.CastCharge)
    ChargeBox.TextColor3 = Color3.fromRGB(0, 255, 255) -- Cyan
    ChargeBox.Font = Enum.Font.GothamBold
    ChargeBox.TextSize = 12
    ChargeBox.Parent = Container2
    local BoxCorner2 = Instance.new("UICorner"); BoxCorner2.CornerRadius = UDim.new(0,6); BoxCorner2.Parent = ChargeBox

    ChargeBox.FocusLost:Connect(function()
        local num = tonumber(ChargeBox.Text:gsub(",", "."))
        if num then _G.CastCharge = num; ChargeBox.Text = tostring(num)
        else ChargeBox.Text = tostring(_G.CastCharge) end
    end)

    -- SETTING LABEL: Jeda
    local LabelLoop = Instance.new("TextLabel")
    LabelLoop.Text = "Jeda (s)"
    LabelLoop.Size = UDim2.new(0, 60, 0, 20)
    LabelLoop.Position = UDim2.new(0, 110, 0, 40)
    LabelLoop.BackgroundTransparency = 1
    LabelLoop.TextColor3 = Color3.fromRGB(180, 180, 180)
    LabelLoop.Font = Enum.Font.Gotham
    LabelLoop.TextSize = 11
    LabelLoop.TextXAlignment = Enum.TextXAlignment.Left
    LabelLoop.Parent = Container2

    -- INPUT BOX: Loop Delay
    local LoopBox = Instance.new("TextBox")
    LoopBox.Size = UDim2.new(0, 40, 0, 24)
    LoopBox.Position = UDim2.new(0, 160, 0, 38)
    LoopBox.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    LoopBox.Text = tostring(_G.CastDelay)
    LoopBox.TextColor3 = Color3.fromRGB(255, 100, 100) -- Merah Muda
    LoopBox.Font = Enum.Font.GothamBold
    LoopBox.TextSize = 12
    LoopBox.Parent = Container2
    local BoxCorner3 = Instance.new("UICorner"); BoxCorner3.CornerRadius = UDim.new(0,6); BoxCorner3.Parent = LoopBox

    LoopBox.FocusLost:Connect(function()
        local num = tonumber(LoopBox.Text:gsub(",", "."))
        if num then _G.CastDelay = num; LoopBox.Text = tostring(num)
        else LoopBox.Text = tostring(_G.CastDelay) end
    end)

    -- DRAGGABLE LOGIC
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
-- =================== BAGIAN 1: LOGIKA INSTANT WIN (YANG SUDAH DIPERBAIKI) ====================
-- ===================================================================================
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CONFIG_DEBUG = true

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
    local args = {...} -- Simpan argumen asli

    if method == "InvokeServer" and self.Name == "RF/RequestFishingMinigameStarted" then
        if _G.InstantWinAktif then 
            
            -- [LOGIKA BARU] Tangkap SEMUA hasil return dari server (bukan cuma satu)
            local results = {oldNamecall(self, unpack(args))}
            
            if CONFIG_DEBUG then print("🎣 [INSTANT] Minigame dimulai...") end

            task.spawn(function()
                -- Gunakan delay dari GUI
                task.wait(_G.InstantDelay) 
                
                -- Cek apakah minigame benar-benar dimulai (hasilnya tidak kosong)
                if #results > 0 and RemoteFinish then 
                    RemoteFinish:FireServer() 
                    if CONFIG_DEBUG then print("✅ [INSTANT] Sinyal Menang Dikirim!") end
                end
            end)
            
            -- [PENTING] Kembalikan SEMUA hasil ke game agar script asli tidak error (nil)
            return unpack(results)
        end
    end
    
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)

-- ===================================================================================
-- =================== BAGIAN 2: LOGIKA AUTO CAST (SCRIPT PENCET) ====================
-- ===================================================================================

-- Fungsi Klik Paksa (Virtual Input)
local function PaksaLempar()
    if LocalPlayer.Character then
        -- 1. Tekan Klik Kiri
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 1)
        
        -- 2. Tahan sesuai settingan GUI (Charge)
        task.wait(_G.CastCharge) 
        
        -- 3. Lepas Klik
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 1)
    end
end

-- Loop Utama (Berjalan terus di background, tapi action cuma kalau saklar ON)
task.spawn(function()
    while true do
        if _G.AutoCastAktif then
            PaksaLempar()
            -- Tunggu delay antar lemparan (dari GUI)
            task.wait(_G.CastDelay)
        else
            -- Kalau mati, cek setiap 1 detik biar ga berat
            task.wait(1)
        end
    end
end)

-- Anti-Idle (Biar ga di kick roblox)
LocalPlayer.Idled:Connect(function()
    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
    task.wait()
    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
end)

print("✅ FISH IT - AUTO CAST PENCET MODE READY!")
