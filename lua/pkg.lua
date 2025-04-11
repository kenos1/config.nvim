Pkg = {
        --- @type string
        plugins_dir = vim.fn.stdpath("config") .. "/plugins/",
        --- @type Table<string, PkgPlugin>
        plugins = {},
        --- @type string
        log_buffer = ""
}

--- @class PkgPlugin
--- @field dir string
--- @field loaded boolean
--- @field subscribers function[]


--- @param level "debug" | "info" | "warn" | "error"
--- @param message string
function Pkg.log(level, message)
        Pkg.log_buffer = Pkg.log_buffer .. level:upper() .. ": " .. message .. "\n"
end

--- @param name string
function Pkg.use(name)
        Pkg.plugins[name] = {
                dir = Pkg.plugins_dir .. name,
                loaded = false,
                subscribers = {}
        }
        vim.opt.runtimepath:prepend(Pkg.plugins[name].dir)
end

function Pkg.subscribe(name, callback)
        table.insert(Pkg.plugins[name].subscribers, callback)
end

function Pkg.setup_plugin(name, opts)
        Pkg.subscribe(name, function()
                require(name).setup(opts)
        end)
end

function Pkg.load(name)
        --- @type PkgPlugin
        local plugin = Pkg.plugins[name]
        if not plugin then
                Pkg.log("error", "Plugin " .. name .. " not found!")
        end

        for _, callback in ipairs(plugin.subscribers) do
                callback()
        end

        plugin.loaded = true
end

function Pkg.load_on_event(name, events)
        vim.api.nvim_create_autocmd(events, {
                callback = function() Pkg.load(name) end,
                once = true
        })
end

function Pkg.list()
end

function Pkg.setup()
        vim.api.nvim_create_user_command("PkgList", function()
                local buffer = ""

                local max_len = 0
                for k, _ in pairs(Pkg.plugins) do
                        max_len = math.max(max_len, string.len(k))
                end

                for plugin, plugin_data in pairs(Pkg.plugins) do
                        local padding = max_len - string.len(plugin)
                        local loaded_str = "Not Loaded ✘"
                        if plugin_data.loaded then
                                loaded_str = "Loaded ✔"
                        end

                        buffer = buffer .. plugin .. string.rep(" ", padding) .. " : " .. loaded_str .. "\n"
                end

                print(buffer)
        end, {})
end

return Pkg
