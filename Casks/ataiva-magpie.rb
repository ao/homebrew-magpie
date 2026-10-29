# frozen_string_literal: true

# Homebrew cask for Magpie — one of the three install routes (docs/distribution.md).
#
#   brew tap ao/magpie && brew trust --tap ao/magpie && brew install --cask ataiva-magpie
#
# This file is the source. `scripts/release.sh` renders a copy with the release's version and
# the SHA-256 of its Magpie.zip into the release artifacts; that copy is what gets committed to
# Casks/ataiva-magpie.rb in the tap repository (ao/homebrew-magpie, which is also where the releases
# are published). The `sha256 :no_check` below is therefore never what a user installs.
#
# ── Quarantine, and why this cask removes it ─────────────────────────────────────────────────
# Homebrew marks every cask download with com.apple.quarantine — unconditionally: in the
# Homebrew this was written against (7.0.9), `Cask::Download#fetch` quarantines the download
# before it verifies it, and nothing opts out — and Gatekeeper refuses a quarantined app that is
# not notarised, which Magpie cannot be without a paid Apple Developer ID. Homebrew 5.0
# deprecated `brew install --no-quarantine` (7.0.9's `brew install --help` no longer lists it),
# and third-party taps must be trusted explicitly with `brew trust --tap`. So the postflight
# step below strips the flag from the installed app, *after* Homebrew has verified the
# download's SHA-256 against the value release.sh wrote here — verification first, then the
# flag, never the other way round (the nearest competitor's updater clears it before verifying;
# parity checklist row 388).
#
# `postflight_steps`, not a `postflight` block: Homebrew 7's declarative install steps, which it
# runs in its own sandbox with write access to the app directory (`brew style` requires them).
# Homebrew updates itself before an install by default, so a tester's Homebrew has them.
#
# Updates: Magpie updates itself (tauri-plugin-updater, minisign-signed), so `auto_updates true`
# tells `brew upgrade` to leave it alone unless asked with --greedy. A greedy upgrade still
# works: the new copy is signed by the same identity, so the Accessibility grant survives.
#
# The token: `magpie` in Homebrew's own catalogue is an unrelated app, and Homebrew's rule for a
# name that clashes is the maker's name in front (`caffeine`, `domzilla-caffeine`). The tap's
# cask_renames.json sends the old `ao/magpie/magpie` here, so installs made under it keep working.
cask "ataiva-magpie" do
  version "0.3.0"
  sha256 "6294bb5952cf0cf6ae2a8872e7961cf42e2b254a95b939fff9aec9a782354ad8"

  url "https://github.com/ao/homebrew-magpie/releases/download/v#{version}/Magpie.zip"
  name "Magpie"
  desc "Clipboard history, launcher, notes and AI on one keystroke"
  homepage "https://ataiva.com/products/magpie/"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: :ventura

  app "Magpie.app"

  # `{{appdir}}` is the steps runner's own template (Homebrew::InstallSteps expands it in `run`
  # arguments); Ruby interpolation is not allowed inside a steps block.
  postflight_steps do
    run "/usr/bin/xattr", args: ["-dr", "com.apple.quarantine", "{{appdir}}/Magpie.app"]
  end

  uninstall launchctl: "Magpie",
            quit:      "dev.magpie.app"

  # Everything Magpie keeps outside the app. The first line is the clipboard history itself
  # (magpie.db, its blobs, settings.json, window state, `app_config_dir()` in
  # src-tauri/src/lib.rs); ~/Library/Logs/Magpie is its log (src-tauri/src/diagnostics.rs); the
  # rest is what macOS and the web view keep on its behalf, and the LaunchAgent "Launch at
  # login" writes. The copy an update moves aside is kept under the first path (previous-version.noindex/,
  # so this zap removes it), or under $TMPDIR when that is another volume, and Magpie deletes it
  # itself (docs/distribution.md). `zap` is the "remove
  # everything" verb, and a plain `brew uninstall` leaves all of it in place. AI keys are in the
  # login keychain under the service "dev.magpie.app" and are not removed by any cask — delete
  # them in Keychain Access if you want them gone.
  zap trash: [
    "~/Library/Application Support/dev.magpie.app",
    "~/Library/Caches/dev.magpie.app",
    "~/Library/HTTPStorages/dev.magpie.app",
    "~/Library/LaunchAgents/Magpie.plist",
    "~/Library/Logs/Magpie",
    "~/Library/Preferences/dev.magpie.app.plist",
    "~/Library/Saved Application State/dev.magpie.app.savedState",
    "~/Library/WebKit/dev.magpie.app",
  ]

  caveats <<~EOS
    Magpie is signed with its own certificate ("Magpie Signing"), not an Apple Developer ID,
    and it is not notarised. Gatekeeper would refuse to open it with the quarantine flag
    Homebrew sets on downloads, so this cask removes that flag from Magpie.app after
    Homebrew has checked the download's SHA-256.

    One step left: let Magpie paste.
      System Settings → Privacy & Security → Accessibility → switch on Magpie
    macOS grants this per signature, so it carries over to every later version.

    Magpie updates itself; `brew upgrade` leaves it alone unless you pass --greedy.
  EOS
end
