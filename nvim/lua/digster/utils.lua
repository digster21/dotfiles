local utils = {}

-- Set neovim keymap.
--
-- Convenience wrapper around `vim.keymap.set`.
--
-- Custom Args:
--      mops(table): Custom options
--
-- Returns:
--      `vim.keymap.set(...)`
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

    return vim.keymap.set(mode, lhs, rhs, opts)
end

-- Find the path of a filename within a directory.
-- Searches recursively, and does not follow symlinks.
--
-- Args:
--      filename(str):  Name of the file to search for.
--      dirpath(str):   Root directory path to start searching from.
--      max_depth(int|nil): Maximum depth of the search. (default: 6)
--
-- Returns:
--      (str|nil) The path to filename from dirpath
function utils.resolve_path_from_name_in_dir(filename, dirpath, max_depth)
    max_depth = max_depth or 6
    local function search(dir, current_depth)
        if current_depth > max_depth then return nil end

        local fd = vim.loop.fs_scandir(dir)
        if not fd then return nil end

        while true do
            local name, type = vim.loop.fs_scandir_next(fd)
            if not name then break end

            local path = dir .. "/" .. name
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

    return search(dirpath, 0)
end

-- Find the parent directory path of a filename within a directory.
--
-- Convenience wrapper around `resolve_path_from_name_in_dir` for
-- finding the parent directory of the file.
--
-- Args:
--      filename(str):  Name of the file to search for.
--      dirpath(str):   Root directory path to start searching from.
--      max_depth(int|nil): Maximum depth of the search.
--
-- Returns:
--      (str|nil) The path to parent directory of the filename from dirpath
function utils.resolve_pathdir_from_name_in_dir(filename, dirpath, max_depth)
    local filepath = utils.resolve_path_from_name_in_dir(filename, dirpath, max_depth)
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

-- Check if a path is inside a Git Repo.
--
-- Args:
--      path(str|nil): Path to check. (default: current workspace)
--
-- Returns:
--      (bool) True if in git repo, otherwise false
function utils.is_git_repo(path)
    path = path or vim.fn.getcwd()
    local ok, result = pcall(vim.fn.systemlist,
        "git -C " .. vim.fn.shellescape(path) .. " rev-parse --is-inside-work-tree")
    return ok and result[1] == "true"
end

return utils
