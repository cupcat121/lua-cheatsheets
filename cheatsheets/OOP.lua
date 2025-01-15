-- meta{table,method}, then class
--
-- metatable defines operations of its instances
-- use *getmetatable* to get metatable of an object
-- it reads a *__metatable* field
print(getmetatable(""))

-- tables can be accommodated with any types of values,
-- endowed them with encapsulating any data and methods like *class* in other languages
--
-- use metatables to implement OOP (prototype in Javascript)
--
Worker = {}     ----> prototype
Worker.base_salary_intern = 1000    ----> 1k base for interns fr

-- sugar of adding functions to a table / adding methods to a metatable
function Worker.build_by_position(position, base_salary)   ----> builder
    if (not position) and position == ""  then
        error("Show u position and take u money!")
    end

    local self = {
        position = position,
        base_salary = base_salary,
    }
    local metatable = {
        __index = Worker,
    }
    -- idiom to inherit attributes from metatable
    -- setmetatable: param1--target object; param2--metatable to be derived from
    -- if object has set a metatable, it will raise errors
    return setmetatable(self, metatable)   ----> friendly to lsp completion
end

-- sugar of *Table.func(self)*,
-- *self* is the table itself, independent of its values (mostly *self* in Python)
function Worker:track_guy(name, working_age)
    -- ofc tracked guys will be placed in another container, so never mind
    if self.tracked_guys[name] then
        return
    end
    self.tracked_guys[name] = {
        salary = (self.base_salary or self.base_salary_intern) + working_age * 200,
        working_age = working_age,
    }
    self.total = self.total + 1
end

-- default *new* method to instantise from *self*
function Worker:new(obj)
    -- set attributes table to "class" itself
    self.__index = self
    -- set instance fields
    local obj = obj or {}
    obj.tracked_guys = {}
    obj.total = 0
    -- inherits attributes from "class" itself
    return setmetatable(obj, self)
end

-- subclass from the builder
Programmer = Worker.build_by_position("programmer", 3000)
Manager = Worker.build_by_position("manager", 6000)
-- *instantiation* simlar to other OOP languages
local junior_worker = Programmer:new()
local senior_worker = Programmer:new{personel_limit = 50}
local senior_manager = Manager:new{upper_limit = 20000}

junior_worker:track_guy("bob", 2)
junior_worker:track_guy("mile", 1)
junior_worker:track_guy("mile", 1)
senior_worker:track_guy("kart", 15)
senior_manager:track_guy("steve", 12)

-- lua core defines bunch of methods called *metamethod* to abstract some common operations
-- usually started with doulbe underscores *__method*
-- it's mostly *dunder methods* in Python
--
-- arithmetic metamethod
function Programmer:__add(o)
    if getmetatable(o) ~= getmetatable(self) then
        error("the operand must be a worker")
    end

    appended_guys = o.tracked_guys
    for k, v in pairs(appended_guys) do
        if not self.tracked_guys[k] then
            self.total = self.total + 1
        end
        self.tracked_guys[k] = v
    end
    return self
end

all_workers = junior_worker + senior_worker
for k, v in pairs(all_workers.tracked_guys) do
    print(k .. ": " .. v.salary)
end

-- __tostring metamethod
function Programmer:__tostring()
    return string.format("Progarmmers total: %d", self.total)
end
-- print/tostring will invoke __tostring metamethod
print(all_workers)
print(tostring(all_workers))

-- __pair metamethod (since lua5.2)
--

-- __index __newindex metamethod
--