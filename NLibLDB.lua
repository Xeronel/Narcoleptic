local ldb = LibStub:GetLibrary("LibDataBroker-1.1")

NLibLDB = ldb:NewDataObject("Narcoleptic", {
    type = "data source",
    text = "Rested: "..math.floor(NLib.RestedPcnt()).."%"
})

function NLibLDB.Update()
    NLibLDB.text = "Rested: "..math.floor(NLib.RestedPcnt()).."%"
end

function NLibLDB:OnTooltipShow()
    for realm, characters in pairs(NLibData) do
        -- Sort characters by length of name
        local sortedKeys = {}

        for k in pairs(characters) do table.insert(sortedKeys, k) end
        table.sort(sortedKeys, NLib.Sort)
        self:AddLine(".: "..realm.." :.")

        for _, name in ipairs(sortedKeys) do
            local c = characters[name];
            local div = " | "
            local lvl = "["..string.rpad(c.lvl, 2, "  ").."]";
            local xp_pcnt = "XP: "..string.rpad(c.xp_pcnt, 3, "  ").."%";
            local rested = "R: "..string.rpad(NLib.CalcRested(realm, name), 3, "  ").."%"
            local location = c.loc;

            -- Add colors if not sent via chat
            name = NLib.ClassColor(c.class, name);
            location = NLib.RestColor(c.resting, location);
            self:AddDoubleLine(lvl.." "..name, xp_pcnt..div..rested)
            self:AddDoubleLine(" ", location)
            self:AddLine(" ")
        end
    end
end