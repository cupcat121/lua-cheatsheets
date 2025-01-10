-- data model and type

-- there are 6+2 of basic and top level types in lua:
---- nil
---- number
---- boolean
---- string
---- table
---- function
---- userdata and thread

-- type(t) to get their type names of variables
print(type("s"))   ----> string

-- nil
-- nil represents a uninitialized value
a = 1   -- global variable
a = nil -- discard it by simply assigning it with nil

-- variables which is uninitialized will be a dummy nil
print(__no_a_valid_var__)
print(table.dummy_attr)

table1 = { 1, 2, 3 }
print(table1[4])


-- number
--[[
1. lua has *no integer type*, and all of numbers represent f64 (double-precision floating-point)
    there is no worry about rounding problem *unless your number is greater than int64 (lua5.3 and above)
]]
print(4 == 4.0) -- true

-- boolean
--[[
1. false, nil ----> false ; any value except false,nil  ----> true
2. not simalar with most of languages, zero counts as true
]]
if 0 then
    print(true)
end

if -1 then
    print(true)
end

if __no_a_valid_var__ then
    print(false)
end


-- string
--[[
1. strings are immutable
2. technically strings in lua are indeed container, and they simply contains bytes.
    It depends on how to render them by callers
]]

-- lua has native support to UTF-8
print("f字符串") -- f字符串
-- *string.len* thinks strings as sequence of bytes
print(string.len("f字符串")) -- 10
-- to correct this, use *utf8* module
print(require("utf8").len("f字符串")) -- 3

-- use *..* to concat multiple strings
print("1" .. "2") -- 12
-- lua uses C-style format string for intepolation
print(string.format("%f %.2f %s %s", 1.2, 1.2, "hello", "你好"))


-- table
--[[
1. mutable, dynamically sized
2. any uninitialized fields will be nil
3. tables start with index of one, different from most of languages
]]

a = {}
a[0] = 1
a[1] = 2
a[2] = 3
a[3] = nil
a["a"] = 4
a["b"] = 5

-- elements with numeric indexes
b = { 1, 2, [3] = 3 }
-- elements with non-numeric indexes (but valid indentifier)
b = { _a_ = 1, _b = 2, c_ = 3 }
-- use [] to create an index with invalid indentifier
b = { ["-a-"] = 1 }
-- use semicolons to seperate parts of elements, it does no lexical effect
b = { 1, 2, 3, a = 1, b = 2 }

-- iterate elements with numeric index on a table (starts from index of one, and end with firstly encountered nil)
for i, v in ipairs(a) do
    print(i .. " " .. tostring(v))
end --[[ output:
1 2
2 3
]]

-- every time uses table constructor it will create an new table
-- impl a linked table
ta = nil
for _, v in pairs(a) do
    ta = { next = ta, data = a }
end

-- iterate all elements on a table
for k, v in pairs(a) do
    print(k .. "=" .. tostring(v))
end

-- function
-- functions are first-class values




-- control flow
--
-- expressions

-- concatenated expressions are evaluated from right to left
print(0.1 ^ 2 ^ 2 ^ 64) ----> 0.1 ^ (2 ^ (2 ^ 64)), prone to overflow
-- evaluate then assign values
x, y = y, x     ----> common idiom to swap two values

