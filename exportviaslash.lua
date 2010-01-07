exportviaslash = LibStub("AceAddon-3.0"):NewAddon("AceEvent-3.0")

--------------- WoW base64 Decode function ------------------
local encodedByte = {
   'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z',
   'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
   '0','1','2','3','4','5','6','7','8','9','+','/'
}
local decodedByte = {}
for i=1,#encodedByte do
   local b = string.byte(encodedByte[i])
   decodedByte[b] = i - 1
end
function wow_decode_bitmap(bitmap)
   local index = 1
   local bits_enabled = {}
   for i=1, string.len(bitmap) do
      local b = decodedByte[string.byte(bitmap, i)]
      local v = 1
      
      for j=1,6 do
         if bit.band(v, b) == v then
	    bits_enabled[#bits_enabled+1] = index
         end
         v = v * 2
         index = index + 1
      end
   end
   return bits_enabled
end
--------------- end of WoW base64 Decode function ------------------

SpellsMap = {}

function exportviaslash:OnInitialize()
end

function exportviaslash:OnEnable(first)
end

SLASH_EXPORTVIASLASH1 = "/exportviaslash";
function SlashCmdList.EXPORTVIASLASH(msg)
   print("PRINTING ALL KNOWN RECIPES IN BLACKSMITHING");
   local version, build = GetBuildInfo()
   local my_link = "TEST " .. "|cffffd000|Htrade:2018:2:75:380000003351CDF:" .. "/" .. string.rep("/", 87) .. "|h[Blacksmithing]|h|r" .. " TEST"
   local tradeID, skill_level, bitmap = string.match(my_link, "trade:(%d+):(%d+):%d+:[0-9a-fA-F]+:([A-Za-z0-9+/]+)")
   
   build = tonumber(build)
   tradeID = tonumber(tradeID)
   
   bits_enabled = wow_decode_bitmap(bitmap)
   SpellsMap = {}
   for i,v in ipairs(bits_enabled) do
      local spell_name = GetSpellInfo(GYPSpellData[build][tradeID][v])
      SpellsMap["" .. v ..""] =  { GYPSpellData[build][tradeID][v],  spell_name }
   end
   print("END PRINTING ALL KNOWN RECIPES IN BLACKSMITHING");
end
