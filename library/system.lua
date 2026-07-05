---@meta

---Load a cartidge
---
---[View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#LOAD)
---@param filename string
---@param breadcrumb string?
---@param param_str string?
function load(filename, breadcrumb, param_str) end

---Save a cartidge
---
---[View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#SAVE)
---@param filename string
function save(filename) end

---Open the carts folder in the host operating system.
---
---[View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#FOLDER)
function folder() end

---List .p8 and .p8.png files in given directory (folder), relative to the current directory.
---
---Items that are directories end in a slash (e.g. "foo/").
---
---[View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#LS)
---@param directory string?
function ls(directory) end

---Run from the start of the program.
---
---[View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#RUN)
---@param param_str string?
function run(param_str) end

---Stop the cart and optionally print a message.
---
---[View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#STOP)
---@param message any?
function stop(message) end

---Resume the program.
---
---Use R for short.
---
---[View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#RESUME)
function resume() end

---If CONDITION is false, stop the program and print MESSAGE if it is given. This can be useful for debugging cartridges, by ASSERT()'ing that things that you expect to be true are indeed true.
---```
---ASSERT(ADDR >= 0 AND ADDR <= 0x7FFF, "OUT OF RANGE")
---POKE(ADDR, 42) -- THE MEMORY ADDRESS IS OK, FOR SURE!
---```
---[View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#ASSERT)
---@param condition any
---@param message any?
function assert(condition, message) end

---Reboot the machine Useful for starting a new project
---
---[View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#REBOOT)
function reboot() end

---Reset the values in RAM from 0x5f00..0x5f7f to their default values. This includes the palette, camera position, clipping and fill pattern. If you get lost at the command prompt because the draw state makes viewing text impossible, try typing RESET! It can also be called from a running program.
---
---[View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#RESET)
function reset() end

---Print out some information about the cartridge: Code size, tokens, compressed size
---
---Also displayed:
---- UNSAVED CHANGES   When the cartridge in memory differs to the one on disk
---- EXTERNAL CHANGES  When the cartridge on disk has changed since it was loaded
---
---[View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#INFO)
function info() end

---Flip the back buffer to screen and wait for next frame.
---
---[View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#FLIP)
function flip() end

---Print a string to the host operating system's console for debugging.
---
---[View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#PRINTH)
---@param str any
---@param filename string? -- If filename is set, append the string to a file on the host operating system
---@param overwrite boolean? -- Setting OVERWRITE to true causes that file to be overwritten rather than appended.
---@param save_to_desktop boolean? -- Setting SAVE_TO_DESKTOP to true saves to the desktop instead of the current path.
function printh(str, filename, overwrite, save_to_desktop) end

---Returns the number of seconds elapsed since the cartridge was run.
---
---This is not the real-world time, but is calculated by counting the number of times

---Returns the number of seconds elapsed since the cartridge was run.
---
---This is not the real-world time, but is calculated by counting the number of times
---
---[View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#TIME)
function time() end

---Returns the number of seconds elapsed since the cartridge was run.
---
---This is not the real-world time, but is calculated by counting the number of times
---
---[View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#T)
function t() end

---Get system status where X is:
---```
---0  Memory usage (0..2048)
---1  CPU used since last flip (1.0 == 100% CPU)
---4  Clipboard contents (after user has pressed CTRL-V)
---6  Parameter string
---7  Current framerate
---
---46..49  Index of currently playing SFX on channels 0..3
---50..53  Note number (0..31) on channel 0..3
---54      Currently playing pattern index
---55      Total patterns played
---56      Ticks played on current pattern
---57      (Boolean) TRUE when music is playing
---
---80..85  UTC time: year, month, day, hour, minute, second
---90..95  Local time
---
---100     Current breadcrumb label, or nil
---110     Returns true when in frame-by-frame mode
---```
---[View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#STAT)
---@param x number
---@return any
function stat(x) end

---Special system command, where CMD_STR is a string:
---```
---"pause"         request the pause menu be opened
---"reset"         request a cart reset
---"go_back"       return to the previous cart if there is one
---"label"         set cart label
---"screen"        save a screenshot
---"rec"           set video start point
---"rec_frames"    set video start point in frames mode
---"video"         save a .gif to desktop
---"audio_rec"     start recording audio
---"audio_end"     save recorded audio to desktop (no supported from web)
---"shutdown"      quit cartridge (from exported binary)
---"folder"        open current working folder on the host operating system
---"set_filename"  set the filename for screenshots / gifs / audio recordings
---"set_title"     set the host window title
---```
---[View Online](https://www.lexaloffle.com/dl/docs/pico-8_manual.html#EXTCMD)
---@param cmd_str any
---@param p1 number?
---@param p2 number?
function extcmd(cmd_str, p1, p2) end
