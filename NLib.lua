NLib = {}

function NLib.Initialize()
    -- Create the data table if it doesn't exist
    if NLibData == nil then
        NLibData = {};
    end

    -- Create a table for the current character if it doesn't exist
    if NLibData[UnitName("player")] == nil then
        NLibData[UnitName("player")] = {};
    end
end

function NLib.Print()
    NLib.Update()
    for name, data in pairs(NLibData) do
        local rested = math.floor(NLib.RestedGained(name) + data["rest_pcnt"])
        local msg = format("[%s] %s | %s | XP:%s%% | R:%s%% | %s", data["lvl"], name, data["class"], data["xp_pcnt"], rested, data["loc"])
        DEFAULT_CHAT_FRAME:AddMessage(msg);
        SendChatMessage(tostring(msg):gsub("\124", "\124\124"), "party");
        --print("["..data["lvl"].."] "..name.." <"..data["class"].."> ["..data["xppcnt"].."% R:"..data["restpcnt"].."%] - "..data["loc"], "party");
    end
end

function rpad(str, len, char)
    if char == nil then char = ' ' end
    return str..string.rep(char, len - #str)
end

function NLib.GetRested()
    return GetXPExhaustion() or 0;
end

function NLib.GetXPMax()
    return UnitXPMax("player") or 0;
end

function NLib.GetXPPcnt()
    local xp = UnitXP("player");
    local xpmax = NLib.GetXPMax();

    if xp == 0 or xpmax == 0 then
        return 0;
    else
        return math.floor((xp/xpmax)*100);
    end
end

function NLib.RestedPcnt()
    local rested = NLib.GetRested();
    local max_xp = NLib.GetXPMax();
    if max_xp ~= 0 and rested ~= 0 then
        return (NLib.GetRested()/NLib.GetXPMax())*100;
    else
        return 0;
    end
end

function NLib.RestedGained(name)
    local time_diff = GetServerTime()-NLibData[name].last_seen;
    if time_diff == 0 then
        return 0;
    else
        return time_diff/3600;
    end
end

function NLib.Update()
    local name = UnitName("player");
    NLibData[name]["xp_pcnt"] = NLib.GetXPPcnt();
    NLibData[name]["rested"] = NLib.GetRested();
    NLibData[name]["rest_pcnt"] = NLib.RestedPcnt();
    NLibData[name]["lvl"] = UnitLevel("player");
    NLibData[name]["class"], _, _ = UnitClass("player");
    NLibData[name]["last_seen"] = GetServerTime();
    NLibData[name]["resting"] = IsResting();
    NLibData[name]["loc"] = GetMinimapZoneText();
end