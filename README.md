# lua profile lib

profile c and lua fucntion and support coroutine yield.

~~~.lua
local profile = require "profile"

profile.start()

-- your code 

print(profile.dstop(10, 4)) --dump top 10 call info sort by flat_avg

-- output test
--[[
[profile] topN=10, sort=flat_avg, flat_total=1.0587s, cum_total=1.0588s
index count cum        cum_avg    flat       [flat_avg] flat%      cum%       function
[001] 1     1.0587     1.0587     1.0587     1.0587     99.9921    99.9908    [C]execute@test.lua:13
[002] 3     0.0001     0.0000     0.0001     0.0000     0.0066     0.0070     [C]print@test.lua:5
[003] 1     1.0588     1.0588     0.0000     0.0000     0.0004     99.9997    [L]foo@test.lua:10
[004] 1     1.0588     1.0588     0.0000     0.0000     0.0002     99.9990    [L]null@test.lua:4
[005] 1     0.0000     0.0000     0.0000     0.0000     0.0002     0.0003     [L]create@./profile.lua:6
[006] 1     1.0587     1.0587     0.0000     0.0000     0.0001     99.9920    [C]yield@test.lua:6
[007] 2     0.0001     0.0000     0.0000     0.0000     0.0002     0.0082     [C]resume@test.lua:11
[008] 3     0.0000     0.0000     0.0000     0.0000     0.0001     0.0002     [C]null@test.lua:5
[009] 1     1.0588     1.0588     0.0000     0.0000     0.0000     99.9995    [L]null@./profile.lua:7
[010] 1     0.0000     0.0000     0.0000     0.0000     0.0000     0.0001     [C]old_co_create@./profile.lua:7
]]

~~~
