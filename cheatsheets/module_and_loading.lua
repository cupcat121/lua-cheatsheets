-- dynamically load a file
--
-- *dofile* will run the chunks of code and raise errors
dofile("cheatsheets/fundamental.lua")
-- *load{file,} doesn't actually run the code instead returning it as a function
f1 = loadfile("cheatsheets/fundamental.lua")
f2 = load("print('im in *loadstring*')")()
f3 = assert(load("local a = 'load';print('im in ' .. a)"))()      -----> more robust