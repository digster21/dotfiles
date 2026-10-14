-- Check if a path is inside a Git Repo.
--
-- Args:
--      path(str|nil): Path to check. (default: current workspace)
--
-- Returns:
--      (bool) True if in git repo, otherwise false
return function(path)
    path = path or vim.fn.getcwd()
    local ok, result = pcall(vim.fn.systemlist,
        "git -C " .. vim.fn.shellescape(path) .. " rev-parse --is-inside-work-tree")
    return ok and result[1] == "true"
end
