# REF

Downloads and updates for REF, a Mac (and early Windows) app that measures
your mix against a reference song and tells you, in plain English, what to
change: EQ moves, loudness, dynamics and stereo. Reference and refine.

**Get it: <https://samsegan.github.io/ref>**

This repository only holds the releases and that page. It's published from
the (private) source repository by `apps/REF/scripts/release.sh` (Mac) and
`release-windows.sh` (Windows): please don't edit it by hand, the next
release overwrites it.

- `REF.dmg` in each [release](https://github.com/samsegan/ref/releases)
- `appcast.xml`: the update feed copies of REF check every day (Sparkle)
- `install.sh`: `curl -fsSL https://samsegan.github.io/ref/install.sh | bash`
- `REF-<version>-Windows-Setup.exe` in each `ref-win-v*` release (never marked Latest)
- `appcast-windows.xml`: the Windows update feed (WinSparkle)
