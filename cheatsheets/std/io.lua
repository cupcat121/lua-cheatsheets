---@diagnostic disable: lowercase-global

-- IO operation

-- open a file
fp = io.open(".gitignore", "r")
print(fp)
-- if file does not exist, *io.open* will return a nil
-- common idiom to guard the operation
fp2 = assert(io.open("__not_existed__", "r"), "bonk!")

-- close a file
fp:close()