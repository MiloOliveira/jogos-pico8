---@meta

---Get button B state for player PL (default 0)
---
---If no parameters supplied, returns a bitfield of all 12 button states for player 0 & 1
---
---1P Button List:
---- 0 left
---- 1 right
---- 2 up
---- 3 down
---- 4 O
---- 5 X
---
---[View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#BTN)
---@param b number?
---@param pl number?
---@return number|boolean
function btn(b, pl) end

---Returns true when a button is down AND it was not down the last frame.
---
---It also repeats after 15 frames, returning true every 4 frames after that
---
------1P Button List:
---- 0 left
---- 1 right
---- 2 up
---- 3 down
---- 4 O
---- 5 X
---
---[View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#BTNP)
---@param b number?
---@param pl number?
---@return boolean
function btnp(b, pl) end
