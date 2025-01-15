-- dynamically load a file
--
-- *dofile* will run the chunks of code and raise errors
dofile("cheatsheets/fundamental.lua")
-- *load{file,} doesn't actually run the code instead returning it as a function
f1 = loadfile("cheatsheets/fundamental.lua")
f2 = load("print('im in *loadstring*')")()
f3 = assert(load("local a = 'load';print('im in ' .. a)"))()      -----> more robust


-- module
--
-- use *require* to load a module
local Math = require "math"
-- *require* will add an entry in *package.loaded* when you import a module
-- it prevents you load a module twice
print(package.loaded['math'])
-- module search path can be found in *package.path* (pure lua module) and *package.cpath* (native library)
print(package.path, package.cpath)
-- use *package.loadlib* to load a native library


-- build a module
local M = {}
M.a = 1

-- you can make a init function and simply retrun *M*
-- this idiom is usually applied to configure a module after loading it
function init(v)
    M.a = v
    return M
end

-- returns when this file's *required* (require(module))
return M