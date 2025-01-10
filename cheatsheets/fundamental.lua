-- lexical conversion
--
-- identifier
-- lua is case-sensitive
_a, _b_, S, s = 1,2,3,4

-- lua is a weak-typing and dynamically typed language

-- arithmetic operations are apt to return numbers
print(1 + "1")  ----> 11
print("1" + 1)  ----> 11

-- string operations are apt to return strings
print(1 .. 1)   ----> '11'

-- use *to{string,number}* to explicitly convert the variable type
print(tostring(1)) ----> '1'
print(tonumber("1"))   ----> 1

-- moreover, use string.byte to get numeric code of a character
print(string.byte('1'))    ----> 49