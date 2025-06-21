local keyEncryptor
local httpService = game:GetService("HttpService")
local request = syn and syn.request or request or http_request

-- Bit manipulation helpers
local function mod32(v) return v % 4294967296 end

local function bitxor(a, b)
    local res, power = 0, 1
    while a > 0 or b > 0 do
        local bitA, bitB = a % 2, b % 2
        if bitA ~= bitB then res = res + power end
        a = math.floor(a / 2)
        b = math.floor(b / 2)
        power = power * 2
    end
    return res
end

local function shiftLeft(val, shift) return mod32(val * 2 ^ shift) end
local function shiftRight(val, shift) return math.floor(val / 2 ^ shift) % 4294967296 end

-- Key Encryptor
function keyEncryptor(input)
    local p = {0x5AD69B68, 0x03B7222A, 0x2D074DF6, 0xCB4FFF2D}
    local q = {0x01C3, 0xA408, 0x964D, 0x4320}
    local index = 1
    local inputLength = #input

    while index <= inputLength do
        local chunk = 0
        for i = 0, 3 do
            local charIndex = index - 1 + i
            if charIndex < inputLength then
                local char = input:byte(charIndex + 1)
                chunk = chunk + char * 2 ^ (8 * i)
            end
        end
        chunk = mod32(chunk)

        for x = 1, 4 do
            local v = bitxor(p[x], chunk)
            local z = p[x % 4 + 1]
            v = bitxor(v, z)
            v = mod32(shiftLeft(v, 5) + shiftRight(v, 2) + q[x])
            local bitOffset = ((x - 1) * 5) % 32
            local b = shiftRight(chunk, bitOffset)
            v = bitxor(v, b)
            v = mod32(v)
            p[x] = mod32(v + p[(x + 1) % 4 + 1])
        end

        index = index + 4
    end

    for x = 1, 4 do
        local y = mod32(p[x] + p[x % 4 + 1])
        y = bitxor(y, p[(x + 2) % 4 + 1])
        local shift = x * 7 % 32
        y = mod32(shiftLeft(y, shift) + shiftRight(y, 32 - shift))
        p[x] = y
    end

    local result = {}
    for x = 1, 4 do
        result[x] = string.format("%08X", p[x])
    end

    return table.concat(result)
end

-- JSON decode helper
local function decodeJSON(body)
    return httpService:JSONDecode(body)
end

-- Key check logic
local function checkKey(key)
    local timestamp = os.time()
    key = tostring(key)
    local scriptId = tostring(_G.script_id or "unknown")

    local syncResp = request({
        Method = "GET",
        Url = "https://sdkapi-public.luarmor.net/sync"
    })

    local syncData = decodeJSON(syncResp.Body)
    local nodes = syncData.nodes
    local endpoint = nodes[math.random(1, #nodes)]
    local serverTimeOffset = syncData.st - timestamp
    timestamp = timestamp + serverTimeOffset

    local url = endpoint .. "check_key?key=" .. key .. "&script_id=" .. scriptId

    local resp = request({
        Method = "GET",
        Url = url,
        Headers = {
            ["clienttime"] = tostring(timestamp),
            ["catcat128"] = keyEncryptor(key .. "_cfver1.0_" .. scriptId .. "_time_" .. timestamp)
        }
    })

    return decodeJSON(resp.Body)
end

-- Cache management
local function clearCache()
    local scriptId = tostring(_G.script_id)
    if not scriptId:match("^[a-f0-9]{32}$") then return end

    pcall(writefile, scriptId .. "-cache.lua", "recache is required")
    wait(0.1)
    pcall(delfile, scriptId .. "-cache.lua")
end

-- Loader
local function loadRemoteScript()
    local scriptId = tostring(_G.script_id)
    local code = game:HttpGet("https://api.luarmor.net/files/v3/loaders/" .. scriptId .. ".lua")
    loadstring(code)()
end

-- Return interface
return setmetatable({}, {
    __index = function(_, k)
        local encrypted = keyEncryptor(k)
        if encrypted == "30F75B193B948B4E965146365A85CBCC" then return checkKey end
        if encrypted == "2BCEA36EB24E250BBAB188C73A74DF10" then return clearCache end
        if encrypted == "75624F56542822D214B1FE25E8798CC6" then return loadRemoteScript end
        return nil
    end,
    __newindex = function(_, k, v)
        if k == "script_id" then
            _G.script_id = v
        end
    end
})
