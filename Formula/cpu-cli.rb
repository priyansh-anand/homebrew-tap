class CpuCli < Formula
  desc "A modern, pretty CPU viewer: see what silicon you are actually running"
  homepage "https://github.com/priyansh-anand/cpu-cli"
  version "2.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/priyansh-anand/cpu-cli/releases/download/v2.0.0/cpu-cli-aarch64-apple-darwin.tar.xz"
      sha256 "bc9dfad3f45a2870bb60d499c82fb967dda87d3d5f2f2b642362ca0bad7f00b3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/priyansh-anand/cpu-cli/releases/download/v2.0.0/cpu-cli-x86_64-apple-darwin.tar.xz"
      sha256 "f9eab4f218f40bed65f19f8302ed70d114296015373f7d61d25228425c75149f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/priyansh-anand/cpu-cli/releases/download/v2.0.0/cpu-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "f91d48f11fe43add2bc4074616a237812dded970c1a3335261a10bcd91481aac"
    end
    if Hardware::CPU.intel?
      url "https://github.com/priyansh-anand/cpu-cli/releases/download/v2.0.0/cpu-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "a337eb8697da9b327748a52af5d20b9ef37e0112056cd13935bc21ead1d63230"
    end
  end
  license "GPL-3.0-or-later"

  BINARY_ALIASES = {
    "aarch64-apple-darwin":               {},
    "aarch64-unknown-linux-gnu":          {},
    "aarch64-unknown-linux-musl-dynamic": {},
    "aarch64-unknown-linux-musl-static":  {},
    "x86_64-apple-darwin":                {},
    "x86_64-unknown-linux-gnu":           {},
    "x86_64-unknown-linux-musl-dynamic":  {},
    "x86_64-unknown-linux-musl-static":   {},
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "cpu"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "cpu"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "cpu"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "cpu"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
