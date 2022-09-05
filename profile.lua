local c = require "profile.c"
local mark = c.mark

local old_co_create = coroutine.create
local old_co_wrap = coroutine.wrap
local function coroutine_create(f)
    return old_co_create(function (...)
            mark()
            return f(...)
        end)
end

local function coroutine_wrap(f)
    return old_co_wrap(function (...)
            mark()
            return f(...)
        end)
end

local M = {}
function M.dump(records, count, sort)
    -- 排序类型
    -- 注意：cum_total 一定会比 flat_total 大，因为cum包含了hook函数的耗时
    local sort_type = {
        [1] = "cum",            -- 按 函数自身+调用其他函数的总耗时 排序
        [2] = "cum_avg",        -- 按 cum平均耗时 排序
        [3] = "flat",           -- 按 函数自身运行总耗时(排除了子函数调用耗时) 排序
        [4] = "flat_avg",       -- 按 flat平均耗时 排序
    }
    local sorted = sort_type[sort]
    local head = string.format("[profile] topN=%d, sort=%s, flat_total=%.4fs, cum_total=%.4fs",
        count, string.format("\27[31m%s\27[0m", sorted), records.flat_total, records.cum_total)
    sort_type[sort] = string.format("[%s]", sorted)
    local title = string.format("%s %s %-10s %-10s %-10s %-10s %-10s %-10s %s",
            "index", "count", sort_type[1], sort_type[2], sort_type[3], sort_type[4], "flat%", "cum%", "function")
    local ret = {head, title}
    for i,v in ipairs(records) do
        local s = string.format("[%03d] %-5d %-10.4f %-10.4f %-10.4f %-10.4f %-10.4f %-10.4f [%s]%s%s:%d",
            i, v.count, v.cum, v.cum_avg, v.flat, v.flat_avg, v.flat_percent*100, v.cum_percent*100, v.flag, v.name, v.source, v.line)
        ret[#ret+1] = s
    end
    return table.concat(ret, "\n")
end

function M.start()
    c.init()
    c.start()
    coroutine.create = coroutine_create
    coroutine.wrap = coroutine_wrap
end

function M.stop()
    c.destory()
    coroutine.create = old_co_create
    coroutine.wrap = old_co_wrap
end

function M.report(count, sort)
    local records = c.dump(count, sort)
    return M.dump(records, count, sort)
end

-- 一次性采样
function M.dstop(count, sort)
    local records = c.stop(count, sort)
    M.stop()
    return M.dump(records, count, sort)
end

return M
