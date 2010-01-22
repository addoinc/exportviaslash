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

basicTradeID = {}
local function buildBasicTradeTable(aliases)
   for n=1,#aliases do
      basicTradeID[aliases[n]] = aliases[1]
   end
end

SpellsMap = {}

function exportviaslash:OnInitialize()
   buildBasicTradeTable({ 2259,3101,3464,11611,28596,28677,28675,28672,51304 })					-- alchemy
   buildBasicTradeTable({ 2018,3100,3538,9785,9788,9787,17039,17040,17041,29844,51300 })			-- bs
   buildBasicTradeTable({ 7411,7412,7413,13920,28029,51313 })							-- enchanting
   buildBasicTradeTable({ 4036,4037,4038,12656,20222,20219,30350,51306 })					-- eng
   buildBasicTradeTable({ 45357,45358,45359,45360,45361,45363 })						-- inscription
   buildBasicTradeTable({ 25229,25230,28894,28895,28897,51311 })						-- jc
   buildBasicTradeTable({ 2108,3104,3811,10656,10660,10658,10662,32549,51302 })					-- lw
   buildBasicTradeTable({ 3908,3909,3910,12180,26801,26798,26797,26790,51309 })					-- tailoring
   buildBasicTradeTable({ 2550,3102,3413,18260,33359,51296 })							-- cooking
   buildBasicTradeTable({ 3273,3274,7924,10846,27028,45542,10846 })						-- first aid
end

function exportviaslash:OnEnable(first)
end

SLASH_EXPORTVIASLASH1 = "/exportviaslash";
function SlashCmdList.EXPORTVIASLASH(msg)
   print("PRINTING ALL KNOWN RECIPES IN ", msg);
   local version, build = GetBuildInfo()
   
   -- depending on profession name generate trade link where all bits are enabled
   local my_link
   if( msg == "Blacksmithing" ) then
      my_link = "TEST " .. "|cffffd000|Htrade:2018:2:75:380000003351CDF:" .. "/" .. string.rep("/", 87) .. "|h[Blacksmithing]|h|r" .. " TEST"
   elseif ( msg == "Tailoring" ) then
      my_link = "TEST " .. "|cffffd000|Htrade:26798:426:450:380000001ACFFFB:" .. "/" .. string.rep("/", 73) .. "|h[Tailoring]|h|r" .. " TEST"
   elseif ( msg == "Inscription" ) then
      my_link = "TEST " .. "|cffffd000|Htrade:45363:431:450:380000001ABD9F5:" .. "/" .. string.rep("/", 75) .. "|h[Inscription]|h|r" .. " TEST"
   elseif ( msg == "Jewelcrafting" ) then
      my_link = "TEST " .. "|cffffd000|Htrade:51311:450:450:380000002A47F07:" .. "/" .. string.rep("/", 95) .. "|h[Jewelcrafting]|h|r" .. " TEST"
   elseif ( msg == "Alchemy" ) then
      my_link = "TEST " .. "|cffffd000|Htrade:28677:450:450:380000002E39D99:" .. "/" .. string.rep("/", 44) .. "|h[Elixir Master]|h|r" .. " TEST"
   elseif ( msg == "Leatherworking" ) then
      my_link = "TEST " .. "|cffffd000|Htrade:51302:420:450:380000001B74BA8:" .. "/" .. string.rep("/", 90) .. "|h[Leatherworking]|h|r" ..  " TEST"
   elseif ( msg == "Engineering" ) then
      my_link = "TEST " .. "|cffffd000|Htrade:51306:450:450:3800000007E3495:" .. "/" .. string.rep("/", 54) .. "|h[Engineering]|h|r" .. " TEST"
   elseif ( msg == "Enchanting" ) then
      my_link = "TEST " .. "|cffffd000|Htrade:51313:450:450:380000002FDA45E:" .. "/" .. string.rep("/", 51) .. "|h[Enchanting]|h|r" .. " TEST"
   end
   
   local tradeID, skill_level, bitmap = string.match(my_link, "trade:(%d+):(%d+):%d+:[0-9a-fA-F]+:([A-Za-z0-9+/]+)")
   
   build = tonumber(build)
   tradeID = tonumber(tradeID)
   if( GYPSpellData[build][tradeID] == nil ) then
      tradeID = basicTradeID[tradeID]
   end
   bits_enabled = wow_decode_bitmap(bitmap)
   SpellsMap[msg] = {}
   for i,v in ipairs(bits_enabled) do
      print(i, " : ", v, " : ", GYPSpellData[build][tradeID][v] )
      if( GYPSpellData[build][tradeID][v] ~= nil ) then
	 local spell_name = GetSpellInfo(GYPSpellData[build][tradeID][v])
	 SpellsMap[msg]["" .. v ..""] =  { GYPSpellData[build][tradeID][v],  spell_name }
      end
   end
   print("END PRINTING ALL KNOWN RECIPES IN ", msg);
   
   -- Commented out code that tested recipe => characters mapping approach
   -- print(GYPSpellData, " : ", RecipeCharacters)
   --local page_num, page_size = 0, 10
   --for idx in pairs({1,2,3,4,5,6,7,8,9,10,11}) do
   --   print(RecipeCharacters["Copper Battle Axe"][idx])
   --end
end
