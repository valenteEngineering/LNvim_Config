local whichkey = require("which-key")

-- Move the pop-up to the right side of the window
whichkey.setup({
  win = {
    border = "double",
    row = 0.25, -- 0.0 is top, 1.0 is bottom
    col = 0.9999999999, -- 0.0 is left, 1.0 is right
    no_overlap = false,
    width = 0.2
  },
})
