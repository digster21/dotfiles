-- ============================================================================
-- TABWIDTH
-- ============================================================================

-- ============================================================================
-- Types
-- ============================================================================

---@class TabwidthConfig
---@field shiftwidth? integer
---@field tabstop? integer
---@field softtabstop? integer

---@class TabwidthOpts
---@field global? TabwidthConfig
---@field local? table<number,TabwidthConfig>
---@field filetype? table<string, TabwidthConfig>


-- ============================================================================
-- Global State
-- ============================================================================

local TabwidthAPI = {}

-- ============================================================================
-- Functions
-- ============================================================================

--- Validate input width as a positive integer or nil.
---@param width? number Width to sanitize
---@return integer? width
function TabwidthAPI.sanitize_width(width)
        vim.validate({
                width = { width, "number", true },
        })

        -- Ensure that width is a positive integer
        if width == nil or width % 1 ~= 0 or width < 1 then
                return nil
        end

        return width
end

--- Validate input config.
--- @param cfg TabwidthConfig
--- @return TabwidthConfig
function TabwidthAPI.sanitize_config(cfg)
        local out = {}

        if cfg.tabstop then
                local ts = TabwidthAPI.sanitize_width(cfg.tabstop)
                if ts then
                        out.tabstop = ts
                end
        end

        if cfg.softtabstop then
                local sts = TabwidthAPI.sanitize_width(cfg.softtabstop)
                if sts then
                        out.softtabstop = sts
                end
        end

        if cfg.shiftwidth then
                local sw = TabwidthAPI.sanitize_width(cfg.shiftwidth)
                if sw then
                        out.shiftwidth = sw
                end
        end

        return out
end

--- Print the configured tabwidth
--- @param cfg TabwidthConfig
function TabwidthAPI.print(cfg)
        if cfg.shiftwidth == cfg.tabstop and cfg.shiftwidth == cfg.softtabstop then
                print(cfg.shiftwidth)
                return
        end

        -- Fallback to printing entire config obj
        local parts = {}
        for k, v in pairs(cfg) do
                table.insert(parts, k .. "=" .. v)
        end
        print(table.concat(parts, ", "))
end

--- Print the global indentation config.
function TabwidthAPI.print_global()
        TabwidthAPI.print({
                shiftwidth = vim.api.nvim_get_option_value("shiftwidth", { scope = "global" }),
                tabstop = vim.api.nvim_get_option_value("tabstop", { scope = "global" }),
                softtabstop = vim.api.nvim_get_option_value("softtabstop", { scope = "global" }),
        })
end

--- Print the indentation config for a filetype.
--- @param ft string filetype
function TabwidthAPI.print_filetype(ft)
        TabwidthAPI.print({
                shiftwidth = vim.api.nvim_get_option_value("shiftwidth", { filetype = ft }),
                tabstop = vim.api.nvim_get_option_value("tabstop", { filetype = ft }),
                softtabstop = vim.api.nvim_get_option_value("softtabstop", { filetype = ft }),
        })
end

--- Print the indentation config for a buffer.
--- @param buf integer buffer id
function TabwidthAPI.print_local(buf)
        TabwidthAPI.print({
                shiftwidth = vim.api.nvim_get_option_value("shiftwidth", { buf = buf }),
                tabstop = vim.api.nvim_get_option_value("tabstop", { buf = buf }),
                softtabstop = vim.api.nvim_get_option_value("softtabstop", { buf = buf }),
        })
end

--- Set the configured tabwidth
--- @param cfg TabwidthConfig
--- @param opt vim.api.keyset.option
function TabwidthAPI.set_cfg(cfg, opt)
        if cfg.shiftwidth then
                vim.api.nvim_set_option_value("shiftwidth", cfg.shiftwidth, opt)
        end

        if cfg.tabstop then
                vim.api.nvim_set_option_value("tabstop", cfg.tabstop, opt)
        end

        if cfg.softtabstop then
                vim.api.nvim_set_option_value("softtabstop", cfg.softtabstop, opt)
        end
end

--- Set the configured tabwidth.
--- @param cfg TabwidthConfig
function TabwidthAPI.set_global(cfg)
        TabwidthAPI.set_cfg(cfg, { scope = "global" })
end

--- Set the configured tabwidth for a filetype.
--- @param ft string filetype
--- @param cfg TabwidthConfig
function TabwidthAPI.set_filetype(ft, cfg)
        TabwidthAPI.set_cfg(cfg, { filetype = ft })
end

--- Set the configured tabwidth for a buffer.
--- @param buf integer buffer id
--- @param cfg TabwidthConfig
function TabwidthAPI.set_local(buf, cfg)
        TabwidthAPI.set_cfg(cfg, { buf = buf })
end

--- Setup Tabwidth.
--- @param opts TabwidthOpts
function TabwidthAPI.setup(opts)
        -- Configure Tabwidth options
        if opts then
                if opts.global then
                        local global_cfg = TabwidthAPI.sanitize_config(opts.global)
                        TabwidthAPI.set_global(global_cfg)
                end
        end

        -- Configure User command
        vim.api.nvim_create_user_command("Tabwidth", function(options)
                local argc = #options.fargs

                if argc == 0 then
                        -- TabwidthAPI.print()
                        return
                end

                if argc ~= 2 then
                        vim.notify("Invalid usage. Expects :Tabwidth <scope> <width>", vim.log.levels.ERROR)
                        return
                end

                local scope = options.fargs[1]
                local width = TabwidthAPI.sanitize_width(tonumber(options.fargs[2]))

                if width == nil then
                        vim.notify("Invalid usage. Expects <width> to be a positive integer", vim.log.levels.ERROR)
                        return
                end

                if scope == "default" then
                        TabwidthAPI.set_default(width)
                elseif scope == "ft" then
                        TabwidthAPI.set_ft(vim.bo.filetype, width)
                else
                        vim.notify("Invalid usage. Expects <scope> to be 'default' or 'ft'", vim.log.levels.ERROR)
                        return
                end
        end, {
                nargs = "*"
        })
end

return TabwidthAPI
