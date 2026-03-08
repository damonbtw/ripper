-- Auto Armor | Da Hood
-- F1 to toggle on/off

local Players = game:GetService("Players")
local Mouse = Players.LocalPlayer:GetMouse()
local localPlayer = Players.LocalPlayer
local enabled = true
local buying = false
local guiBg, guiBorder, guiAccent, guiLabel
local boxW = 140
local boxH = 34

local function updateLabel()
    if not guiLabel or not guiBg then return end
    local pos = guiBg.Position
    if enabled then
        local t = "Damon <3 | ON"
        guiLabel.Text = t
        guiLabel.Color = Color3.fromHex("#64DC82")
        guiLabel.Position = Vector2.new(pos.X + (boxW / 2) - (#t * 7 / 2), pos.Y + 10)
        guiAccent.Color = Color3.fromHex("#64DC82")
    else
        local t = "Damon <3 | OFF"
        guiLabel.Text = t
        guiLabel.Color = Color3.fromHex("#888888")
        guiLabel.Position = Vector2.new(pos.X + (boxW / 2) - (#t * 7 / 2), pos.Y + 10)
        guiAccent.Color = Color3.fromHex("#444444")
    end
end

-- ═══════════════════════════
--   GUI - spawned separately
--   so F1 works immediately
-- ═══════════════════════════
task.spawn(function()
    task.wait(3) -- wait for screen size to be correct

    local screenWidth = workspace.CurrentCamera.ViewportSize.X
    local boxX = (screenWidth / 2) - (boxW / 2)
    local boxY = 14

    guiBg = Drawing.new("Square")
    guiBg.Visible = true
    guiBg.Transparency = 1
    guiBg.ZIndex = 10
    guiBg.Color = Color3.fromHex("#121111")
    guiBg.Position = Vector2.new(boxX, boxY)
    guiBg.Size = Vector2.new(boxW, boxH)
    guiBg.Filled = true
    guiBg.Corner = 10

    guiBorder = Drawing.new("Square")
    guiBorder.Visible = true
    guiBorder.Transparency = 1
    guiBorder.ZIndex = 11
    guiBorder.Color = Color3.fromHex("#2a2a2a")
    guiBorder.Filled = false
    guiBorder.Thickness = 1
    guiBorder.Position = guiBg.Position
    guiBorder.Size = guiBg.Size
    guiBorder.Corner = 10

    guiAccent = Drawing.new("Square")
    guiAccent.Visible = true
    guiAccent.Transparency = 1
    guiAccent.ZIndex = 12
    guiAccent.Color = Color3.fromHex("#64DC82")
    guiAccent.Filled = true
    guiAccent.Position = Vector2.new(boxX + 10, boxY + boxH - 4)
    guiAccent.Size = Vector2.new(boxW - 20, 2)
    guiAccent.Corner = 2

    guiLabel = Drawing.new("Text")
    guiLabel.Visible = true
    guiLabel.ZIndex = 13
    guiLabel.Text = "Damon <3 | ON"
    guiLabel.Size = 13
    guiLabel.Color = Color3.fromHex("#64DC82")
    guiLabel.Transparency = 1
    guiLabel.Outline = false
    guiLabel.Position = Vector2.new(boxX + (boxW / 2) - (#"Damon <3 | ON" * 7 / 2), boxY + 10)

    -- Drag logic inside same spawn since it needs guiBg
    local dragging = false
    local dragStart = nil
    local startPos = nil
    local lastMouse1 = false
    while true do
        wait(0.01)
        if isrbxactive() then
            local mouse1 = ismouse1pressed()
            local mPos = Vector2.new(Mouse.X, Mouse.Y)
            if mouse1 and not lastMouse1 then
                if mPos.X >= guiBg.Position.X and mPos.X <= guiBg.Position.X + guiBg.Size.X and
                   mPos.Y >= guiBg.Position.Y and mPos.Y <= guiBg.Position.Y + guiBg.Size.Y then
                    dragging = true
                    dragStart = mPos
                    startPos = guiBg.Position
                end
            end
            if not mouse1 then dragging = false end
            if dragging and mouse1 then
                local delta = mPos - dragStart
                local newPos = startPos + delta
                guiBg.Position = newPos
                guiBorder.Position = newPos
                guiAccent.Position = Vector2.new(newPos.X + 10, newPos.Y + boxH - 4)
                local t = guiLabel.Text
                guiLabel.Position = Vector2.new(newPos.X + (boxW / 2) - (#t * 7 / 2), newPos.Y + 10)
            end
            lastMouse1 = mouse1
        end
    end
end)

-- ═══════════════════════════
--         FUNCTIONS
-- ═══════════════════════════
local function pressShift()
    keypress(0xA0)
    task.wait(0.1)
    keyrelease(0xA0)
    task.wait(0.15)
end

local function hasForceField()
    local char = localPlayer.Character
    if not char then return true end
    return char:FindFirstChildWhichIsA("ForceField") ~= nil
end

local function buyArmor()
    if buying then return end
    buying = true

    local char = localPlayer.Character
    if not char then buying = false return end

    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then buying = false return end

    local bodyEffects = char:FindFirstChild("BodyEffects")
    local armorVal = bodyEffects and bodyEffects:FindFirstChild("Armor")
    if not armorVal then buying = false return end

    local block = game.Workspace.Ignored.Shop:FindFirstChild("[High-Medium Armor] - $2589")
    if not block then buying = false return end

    local head = block:FindFirstChild("Head")
    if not head then buying = false return end

    local returnPos = Vector3.new(hrp.Position.X, hrp.Position.Y, hrp.Position.Z)

    -- Unequip tool
    keypress(0x31) task.wait(0.05) keyrelease(0x31) task.wait(0.05)
    keypress(0x32) task.wait(0.05) keyrelease(0x32) task.wait(0.05)
    keypress(0x33) task.wait(0.05) keyrelease(0x33) task.wait(0.05)
    keypress(0x33) task.wait(0.05) keyrelease(0x33) task.wait(0.1)

    -- Teleport to shop
    hrp.Position = head.Position + Vector3.new(0, 2.5, 0)
    task.wait(0.15)

    mousemoverel(0, 9999)
    task.wait(0.1)
    mousemoverel(0, 9999)
    task.wait(0.1)

    pressShift()
    task.wait(0.1)

    mousemoverel(0, 9999)
    task.wait(0.1)

    -- Spam click
    local attempts = 0
    while attempts < 50 do
        if not enabled then break end
        mousemoverel(0, 9999)
        mouse1click()
        task.wait(0.1)
        if armorVal.Value > 0 then break end
        attempts += 1
    end

    -- Reset camera
    mousemoverel(0, -9999)
    task.wait(0.05)
    mousemoverel(0, 3600)
    task.wait(0.1)

    -- Re-enter shiftlock
    pressShift()
    task.wait(0.1)

    -- Tp back with fully fresh reference
    task.wait(0.3)
    local freshChar = localPlayer.Character
    if freshChar then
        local freshHrp = freshChar:FindFirstChild("HumanoidRootPart")
        if freshHrp then
            freshHrp.Position = returnPos
        end
    end

    task.wait(1)
    buying = false
end

-- ═══════════════════════════
--        POLL LOOP
-- ═══════════════════════════
task.spawn(function()
    task.wait(3)
    while true do
        task.wait(0.1)
        if not enabled or buying then continue end
        if hasForceField() then continue end

        local char = localPlayer.Character
        if not char then continue end

        local bodyEffects = char:FindFirstChild("BodyEffects")
        if not bodyEffects then continue end

        local armorVal = bodyEffects:FindFirstChild("Armor")
        if not armorVal then continue end

        if armorVal.Value <= 0 then
            buyArmor()
        end
    end
end)

-- ═══════════════════════════
--   F1 TOGGLE - starts immediately
--   no wait so it works right away
-- ═══════════════════════════
task.spawn(function()
    local wasPressed = false
    while true do
        task.wait(0.05)
        local pressed = iskeypressed(0x70)
        if pressed and not wasPressed then
            enabled = not enabled
            updateLabel()
        end
        wasPressed = pressed
    end
end)
