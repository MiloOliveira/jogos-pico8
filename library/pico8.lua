---@meta

-- Main Loop

---Called once at startup, just before the main loop.
---
---[View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#PICO_8_Program_Structure)
function _init() end

---Called 30 times per second.
---Define _update60() instead if you want 60FPS
---
---[View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#PICO_8_Program_Structure)
function _update() end

---Called 60 times per second.
---
---[View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#_UPDATE60)
function _update60() end

---Called each time the window manager asks for a frame.
---normally 60, 30 or 15 times per second
---
---[View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#PICO_8_Program_Structure)
function _draw() end
