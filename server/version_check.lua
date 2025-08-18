local function parseVersion(version)
    if not version or type(version) ~= "string" then return {} end
    local parts = {}
    for num in version:gmatch("%d+") do
        parts[#parts + 1] = tonumber(num)
    end
    return parts
end

local function compareVersions(current, newest)
    local currentParts = parseVersion(current)
    local newestParts = parseVersion(newest)
    local maxLen = math.max(#currentParts, #newestParts)
    
    for i = 1, maxLen do
        local c = currentParts[i] or 0
        local n = newestParts[i] or 0
        if c ~= n then
            return c < n and -1 or 1
        end
    end
    return 0
end

function CheckVCDiscordVersion()
    if not IsDuplicityVersion() then return end
    
    CreateThread(function()
        Wait(4000)
        
        local currentVersionRaw = GetResourceMetadata("vc_discord", 'version', 0)
        if not currentVersionRaw or currentVersionRaw == "unknown" then
            local manifest = LoadResourceFile("vc_discord", "fxmanifest.lua")
            if manifest then
                currentVersionRaw = string.match(manifest, 'version%s*[\'"]([^\'"]+)[\'"]')
            end
        end
        
        if not currentVersionRaw then
            print("^1Unable to determine current version for ^7'^3vc_discord^7'")
            return
        end
        
        PerformHttpRequest('https://api.github.com/repos/VCScripts/vc_discord/releases/latest', function(err, body, headers)
            if not body then
                print("^1Unable to run version check for ^7'^3vc_discord^7' (^3"..currentVersionRaw.."^7)")
                return
            end

            local data = json.decode(body)
            if not data or not data.tag_name then
                print("^1Unable to parse GitHub release data for ^7'^3vc_discord^7'")
                return
            end

            local newestVersionRaw = data.tag_name:gsub("v", "")
            local compareResult = compareVersions(currentVersionRaw, newestVersionRaw)

            if compareResult == 0 then
                print("^7'^3vc_discord^7' - ^2You are running the latest version^7. ^7(^3"..currentVersionRaw.."^7)")
            elseif compareResult < 0 then
                print("^7'^3vc_discord^7' - ^1You are running an outdated version^7! ^7(^3"..currentVersionRaw.."^7 → ^3"..newestVersionRaw.."^7)")
                if data.html_url then
                    print("^7Download: ^3" .. data.html_url)
                end
            else
                print("^7'^3vc_discord^7' - ^5You are running a newer version ^7(^3"..currentVersionRaw.."^7 ← ^3"..newestVersionRaw.."^7)")
            end
        end, "GET", "", {
            ["User-Agent"] = "VC_Discord-VersionChecker/1.0"
        })
    end)
end

CheckVCDiscordVersion()
