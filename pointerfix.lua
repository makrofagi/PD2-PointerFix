-- creds to CustomFOV for menu stuff

_G.PointerFix = _G.PointerFix or {}
PointerFix.ModPath = ModPath
PointerFix.SaveFile = PointerFix.SaveFile or SavePath .. "PointerFix.txt"
PointerFix.ModOptions = PointerFix.ModPath .. "settingsmenu.json"
PointerFix.Settings = {}


function PointerFix:Reset()
    self.Settings = {
        csens_mult = 1.0
    }
    self:Save()
end

Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_PointerFix", function(loc)
    loc:load_localization_file(PointerFix.ModPath .. "localization.txt", false)
end)

function PointerFix:Load()
    local file = io.open(self.SaveFile, "r")
    if file then
            for key, value in pairs(json.decode(file:read("*all"))) do
                    self.Settings[key] = value
            end
            file:close()
    else
        self:Reset()
    end

end

function PointerFix:Save()
    local file = io.open(self.SaveFile, "w+")
    if file then
        file:write(json.encode(self.Settings))
        file:close()
    end
end


PointerFix:Load()


if not PointerFix then
    log("[PointerFix] Error: Failed to create Mod Options menu, aborting")
    return
end

if not MenuCallbackHandler then
    log("[PointerFix] Error: MenuCallbackHandler is nil, aborting")
    return
end

local function AddModOptions(menu_manager)
    if menu_manager == nil then
            return
    end

    MenuCallbackHandler.pointerfix_save = function(node)
            PointerFix:Save()
    end

    MenuCallbackHandler.set_csens_mult = function(self, item)
        PointerFix.Settings.csens_mult = item:value()
    end
    
    MenuHelper:LoadFromJsonFile(PointerFix.ModOptions, PointerFix, PointerFix.Settings)
end

Hooks:Add("MenuManagerInitialize", "PointerFix_AddModOptions", AddModOptions)



