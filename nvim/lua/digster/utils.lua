local utils = {}

function utils.keymap_set(mode, lhs, rhs, opts, mops)
    opts = opts or {}
    mops = (type(mops) == "table" and mops) or {}
    local debug_enabled = mops.debug or false

    if debug_enabled then
        local trace = debug.getinfo(2, "Sl")
        local info = string.format(
            "[keymap] mode=%s lhs=%s rhs=%s opts=%s @ %s:%d",
            vim.inspect(mode),
            vim.inspect(lhs),
            type(rhs) == "string" and rhs or "<function>",
            vim.inspect(opts),
            trace.short_src,
            trace.currentline
        )
        vim.notify(info, vim.log.levels.DEBUG)
    end

    vim.keymap.set(mode, lhs, rhs, opts)
end

function utils.find_file_path(filename, dir, depth)
    depth = depth or 6
    local function search(d, current_depth)
        if current_depth > depth then return nil end

        local fd = vim.loop.fs_scandir(d)
        if not fd then return nil end

        while true do
            local name, type = vim.loop.fs_scandir_next(fd)
            if not name then break end

            local path = d .. "/" .. name
            if name == filename then
                return path
            elseif type == "directory" then
                if vim.loop.fs_realpath(path) == path then
                    local found = search(path, current_depth + 1)
                    if found then return found end
                end
            end
        end
        return nil
    end

    return search(dir, 0)
end

function utils.find_file_dir(filename, dir, depth)
    local filepath = utils.find_file(filename, dir, depth)
    if filepath then
        return vim.fn.fnamemodify(filepath, ":h")
    end
    return nil
end

function utils.lsp_get_workspace()
    local root = vim.fn.getcwd()
    return {
        name = vim.fn.fnamemodify(root, ":t"),
        uri = vim.uri_from_fname(root),
    }
end

return utils
