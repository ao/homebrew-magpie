# Magpie

Clipboard history, a launcher and notes on one keystroke, for macOS 13 (Ventura) or later, on
Apple silicon and Intel.

**Website: [ataiva.com/products/magpie](https://ataiva.com/products/magpie/)** — screenshots, what
it does, and how to install it.

This repository is where Magpie's releases are published, and it is also its Homebrew tap. The
source is not public yet.

## Install

Pick one.

**One command (recommended):**

```sh
curl -fsSL https://github.com/ao/homebrew-magpie/releases/latest/download/install.sh | bash
```

It checks the download's checksum and Magpie's signature before it touches anything, installs to
`/Applications` (or `~/Applications` if that isn't writable), never uses `sudo`, and moves an older
Magpie to the Trash rather than deleting it.

**Homebrew:**

```sh
brew update && brew tap ao/magpie && brew trust --tap ao/magpie && brew install --cask ataiva-magpie
```

The `brew update` at the start refreshes Homebrew and the tap, so a copy of the tap added before can't hide the current Magpie.

**Disk image:** download `Magpie.dmg` from the [latest release](https://github.com/ao/homebrew-magpie/releases/latest)
and drag Magpie to Applications. macOS will refuse to open it the first time ("Apple could not
verify…"): open **System Settings → Privacy & Security** and press **Open Anyway**, once.

## After installing

Magpie opens with a short tour. It asks for one permission, **Accessibility** (System Settings →
Privacy & Security → Accessibility → Magpie), so it can paste the clip you pick into the app you
were using and see a double-tap of ⌘. Without it Magpie still records and copies; you paste with
⌘V yourself. You grant it once, and every later version keeps it.

Then **tap ⌘ twice** from any app to open Magpie, or press **⌃⌘V**.

## Updates

Magpie updates itself. It checks shortly after it starts and once a day, and when a new release is
out it shows a banner with **Restart to update**: press it and Magpie downloads the release, checks
its signature, swaps itself for it and reopens. Your history and settings carry over. `brew upgrade`
leaves it alone for that reason (use `--greedy` if you want Homebrew to do it).

## Why macOS warns about it

Magpie is signed with its own certificate rather than a paid Apple Developer ID, and it is not
notarised by Apple. The one-command installer and the Homebrew cask verify the download and then
clear the "downloaded from the internet" flag, which is the only thing that makes macOS refuse an
app like this. A disk image opened from a browser keeps the flag, which is why it needs Open
Anyway.

## Your data

[Privacy and terms](https://ataiva.com/products/magpie/privacy-and-terms/) has the details.

Everything stays on your Mac, in `~/Library/Application Support/dev.magpie.app`, readable only by
your user account. Ask AI is off until you turn it on in Settings; until then nothing you copy is
sent anywhere.

## Uninstall

Quit Magpie from its menu bar icon and move it to the Trash. `brew uninstall --zap --cask ataiva-magpie`
also removes your history and settings.

## Feedback

Magpie is an early release, and what gets built next depends on what you say.
[Open an issue](https://github.com/ao/homebrew-magpie/issues), or email info@ataiva.com. It helps to
include the build line from the footer or from **About**, in the footer of Magpie's window (for
example `build 00501 · 70b2895`), your macOS version,
and whether your Mac is Apple silicon or Intel. The log is at `~/Library/Logs/Magpie/magpie.log`;
it records what Magpie did, not what you copied.
