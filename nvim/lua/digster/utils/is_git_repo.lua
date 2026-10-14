--- Check if a path is inside a Git Repo.
---
---@param path? string Path to check. (default: current workspace)
---@return boolean # True if in git repo, otherwise false
local function is_git_repo(path)
    path = path or vim.fn.getcwd()
    local ok, result = pcall(vim.fn.systemlist,
        "git -C " .. vim.fn.shellescape(path) .. " rev-parse --is-inside-work-tree")
    return ok and result[1] == "true"
end

return is_git_repo
