Sleepy = {};
Sleepy.f = CreateFrame("Frame", "Narcoleptic", UIParent)
Sleepy.f:RegisterEvent("PLAYER_UPDATE_RESTING")
Sleepy.f:RegisterEvent("ADDON_LOADED")
Sleepy.f:RegisterEvent("UPDATE_EXHAUSTION")
Sleepy.f:RegisterEvent("PLAYER_ENTERING_WORLD")
Sleepy.f:RegisterEvent("ZONE_CHANGED")
Sleepy.f:RegisterEvent("ZONE_CHANGED_INDOORS")
Sleepy.f:RegisterEvent("ZONE_CHANGED_NEW_AREA")

Sleepy.f:SetScript("OnEvent", function(self, event, arg1)
    if event == "ADDON_LOADED" and arg1 == "Narcoleptic" then
        NLib.Update()
    elseif event == "PLAYER_UPDATE_RESTING" then
        NLib.Update()
    elseif event == "UPDATE_EXHAUSTION" then
        NLib.Update()
    elseif event == "PLAYER_ENTERING_WORLD" then
        NLib.Update()
    elseif event == "ZONE_CHANGED" then
        NLib.Update()
    elseif event == "ZONE_CHANGED_INDOORS" then
        NLib.Update()
    elseif event == "ZONE_CHANGED_NEW_AREA" then
        NLib.Update()
    end
end)

Sleepy.f:Hide()

-- Slash Commands
SLASH_RESTED1 = "/rested";
function SlashCmdList.RESTED(msg)
    NLib.Print(msg);
end