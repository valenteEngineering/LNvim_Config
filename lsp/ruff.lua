return {
  cmd = { "ruff" },
  filetypes = { "python" },
  root_markers = { "pyproject.toml", "ruff.toml", ".git" },
  init_options = {
    settings = {
      args = {}, -- you can pass extra CLI flags here (like --line-length 88)
    }
  }
}
