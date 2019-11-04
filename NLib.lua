NLib = {}

function NLib.Initialize()
    local realm =  GetRealmName();
    local player = UnitName("player");

    if NLibData == nil then
        NLibData = {};
    end

    if NLibData[realm] == nil then
        NLibData[realm] = {};
    end

    if NLibData[realm][player] == nil then
        NLibData[realm][player] = {};
    end
end

function NLib.Print()
    NLib.Update()
    for realm, characters in pairs(NLibData) do
        DEFAULT_CHAT_FRAME:AddMessage(".: "..realm.." :.");
        for n, c in pairs(characters) do
            local msg_fmt
            if c["resting"] then 
                msg_fmt = "[%s] %s \124 %s \124 XP:%s%% \124 R:%s%% \124 |cFF76C8FF%s|r"
            else
                msg_fmt = "[%s] %s \124 %s \124 XP:%s%% \124 R:%s%% \124 |cFFFF4040%s|r"
            end
            local rested = math.floor(NLib.RestedGained(realm, n) + c["rest_pcnt"])
            local msg = format(msg_fmt, c["lvl"], n, c["class"], c["xp_pcnt"], rested, c["loc"])
            DEFAULT_CHAT_FRAME:AddMessage(msg);
            --SendChatMessage(tostring(msg):gsub("\124", "\124\124"), "party");
        end
    end
end

function NLib.rpad(str, len, char)
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

function NLib.RestedGained(realm, name)
    local time_diff = GetServerTime()-NLibData[realm][name].last_seen;
    if time_diff == 0 then
        return 0;
    else
        if NLibData[realm][name].resting then
            return (time_diff/3600)*0.625;
        else
            return (time_diff/3600)*0.15625;
        end
    end
end

function NLib.Update()
    local name = UnitName("player");
    local realm = GetRealmName();
    NLib.Initialize()
    NLibData[realm][name]["xp_pcnt"] = NLib.GetXPPcnt();
    NLibData[realm][name]["rested"] = NLib.GetRested();
    NLibData[realm][name]["rest_pcnt"] = NLib.RestedPcnt();
    NLibData[realm][name]["lvl"] = UnitLevel("player");
    NLibData[realm][name]["class"], _, _ = UnitClass("player");
    NLibData[realm][name]["last_seen"] = GetServerTime();
    NLibData[realm][name]["resting"] = IsResting();
    NLibData[realm][name]["loc"] = GetMinimapZoneText();
end