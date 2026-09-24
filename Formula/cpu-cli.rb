class CpuCli < Formula
  desc "A modern, pretty CPU viewer: see what silicon you are actually running"
  homepage "https://github.com/priyansh-anand/cpu-cli"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/priyansh-anand/cpu-cli/releases/download/v0.1.0/cpu-cli-aarch64-apple-darwin.tar.xz"
      sha256 "05f7d21f5e1dc35977af0d1ec1d27c8a59936ef6ad1f98b31a2883318786e144"
    end
    if Hardware::CPU.intel?
      url "https://github.com/priyansh-anand/cpu-cli/releases/download/v0.1.0/cpu-cli-x86_64-apple-darwin.tar.xz"
      sha256 "7cd03f291c12b9016da936baf9408b6426989181a764c60908da7a71a5554efd"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/priyansh-anand/cpu-cli/releases/download/v0.1.0/cpu-cli-aarch64-unknown-linux-musl.tar.xz"
      sha256 "c3a3febf4b4690f7e7897bd40c32a9b34dbff26bb1b72b02240d8ee4d4274205"
    end
    if Hardware::CPU.intel?
      url "https://github.com/priyansh-anand/cpu-cli/releases/download/v0.1.0/cpu-cli-x86_64-unknown-linux-musl.tar.xz"
      sha256 "11ba60298de5e96503a19061f25c20b8b5a572e23faf18af5309b097bacf4225"
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
