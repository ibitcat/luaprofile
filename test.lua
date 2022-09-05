local profile = require "profile"
profile.start()

local co = coroutine.create(function(value)
    print("coroutine--->111")
    coroutine.yield("yield !!!")
    print("coroutine--->222")
end)

function foo()
    local ok, str = coroutine.resume(co,123)
    print(str)
    os.execute("sleep 1")
    coroutine.resume(co,456)
end

foo()
print(profile.report(10, 1))
os.execute("sleep 2")
print(profile.dstop(10, 4))
