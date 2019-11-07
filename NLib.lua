NLib = {}

NLib.ClassColors = {
    ["Hunter"] = "|cFFAAD372",
    ["Mage"] = "|cFF3FC6EA",
    ["Warlock"] = "|cFF8787ED",
    ["Paladin"] = "|cFFF48CBA",
    ["Druid"] = "|cFFFF7C0A",
    ["Priest"] = "|cFFFFFFFF",
    ["Rogue"] = "|cFFFFF468",
    ["Warrior"] = "|cFFC69B6D"
}

NLib.RestColors = {
    [true] = "|cFF76C8FF",
    [false] = "|cFFFF4040"
}

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

function NLib.Print(channel)
    NLib.Update()
    for realm, characters in pairs(NLibData) do
        -- Sort characters by length of name
        local sortedKeys = {}
        for k in pairs(characters) do table.insert(sortedKeys, k) end
        table.sort(sortedKeys, NLib.Sort)
        
        if channel == "say" or channel == "party" then
            SendChatMessage(".: "..realm.." :.", channel);
        else
            DEFAULT_CHAT_FRAME:AddMessage(".: "..realm.." :.");
        end

        for _, name in ipairs(sortedKeys) do
            local c = characters[name];
            local div = " | "
            local lvl = "["..string.rpad(tostring(c.lvl), 2, "  ").."]";
            local xp_pcnt = "XP: "..c.xp_pcnt.."%";
            local rested = "R: "..NLib.CalcRested(realm, name).."%"
            local location = c.loc;

            -- Add colors if not sent via chat
            if channel ~= "say" and channel ~= "party" then
                name = NLib.ClassColor(c.class, name);
                location = NLib.RestColor(c.resting, location);
            end

            local msg = lvl.." "..name..div..xp_pcnt..div..rested..div..location
            if channel == "say" or channel == "party" then
                SendChatMessage(tostring(msg):gsub("\124", "\124\124"), channel);
            else
                DEFAULT_CHAT_FRAME:AddMessage(msg);
            end
        end
    end
end

function NLib.Sort(a, b)
    return string.len(a) < string.len(b)
end

string.rpad = function(str, len, char)
    if char == nil then char = ' ' end
    return string.rep(char, len - #str) .. str
end

string.lpad = function(str, len, char)
    if char == nil then char = ' ' end
    return str .. string.rep(char, len - #str)
end

function NLib.ClassColor(class, str)
    return NLib.ClassColors[class]..format("%s|r", str);
end

function NLib.RestColor(resting, str)
    return NLib.RestColors[resting]..format("%s|r", str);
end

function NLib.GetRested()
    return GetXPExhaustion() or 0;
end

function NLib.GetXPMax()
    return UnitXPMax("player") or 0;
end

function NLib.GetXPPcnt()
    local xp = UnitXP("player")
    local xpmax = NLib.GetXPMax()

    if xp == 0 or xpmax == 0 then
        return 0;
    else
        return math.floor((xp/xpmax)*100);
    end
end

function NLib.RestedPcnt()
    local rested = NLib.GetRested()
    local max_xp = NLib.GetXPMax()
    if max_xp ~= 0 and rested ~= 0 then
        return (NLib.GetRested()/NLib.GetXPMax())*100
    else
        return 0
    end
end

function NLib.CalcRested(realm, name)
    local rested = NLibData[realm][name].rest_pcnt
    local rest_gained = NLib.RestedGained(realm, name)
    local total_rested = math.floor(rested + rest_gained)

    if total_rested >= 150 then
        return 150
    else
        return total_rested
    end
end

function NLib.RestedGained(realm, name)
    local time_diff = GetServerTime()-NLibData[realm][name].last_seen
    local one_hour = 3600
    local resting_rate = 0.625
    local normal_rate = 0.15625

    if time_diff == 0 then
        return 0;
    else
        -- 3600 = 1 hour in seconds
        if NLibData[realm][name].resting then
            return (time_diff/one_hour)*0.625
        else
            return (time_diff/one_hour)*0.15625
        end
    end
end

function NLib.GetZone()
    local realm = GetRealmName()
    local name = UnitName("player")
    local zone = GetZoneText()
    local subZone = GetSubZoneText()
    local prevZone = NLibData[realm][name]["loc"]

    if subZone ~= "" and subZone ~= nil then
        return subZone
    elseif zone ~= "" and zone ~= nil then
        return zone
    elseif prevZone ~= "" and prevZone ~= nil then
        return prevZone
    else
        return ""
    end
end

function NLib.Update()
    local name = UnitName("player")
    local realm = GetRealmName()
    NLib.Initialize()
    NLibData[realm][name]["xp_pcnt"] = NLib.GetXPPcnt()
    NLibData[realm][name]["rested"] = NLib.GetRested()
    NLibData[realm][name]["rest_pcnt"] = NLib.RestedPcnt()
    NLibData[realm][name]["lvl"] = UnitLevel("player")
    NLibData[realm][name]["class"], _, _ = UnitClass("player")
    NLibData[realm][name]["last_seen"] = GetServerTime()
    NLibData[realm][name]["resting"] = IsResting()
    NLibData[realm][name]["loc"] = NLib.GetZone()
end