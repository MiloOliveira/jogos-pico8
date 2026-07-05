---@meta

---Play sfx N (0..63) on CHANNEL (0..3) from note OFFSET (0..31 in notes) for LENGTH notes.
---
---Returns the channel index it was played on
---
---[View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#SFX)
---@param n number
---@param channel number?
---@param offset number?
---@param length number?
---@return number
function sfx(n, channel, offset, length) end

---Play music starting from pattern N (0..63)
---
---N -1 to stop music
---
---[View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#MUSIC)
---@param n any 0~63 pattern, -1 to stop music
---@param fade_len any default 0, in ms
---@param channel_mask any specifies which channels to reserve for music only
function music(n, fade_len, channel_mask) end
