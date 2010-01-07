require('string')

dofile("table.show.lua")
dofile("exportviaslash.lua")
dofile("GnomishYellowPages.lua")
 
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

local ServerKey = "Jubei'Thos-Alliance"
local Profession = "Blacksmithing"
local recipe_characters = {}
local start_time = time()

print("(Re)Buiding recipe_characters map")
local i = 0
for char_name in pairs(YPData[ServerKey][Profession]) do
   -- print("\n given the character: ", char_name)
   
   local tradeID, skill_level, bitmap = string.match(YPData[ServerKey][Profession][char_name]["link"], "trade:(%d+):(%d+):%d+:[0-9a-fA-F]+:([A-Za-z0-9+/]+)")
   tradeID = tonumber(tradeID)
   
   bits_enabled = wow_decode_bitmap(bitmap)
   for i,v in ipairs(bits_enabled) do
      local spell_name = SpellsMap[""..v..""][2]
      -- print(char_name, " knows ", spell_name)
      if( recipe_characters[spell_name] == nil ) then
	 recipe_characters[spell_name] = {}
	 recipe_characters[spell_name][1] = char_name
      else
	 recipe_characters[spell_name][#recipe_characters[spell_name]+1] = char_name
      end
   end
   --- BREAK AFTER A FEW ITERATIONS SO I CAN SEE THIS THING WORK --- 
   i = i + 1
   if( i > 10 ) then
       -- break
   end
end

local end_time = time()
print("Done (Re)Buiding recipe_characters map")
print("Total time to build map: ", end_time - start_time, " seconds")

start_time = time()
print("Printing first 10 characters who know Radiant Breastplate\n")
local page_num, page_size = 0, 10
for idx in pairs({1,2,3,4,5,6,7,8,9,10}) do
   print(recipe_characters["Sageblade"][idx + (page_num*page_size)])
end
print("\nDone Printing first 10 characters who know Radiant Breastplate")
end_time = time()
print("Total time to print first 10 characters who know Radiant Breastplate: ", end_time - start_time, " seconds")