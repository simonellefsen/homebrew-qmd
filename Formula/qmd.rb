class Qmd < Formula
  desc "Query Markup Documents - secure Rust port of the on-device hybrid search engine"
  homepage "https://github.com/simonellefsen/qmd-rust"
  version "0.6.10"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/simonellefsen/qmd-rust/releases/download/v0.6.10/qmd-aarch64-apple-darwin.tar.xz"
      sha256 "554df3cedb9b79e06f05152d24238e804c4bc84decb97c14af669315a66770eb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/simonellefsen/qmd-rust/releases/download/v0.6.10/qmd-x86_64-apple-darwin.tar.xz"
      sha256 "d061c164c5cc04bbf42ca0cc6653888177372fabea74c64b87dd6ff71c84c54c"
    end
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/simonellefsen/qmd-rust/releases/download/v0.6.10/qmd-x86_64-unknown-linux-gnu.tar.xz"
    sha256 "a325dc493cfa45a2c4b71afee29bad95a83635b37c7df11f4d15c9f3385e0235"
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
