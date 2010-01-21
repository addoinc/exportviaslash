#!/usr/local/bin/ruby

encodedByte = [
  'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','W','X','Y','Z',
  'a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z',
  '0','1','2','3','4','5','6','7','8','9','+','/'
]
decodedByte = []
encodedByte.each_index {
  |i|
  b = encodedByte[i][0]
  decodedByte[b] = i
}

bitmap = "aAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"

index = 1
for i in 0 .. bitmap.length-1 do
  b = decodedByte[bitmap[i]]
  v = 1
  
  for j in 1 .. 6 do 
    if v & b == v
      print(v," : ", b, " : ", index, "\n")
    end
    v = v * 2
    index = index + 1
  end
end
