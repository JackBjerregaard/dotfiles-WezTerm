# yabai + skhd → AeroSpace

Migrated 2026-08-29. This file records why the macOS window manager changed,
the complete keybind mapping, what was deleted, and what was genuinely lost.

---

## Why

Three reasons, in order of weight.

### 1. SIP is enabled, and yabai needs it off to be good

`csrutil status` on this machine reports `enabled`, and that is not changing.
yabai's scripting addition — required for creating and destroying spaces, window
animations, and several focus behaviours — needs SIP partially disabled.

Running yabai with SIP on meant paying its full complexity cost for a degraded
version of it:

- `yabai -m space --create` failed with
  `cannot create space due to an error with the scripting-addition`, so the nine
  spaces the keybinds assumed had to be created **by hand in Mission Control**,
  and `scripts/yabai-ensure-min-spaces.sh` existed purely to warn when they
  weren't.
- `window_animation_duration 0.25` in `.yabairc` was silently ignored:
  `requires System Integrity Protection to be partially disabled! ignoring request`.
- `space --destroy` was additionally broken on macOS Tahoe even *with* the
  addition loaded ([yabai#2730](https://github.com/koekeishiya/yabai/issues/2730), cited as `asmvik/yabai#2730` in the old `.skhdrc`),
  so the dynamic-spaces model was unreachable either way.

AeroSpace assumes SIP is enabled. That is its normal operating mode, not a
degraded one, because it never asks macOS for anything privileged.

### 2. Fighting the macOS Spaces animation cost ~360 lines of shell

yabai drives real macOS Spaces, so every space switch went through the system's
transition animation — and the config had to race it. The tell was the retry
loops:

| Script | Lines | What it was working around |
|---|---|---|
| `yabai-focus-current-space-window.sh` | 50 | 12 retries at 30ms, landing focus on a real window after a space change |
| `yabai-unzoom-space.sh` | 51 | 10 retries, un-zooming before a new window appears |
| `open-app-current-space.sh` | 69 | up to 40 polls at 50ms waiting for a new window, then dragging it onto the current space |
| `open-safari-current-space.sh` | 62 | same, plus AppleScript to force a new Safari document |
| `open-url-current-space.sh` | ~60 | same, for a URL in Brave |
| `yabai-focus-space.sh` | 35 | checking a space exists, trying (always failing) to create it |
| `yabai-ensure-min-spaces.sh` | 32 | warning that spaces can't be created under SIP |
| `yabai-move-window-to-space.sh` | ~40 | move + follow + re-focus, with create fallback |
| `yabai-move-window-to-relative-space.sh` | ~40 | same, relative |
| `yabai-move-window-to-display.sh` | ~30 | move to display, then re-focus |
| `yabai-destroy-empty-spaces.sh` | ~30 | dead code — needs the scripting addition |
| `restart-macos-ui.sh` (old) | 47 | recovering launchd services from `launchctl disable` |

AeroSpace does not use macOS Spaces at all. A workspace is "the set of windows
currently positioned on screen"; switching moves the others to coordinates far
off-screen. macOS never sees a space change, so **there is no animation to
race**, and every one of those retry loops became unnecessary rather than being
ported.

### 3. It removes one of the two event taps implicated in the wake freeze

`~/Desktop/mac-freeze-and-yabai-notes.md` documents a recurring full-system
freeze after waking from a closed lid. WindowServer spins in
`add_event_vector_to_tap` — its event-tap delivery path — pushing input into a
tap whose client stopped draining it, until all input dies at once.

Two third-party CGEventTaps were stacked on this machine: **skhd** and
**Karabiner**. AeroSpace has built-in hotkey handling and registers **no event
tap**, so dropping skhd removes one of the two suspects. Karabiner stays,
because held Caps Lock → Hyper drives 48 bindings and nothing lighter
(`hidutil`, macOS's native Modifier Keys panel) can do a dual-role tap/hold key.

That also turns the freeze investigation into a clean single-variable test for
the first time: if it recurs with only Karabiner's tap left, Karabiner is the
cause.

> Note: yabai itself was **ruled out** as the freeze cause — it was
> `launchctl disable`d and not running during the confirmed 2026-08-18 event.
> This migration is not a freeze fix. It removes one suspect and a large amount
> of complexity; the freeze is still under investigation.
>
> **Result, same evening (2026-08-29):** roughly 40 minutes after skhd was
> uninstalled, WindowServer spiked to 40–90% CPU for ~6 minutes and all input
> degraded — an unmovable cursor and sluggish Spotlight. So **skhd was not the
> cause.** Karabiner is now the only third-party `CGEventTap` on the machine.
> Details and the corrected measurements are in
> `~/Desktop/mac-freeze-and-yabai-notes.md`.

---

## Keybind mapping

All 79 `.skhdrc` bindings were translated. Nothing was dropped.

`hyper` = `ctrl + alt + cmd`. Every hyper action is bound twice in
`aerospace.toml` — once under `ctrl-alt-cmd-*` and once under
`shift-ctrl-alt-cmd-*` — because Karabiner maps held Caps Lock to all four
modifiers while the physical cluster is three. `.skhdrc` did the same.

### Applications

| Key | yabai + skhd | AeroSpace |
|---|---|---|
| `alt + return` | `open-app-current-space.sh WezTerm …` | `exec-and-forget open -na …/WezTerm.app` |
| `alt + b` | `open-safari-current-space.sh` | `exec-and-forget osascript … make new document` |
| `alt + y` | `open-url-current-space.sh "Brave Browser" … youtube` | `exec-and-forget open -na …/Brave --args --new-window …` |
| `alt + q` | `window --close` | `close` |

### Focus

| Key | yabai + skhd | AeroSpace |
|---|---|---|
| `alt + h/j/k/l` | `window --focus west/south/north/east` | `focus left/down/up/right` |
| `alt + s` | `display --focus west` + focus helper | `focus-monitor --wrap-around left` |
| `alt + g` | `display --focus east` + focus helper | `focus-monitor --wrap-around right` |

### Workspaces

| Key | yabai + skhd | AeroSpace |
|---|---|---|
| `alt + p` | `space --focus prev` | `workspace --wrap-around prev` |
| `alt + n` | `space --focus next` | `workspace --wrap-around next` |
| `ctrl + 1..9` | `yabai-focus-space.sh N` | `workspace N` |

`--wrap-around` is a deliberate improvement: yabai errored at the ends.

### Layout

| Key | yabai + skhd | AeroSpace |
|---|---|---|
| `hyper + e` | `space --balance` | `balance-sizes` |
| `hyper + r` | `space --rotate 270` | `layout tiles horizontal vertical` |
| `hyper + y` | `space --mirror y-axis` | `flatten-workspace-tree` ⚠ repurposed |
| `hyper + x` | `space --mirror x-axis` | `layout accordion tiles` ⚠ repurposed |
| `hyper + f` | `window --toggle native-fullscreen` | `macos-native-fullscreen` |
| `hyper + m` | `window --toggle zoom-fullscreen` | `fullscreen` |
| `hyper + t` | `window --toggle float --grid 4:4:1:1:2:2` | `layout floating tiling` |

AeroSpace has no mirror command. Rather than leave two dead keys, `y` and `x`
were pointed at two operations it does have and that are genuinely useful.
`hyper + t` floats the window but does not place it on a grid — macOS restores
its last floating frame.

### Movement

| Key | yabai + skhd | AeroSpace |
|---|---|---|
| `hyper + h/j/k/l` | `window --swap …` | `swap --swap-focus left/down/up/right` |
| `ctrl + alt + h/j/k/l` | `window --warp …` | `move left/down/up/right` |
| `hyper + s` / `+ g` | `yabai-move-window-to-display.sh west/east` | `move-node-to-monitor --focus-follows-window left/right` |
| `hyper + p` / `+ n` | `…-to-relative-space.sh prev/next` | `move-node-to-workspace --wrap-around prev/next` |
| `shift + hyper + p` / `+ n` | same `--follow` | same `--focus-follows-window` |
| `hyper + 1..9` | `yabai-move-window-to-space.sh N` | `move-node-to-workspace N` |
| `shift + hyper + 1..9` | same `--follow` | `move-node-to-workspace --focus-follows-window N` |

### Resize

| Key | yabai + skhd | AeroSpace |
|---|---|---|
| `cmd + ctrl + h` | `window west --resize right:-20:0 \|\| …` | `resize width -50` |
| `cmd + ctrl + l` | `window east --resize left:20:0 \|\| …` | `resize width +50` |
| `cmd + ctrl + k` | `window north --resize bottom:0:20 \|\| …` | `resize height -50` |
| `cmd + ctrl + j` | `window south --resize top:0:-20 \|\| …` | `resize height +50` |

yabai resized a named edge and needed the `||` fallback for when there was no
neighbour in that direction. AeroSpace's `resize` is direction-aware, so the
fallbacks are gone and the binds read as plain narrower/wider/shorter/taller.

### Services

| Key | yabai + skhd | AeroSpace |
|---|---|---|
| `ctrl + alt + r` | `restart-macos-ui.sh` (launchctl dance) | `reload-config` + `sketchybar --reload` |
| `cmd + ctrl + s` | `sketchybar --reload` | unchanged |
| — | — | `alt + shift + ;` → service mode (new) |

### Config equivalents

| yabai | AeroSpace |
|---|---|
| `layout bsp` | `default-root-container-layout = 'tiles'` |
| `split_type auto` | `default-root-container-orientation = 'auto'` |
| `top_padding 10`, others `8`, `window_gap 8` | `gaps.outer.top = 10`, others `8`, `gaps.inner.* = 8` |
| `mouse_follows_focus on` | `on-focus-changed = ['move-mouse window-lazy-center']` |
| `focus_follows_mouse off` | `focus-follows-mouse.enabled = false` |
| `rule --add app="^X$" manage=off` (×11) | `[[on-window-detected]]` + `run = 'layout floating'` (×11) |
| `signal window_focused → sketchybar` | `on-focus-changed = [… 'sketchybar --trigger window_focus']` |
| `signal space_changed → focus helper` | not needed |
| `yabai-ensure-min-spaces.sh 9` | `persistent-workspaces = ['1'…'9']` |

The gaps were measured against the running yabai setup rather than copied:
tiled windows sat at `y=42` on a 1117px display (32px reserved notch/menu-bar
area + 10px padding), with 8px on the other three sides and between windows.

Floating rules now match on **bundle id** instead of an app-name regex, which
survives localisation and renames. Resolved ids are in `aerospace.toml`.
1Password is matched by name because it is not currently installed.

---

## SketchyBar

Two files depended on yabai, plus the workspace indicators.

- `plugins/window_title.sh` — `yabai -m query --windows --window | jq -r .title`
  became `aerospace list-windows --focused --format '%{window-title}'`. The `jq`
  dependency is gone.
- `items/spaces.sh` — these were SketchyBar `space` items with
  `associated_space=$i`, which hooks SketchyBar's **built-in macOS Spaces
  integration** and its `space_change` / `space_windows_change` events. AeroSpace
  workspaces are not macOS Spaces, so those events never fire for it. They are
  plain items now. Ten items became nine, matching the nine binds.
- `plugins/spaces.sh` — new always-visible controller, attached to `spacer.1`.
  It queries AeroSpace directly, keeps workspaces `1..5` visible by default,
  and reveals `6..9` when they are focused or contain windows. If a higher
  hidden workspace is used, intermediate empty workspaces are revealed too, so
  moving a window to `7` shows empty `6` and populated `7`.
- `plugins/space.sh` — kept only as a compatibility wrapper to `spaces.sh`.
  Hidden workspace items cannot reliably reveal themselves from their own
  subscriptions, so the old per-item update model was replaced by the controller
  script.

---

## Deleted

| Path | Lines | Reason |
|---|---|---|
| `yabai/.yabairc` | 81 | replaced by `aerospace.toml` |
| `yabai/SPACES.md` | 133 | superseded by `aerospace/WORKSPACES.md`; the SIP/Tahoe findings are preserved above |
| `skhd/.skhdrc` | 134 | keybinds moved into `aerospace.toml` |
| `scripts/yabai-focus-space.sh` | 35 | `workspace N` |
| `scripts/yabai-focus-current-space-window.sh` | 50 | no space-change race to repair |
| `scripts/yabai-unzoom-space.sh` | 51 | no zoom state to repair |
| `scripts/yabai-ensure-min-spaces.sh` | 32 | `persistent-workspaces` |
| `scripts/yabai-destroy-empty-spaces.sh` | ~30 | dead code under SIP |
| `scripts/yabai-move-window-to-space.sh` | ~40 | `move-node-to-workspace` |
| `scripts/yabai-move-window-to-relative-space.sh` | ~40 | `move-node-to-workspace prev/next` |
| `scripts/yabai-move-window-to-display.sh` | ~30 | `move-node-to-monitor` |
| `scripts/open-app-current-space.sh` | 69 | new windows already land on the focused workspace |
| `scripts/open-safari-current-space.sh` | 62 | same |
| `scripts/open-url-current-space.sh` | ~60 | same |

`scripts/restart-macos-ui.sh` was kept — the `restart-dots` / `restart-wm`
aliases point at it — but shrank from 47 lines of launchctl recovery to a
config reload.

Two daemons became zero: AeroSpace is an ordinary application with
`start-at-login = true`. There is no launchd service, which means the failure
mode that cost 52 dead keypresses over 5.5 hours — `yabai --stop-service`
running `launchctl disable`, writing to a **persistent** override database that
survived reboots and left the window manager dead with no visible error — is
structurally impossible now.

---

## Lost in the move

Stated plainly; three of these were in active use.

1. **`ctrl` + drag to move / resize windows.** `.yabairc` had
   `mouse_modifier ctrl`, `mouse_action1 move`, `mouse_action2 resize`,
   `mouse_drop_action swap`. AeroSpace is keyboard-only and has no equivalent.
   This is the one most likely to be missed day to day.
2. **Window opacity.** `normal_window_opacity 0.90` dimmed unfocused windows.
   No equivalent; [JankyBorders](https://github.com/FelixKratz/JankyBorders)
   (same author as SketchyBar) draws a focus border instead if wanted.
3. **Mirror x/y-axis.** No equivalent; keys repurposed as noted above.
4. **`window_shadow off`.** No equivalent.
5. **Mission Control** now shows off-screen parked windows and looks strange.
6. **macOS native fullscreen** (`hyper + f`) creates a real macOS Space that
   sits outside AeroSpace's model — a transient one macOS removes when you exit
   fullscreen, so it does not accumulate, but leaving a window stuck fullscreen
   leaves the Space. `hyper + m` is the in-model equivalent. If a workspace
   switch ever lands on a bare screen, the cause is *persistent* leftover
   Spaces, not this: run `scripts/aerospace-check-spaces.sh` and see
   `aerospace/WORKSPACES.md` > "Windows on the wrong Mission Control desktop".

Items 4 and 6, along with `window_animation_duration`, were **already**
non-functional under SIP, so the real regressions are the mouse drag, opacity,
and mirror.

---

## Rollback

The old configuration is in git history. To go back:

```sh
cd ~/dotfiles
git log --oneline                      # find the commit before this migration
git checkout <commit> -- yabai skhd scripts KEYBINDS.md README.md
stow -D -t "$HOME" aerospace
stow -t "$HOME" yabai skhd
brew uninstall --cask aerospace
brew install asmvik/formulae/yabai asmvik/formulae/skhd   # the tap this setup used
yabai --start-service && skhd --start-service
```

Then re-create nine desktops by hand in Mission Control, and re-grant
Accessibility to the new yabai binary.

---

## Appendix: salvaged from `yabai/SPACES.md`

That file was never committed to git, so this preserves the parts of it that
were not obvious and are not recoverable from history. Only relevant if you ever
revert to yabai *and* want dynamic space create/destroy.

Environment when those notes were written: yabai v7.1.25 at
`/opt/homebrew/bin/yabai`, macOS 26.5.2 (Tahoe, build 25F84), Apple Silicon,
SIP enabled.

**Passwordless sudoers for `--load-sa`** — `/etc/sudoers.d/yabai`, mode 0440
root:wheel:

```
jack ALL=(root) NOPASSWD: sha256:<shasum -a 256 /opt/homebrew/bin/yabai> /opt/homebrew/bin/yabai --load-sa
```

The hash is tied to the binary, so it must be regenerated after **every**
`brew upgrade yabai` or `--load-sa` fails silently.

**Partially disabling SIP** — from Recovery (hold power → Options → Utilities →
Terminal). Flags are version-sensitive; check the
[yabai wiki](https://github.com/koekeishiya/yabai/wiki/Disabling-System-Integrity-Protection)
first:

```
csrutil enable --without fs --without debug --without nvram
```

On Apple Silicon this may also need `csrutil authenticated-root disable`.

**Known blocker:** even with the addition loaded, `space --destroy` was broken on
Tahoe, so this bought grow-on-demand but not shrink-on-demand — empty spaces
still had to be removed by hand in Mission Control.

**Accessibility after a yabai upgrade:** macOS binds the grant to the binary's
code signature, so each new build fails with
`could not access accessibility features` until re-toggled in System Settings →
Privacy & Security → Accessibility. A stale duplicate "yabai" row per past build
is expected and harmless.
