---@diagnostic disable: assign-type-mismatch, lowercase-global

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
print(type("s")) ----> string

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
1. lua has *no integer type*, and all of numbers represent float64 (before lua5.3)
    there is no worry about rounding problem *unless your number is greater than 2^53
2. lua has two alternatives int64 and float64 to represent numbers (lua5.3 and above)
]]
print(0x40, 40) ----> 64 40

-- they are all the type of numbers, and equal when they are not numerically distinct
print(4 == 4.0) -- true
-- sometimes you want to distinguish floats and integers, use lib function math.type
math = require("math")
print(math.type(4))   ----> integer
print(math.type(4.0)) ----> float


-- boolean
--[[
1. false, nil ----> false ; any value except false,nil  ----> true
2. not simalar with most of languages, zero counts as true
]]
if 0 then
    print(true)
elseif -1 then
    print(true)
end

if __no_a_valid_var__ then
    print(false)
end


-- string
--[[
1. strings are immutable
2. technically strings in lua are indeed container, and they simply contains bytes.
    Lua itself is agnostic about encoded texts, which depend on how to render them by callers
]]
-- multiline strings
print([[data
hello, world
你好, 世界
こんにちは, この世界へ
]])

-- lua has native support to UTF-8
print("f字符串") -- f字符串
-- length operator can be used for strings, but it's unable to handle the length of strings with multi-spaces encoding
print(#"f字符串") -- 7
-- *string.len* thinks strings as sequence of bytes
print(string.len("f字符串")) -- 7
-- to correct this, use *utf8* module
print(require("utf8").len("f字符串")) -- 3

-- use *..* to concat multiple strings
print("1" .. "2") -- 12
-- lua uses C-style format string for intepolation
print(string.format("%f %.2f %s %s", 1.2, 1.2, "hello", "你好"))
-- moreover, use string.byte to get numeric code of a character
print(string.byte('1')) ----> 49

-- table
--[[
1. mutable, dynamically sized
2. any uninitialized fields will be nil
3. tables start with index of one, different from most of languages
4. when we iterate over tables using *pairs*, the order of elements is not guaranteed
]]

-- we call this type of table list (no key-value pairs)
-- it can be traversed by elements' order (incremental index starting from *one*)
a = { 1, 2, nil, 3 }
-- if they have no *holes* (nil) among values, usually we call this type of list sequence
a = { 1, 2, 3 }
-- length operator works seamlessly in these sequences, like strings
print(#a) ----> 3

a = {}
a[0] = 1
a[1] = 2
a[2] = 3
a[3] = nil
a["a"] = 4
a["b"] = 5

-- length operator used in tables but not sequences will be frustrating
-- running in lua5.4.7
a1 = { 1, 2, nil, 3 }
a1[#a1 + 1] = 4 ----> common idiom to append a value to list
print(#a1)      ----> 5
a2 = {}
a[1] = 1
a[100] = 2
print(#a2) ----> 1

-- elements with numeral indexes
b = { 1, 2, [3] = 3 }
-- elements with non-numeral indexes (but valid indentifier)
b = { _a_ = 1, _b = 2, c_ = 3 }
-- use [] to create an index with invalid indentifier
b = { ["-a-"] = 1 }
-- use semicolons to separate parts of elements, which have no lexical effect (forward compatibility for former lua)
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

-- define a function, same as *fa=function(a,b,c) ... end*
function fa(a, b, c)
    print(string.format("im a function with args, %s %s %s", a, b, c))
    return a, b, c
end

-- define a local function
-- in lua it is expanded to
local fb; function fb() end

local function fb(a)
    function fb_closure()
        print("im wrapped")
    end

    print("im a local function with arg ", a)
    return function()
        print("im anonymous function")
    end
end

-- if the function has one single argument which is a string literal or table constructor,
-- parentheses while calling the function can be optional
fb(1)
fb "1"
fb { 1 }
-- missing arguments will simply be *nil*
fa(1, 2) ----> im a function with args, 1 2 nil

-- returns will be unpacked automatically in assignment statements
fa(fa("1", 2, "3"))  ----> a="1", b=2, c="3"
ra, _, rc = fa(1, 2, 3)
ra, rb = fa(1, 2, 3) ----> return value *3* will be ignored

-- variadic functions
-- *...* here calls vararg expression, it internally represents the extra collected arguments in lua
function fc(a, ...)
    -- assemble them in a table
    local ta = { ... }
    -- Perl' s style
    local b, c, d = ...
    -- slice arguments from index of 2 to the end
    local c, d = select(2, ...)
    -- get the total number of arguments
    local n = select("#", ...)

    for k, v in pairs(ta) do
        print(k .. " = " .. v)
    end
    return ...
end

fc(1, 2, 3, 4) ----> reutrn=2, 3, 4 (not a table!)

-- assemble return values in a table
ta = { fc(1, 2, 3) }
-- sometimes there are *holes* (nil values) in the return of vararg expression
fc(table.unpack { 1, 2, nil, 3 }) ----> return=2, nil, 3 (not a table!)
-- use table.pack to collect arguments into a table and add a extra field *n* with the total number of passed arguments
-- we can use *n* to find out whether none of arguments is nil
function fd(...)
    local args = table.pack(...) ----> {..., n=?}
    for i = 1, args.n do
        if args[i] == nil then
            args[i] = 0
        end
    end
    return args
end

tb = table.pack(fd(table.unpack { 1, 2, nil, 3 })) ----> {1, 2, 0, 3, n=4}


-- variable binding in functions happens while calling it
function fd()
    print(d)
end

d = 5
fd() ----> 5
d = 6
fd() ----> 6


-- iterator
--
-- stateful iterator
-- they keep their internal states (index or something) by making closure
function ipairs2(t)
    local t = t
    local i = 0
    return function()
        i = i + 1
        local v = t[i]
        if v then
            return i, v
        end
    end
end

--[[
generic for-loop does three things here
    1. keeps the return of *ia* (usually we name it *the iterator function*)
    2. calls the iterator function successively at every loops then assigns *i* *v* returned by every call
    3. terminates the loop once *i* and *v* is nil
]]
ta = { 2, 3, 4 }
for i, v in ipairs2(ta) do
    print(i .. " = " .. v)
end

-- stateless iterator
-- iterator that does not contain internal states by itself
-- hence there is no need to make any closure (better performance)
--[[
sematics of generic for:

for _v1, _v2, ..., _vn in _f, _t, i do
    [BLOCK]
end

it's equivalent to:

do
    local _f, _t, i = _f, _t, i
    while true do
        local _v1, _v2, ..., _vn = _f(_t, i)
        __v = _v1   ----> control variable
        if __v == nil then break end
        [BLOCK]
    end
end
-- in lua, we usually call *__v* (first returned value by the iterator function) as *control variable*
-- if the control variable is nil, the loop terminates
]]
local function iter(tt, i) ----> _f(_t, i)
    i = i + 1
    local v = tt[i]
    if not v then
        i = nil ----> control variable makes the loop break
    end
    return i, v
end
function ipairs3(tt)
    return iter, tt, 0 ----> _f, _t, _i
end

for i, v in ipairs3(ta) do
    print(string.format("i=%s v=%s", i, v))
end
