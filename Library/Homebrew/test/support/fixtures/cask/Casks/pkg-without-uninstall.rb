# typed: false
cask "pkg-without-uninstall" do
  version "1.2.3"
  sha256 "8c62a2b791cf5f0da6066a0a4b6e85f62949cd60975da062df44adf887f4370b"

  url "file://#{TEST_FIXTURE_DIR}/cask/MyFancyPkg.zip"
  name "PKG without Uninstall"
  desc "Cask with a package installer and no uninstall stanza"
  homepage "https://brew.sh/fancy-pkg"

  pkg "Fancy.pkg"
end
