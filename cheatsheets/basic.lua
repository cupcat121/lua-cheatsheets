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


-- varibale scope
-- all variables are global by default

-- declare a local variable
-- local variables has its scope limited to the block
-- a block may be a control structures, function body, or just the current file (chunk)
local a;    ----> its scope has it limited to the chunk here (the current file)
local b = a
-- *local* denotes declaration
local a = 1     -- *a* is declared twice, and creates a brand-new local variable named *a*
print(b)    ----> nil (*b* points to the first *a*)

local function fa(...)
    return ...
end

-- *do end* blocks denote scopes in lua simalar to *{}* code blocks in C-like language
local a = 2
do
    local a = 1
    print(a)    ----> 1 (shadowed)
end
print(a)    ----> 2


-- control flow structures
--
-- expressions

-- concatenated expressions are evaluated from right to left
print(0.1 ^ 2 ^ 2 ^ 256) ----> 0.1 ^ (2 ^ (2 ^ 64))


-- statements
--
-- multiple statements can be put in one line
x = 1 y = 2     ----> not recommended!
x = 1; y = 2

-- assignment
-- evaluate then assign values
x, y = 1, 2
x, y = y, x ----> common lua idiom to swap two values

-- *if else* structure
if nil then
    print "i will never print"
elseif 0 then
    print "i will always print"
else
    print "im a teapot"
end

-- *while* structure
-- *break* to jump out of the inner loop
while nil do
    while false do
        print "i will never print"
        break
    end
end

-- *repeat-until* structure
-- stop the loop until the condition is true
i = -5
repeat
    i = i + 1
    print(i)
until i == 0

-- C' style for structure
-- *goto* statement is same as C language' s, avoid to use it as far as possible
for i = 1, 5, 1 do
    if i %2 == 0 then
        -- common lua idiom to continue a loop (lua has no native continue statement)
        goto continue
    end
    print(i)
    -- labels can not be visible out of the block, they are *local*
    ::continue::
end

-- generic for structure
for i, v in pairs{a = 1, b = 2} do
    print(i .. " = " .. v)
end