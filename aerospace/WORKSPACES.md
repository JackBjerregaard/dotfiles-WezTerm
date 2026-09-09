# AeroSpace workspaces

How workspaces behave in this setup, and how to triage them when something looks
wrong. Replaces the old `yabai/SPACES.md`; the historical yabai/SIP findings it
contained are preserved in
[`../MIGRATION-yabai-to-aerospace.md`](../MIGRATION-yabai-to-aerospace.md).

## The model

**AeroSpace workspaces are not macOS Spaces.** This is the single most important
thing to know, and everything else follows from it.

macOS still believes there is exactly one desktop. A workspace is just "the set
of windows currently positioned inside the visible screen area". Switching to
another workspace moves the current windows to coordinates far off-screen and
brings the target workspace's windows back. The system never performs a space
transition.

Consequences, good and bad:

- Switching is **instant** — there is no Mission Control animation, which is
  what the old yabai helper scripts spent 12 retries at 30ms fighting.
- It works with **SIP enabled**. Nothing privileged is ever requested.
- Workspaces are **created by AeroSpace**, not by you in Mission Control. There
  is no "add four more desktops" chore and no dead numbered keys.
- **Mission Control looks strange.** It shows the parked off-screen windows,
  because as far as macOS is concerned they are ordinary windows that happen to
  be positioned oddly. This is expected. Most people stop using Mission Control.
- **Exactly one macOS Space per display is required.** Everything above only
  works while macOS believes there is one desktop. Extra desktops strand windows
  — see "Windows on the wrong Mission Control desktop" below.
- **`hyper + f` is macOS native fullscreen** (menu bar hidden, own screen), for
  video and single-app focus. It creates a macOS Space, but a transient one that
  macOS destroys when you exit fullscreen, so it does not accumulate. Exit it
  rather than leaving a window stuck. `hyper + m` (AeroSpace `fullscreen`) fills
  the workspace with no Space and stays in the tiling model.

## Nine persistent workspaces, five normally shown

`aerospace.toml` sets:

```toml
persistent-workspaces = ['1', '2', '3', '4', '5', '6', '7', '8', '9']
```

Nine workspaces always exist and stay addressable even when empty, matching the
`ctrl + 1..9` (focus) and `hyper + 1..9` (move window) binds. SketchyBar only
shows `1..5` by default; `6..9` appear when they are focused or contain windows.
If you focus or move a window to a higher hidden workspace, the intermediate
hidden workspaces are shown too, so using `9` reveals `6`, `7`, `8`, and `9`
even when some of them are empty.

This is the direct replacement for the old static nine-Space model — except
those had to be created by hand, and `scripts/yabai-ensure-min-spaces.sh` (32
lines) existed solely to warn you when fewer than nine existed, because yabai
could not create them under SIP.

To change the count, edit `persistent-workspaces` and add matching binds. Both
live in the same file.

## Keybinds

| Key | Action |
|-----|--------|
| `ctrl + 1..9` | Focus workspace 1..9 |
| `alt + p` / `alt + n` | Previous / next workspace (wraps) |
| `hyper + 1..9` | Move window to workspace, stay put |
| `shift + hyper + 1..9` | Move window to workspace and follow |
| `hyper + p` / `hyper + n` | Move window to previous / next workspace, stay put |
| `shift + hyper + p` / `+ n` | Move window to previous / next workspace and follow |

Held Caps Lock produces `shift + ctrl + alt + cmd`, so **Caps Lock + a number
moves and follows**. To move without following, press the `ctrl + alt + cmd`
cluster physically.

## Triage

### Nothing responds to any keybind

AeroSpace is not running, or has lost its Accessibility grant.

```sh
pgrep -x AeroSpace                        # running?
aerospace list-workspaces --focused       # server responding?
```

If the process is running but the CLI reports
`Can't connect to AeroSpace server`, it is almost always Accessibility:

> System Settings → Privacy & Security → Accessibility → enable **AeroSpace**.

macOS ties that grant to the binary's code signature, so an upgrade can silently
invalidate it. Removing and re-adding the entry is more reliable than toggling.

Restart with `restart-dots`, `restart-wm`, or `open -a AeroSpace`.

> Unlike yabai and skhd, AeroSpace is **not** a launchd service, so there is no
> `launchctl disable` override database that can leave it dead across reboots.
> That failure mode — a stray `ctrl + alt + q` killing the window manager
> silently and permanently — no longer exists.

### A hidden workspace should be visible but is not

SketchyBar hides workspaces `6..9` until they are focused or contain windows.
Force a refresh after moving windows around:

```sh
sketchybar --trigger aerospace_workspace_change
```

Then inspect the workspace:

```sh
aerospace list-windows --workspace 6
```

### One workspace looks empty but shouldn't be

```sh
aerospace list-windows --workspace 3
aerospace list-windows --all            # everything AeroSpace can see
```

If a window is missing from `--all`, AeroSpace is not managing it — check the
`[[on-window-detected]]` floating rules in `aerospace.toml`.

### Windows on the wrong Mission Control desktop

Symptom: `ctrl + 1..9` or `alt + p`/`n` switches the workspace but lands on a
bare screen, or an app you expected does not appear until you three-finger-swipe
sideways. Meanwhile `aerospace list-windows --all` cheerfully lists the window
on the workspace you are looking at. AeroSpace and macOS disagree about where
the window is.

Cause: **more than one macOS Space (Mission Control desktop) on a display.**
AeroSpace tiles by parking windows off-screen *within the one Space that is
currently active*; it never switches Spaces. A window opened while another
desktop was frontmost stays physically on that desktop, and `workspace N` — which
only moves windows on the active Space — cannot reach across to it.

Check:

```sh
scripts/aerospace-check-spaces.sh
```

or by hand:

```sh
plutil -convert json -o - ~/Library/Preferences/com.apple.spaces.plist \
  | jq '."SpacesDisplayConfiguration"."Management Data".Monitors[]
        | select(.Spaces) | {display: ."Display Identifier",
                             desktops: ([.Spaces[] | select(.type==0)] | length)}'
```

`desktops` should be `1` for every connected display.

Fix (one-time, manual — there is **no** CLI for this without disabling SIP,
which is the whole reason yabai was dropped):

1. Open Mission Control (F3, or Control + Up).
2. In the desktop strip along the top, hover each extra desktop and click its
   small x. Leave exactly one.
3. `aerospace reload-config` (or just switch workspaces once) to resettle.

Avoid re-creating them:

- Don't use "Add a Desktop" in Mission Control.
- `hyper + f` (native fullscreen) makes a *transient* Space — fine, but exit it
  when done. `hyper + m` fills the workspace with no Space at all.
- `mru-spaces` and `AppleSpacesSwitchOnActivate` are set to `false` by
  `scripts/install.sh` (`set_macos_defaults`); don't turn them back on.
- Per-app "Assign To … Desktop" from a Dock icon's Options menu pins the app to
  a Space and forces macOS to keep one. Use "All Desktops" or "None".

### The layout is tangled

`hyper + y` flattens the workspace tree, which resolves most "why is this window
nested three levels deep" situations. `hyper + e` re-balances sizes.

### Config changes are not taking effect

`auto-reload-config = true` re-reads the file on save. To force it and see any
errors:

```sh
aerospace reload-config                     # apply
aerospace reload-config --dry-run           # validate only, change nothing
aerospace reload-config --dry-run --warnings-as-errors
```

`--dry-run` is the safe way to check an edit before it touches a live session.

## Health check

```sh
pgrep -x AeroSpace                               # should print a PID
aerospace list-workspaces --focused              # current workspace
aerospace list-workspaces --all                  # should list 1..9
aerospace list-windows --all --count             # managed window count
aerospace reload-config --dry-run                # config still valid?
scripts/aerospace-check-spaces.sh                # one macOS Space per display?
sketchybar --trigger aerospace_workspace_change   # refresh workspace indicators
```
