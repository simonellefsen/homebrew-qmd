class Qmd < Formula
  desc "Query Markup Documents - secure Rust port of the on-device hybrid search engine"
  homepage "https://github.com/simonellefsen/qmd-rust"
  version "0.6.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/simonellefsen/qmd-rust/releases/download/v0.6.7/qmd-aarch64-apple-darwin.tar.xz"
      sha256 "a5ddcadb0ee7ca124664ab739ae029dce5ac49520285f82591b0e22f1246d685"
    end
    if Hardware::CPU.intel?
      url "https://github.com/simonellefsen/qmd-rust/releases/download/v0.6.7/qmd-x86_64-apple-darwin.tar.xz"
      sha256 "7f374cefa4b4818c2117b14ee35422a2fb6d5624ca149eecc9d1532a5111aaeb"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/simonellefsen/qmd-rust/releases/download/v0.6.7/qmd-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "acd8c7d163225d949858e673b13bd08cb533af68b3d4e6aaec0dfbdec07167d9"
  end
  license "MIT"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":              {},
    "x86_64-apple-darwin":               {},
    "x86_64-pc-windows-gnu":             {},
    "x86_64-unknown-linux-gnu":          {},
    "x86_64-unknown-linux-musl-dynamic": {},
    "x86_64-unknown-linux-musl-static":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "qmd" if OS.mac? && Hardware::CPU.arm?
    bin.install "qmd" if OS.mac? && Hardware::CPU.intel?
    bin.install "qmd" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
