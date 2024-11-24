class Dog < Formula
  desc "Command-line DNS client"
  homepage "https://github.com/jak0b/dog"
  url "https://github.com/jak0b/dog/archive/refs/tags/orignial-v0.1.0.tar.gz"
  sha256 "210ea954af6c8791af5035b630b25c56ae8283851b7cd74db5943770fbd76f42"
  license "EUPL-1.2"
  head "https://github.com/jak0b/dog.git", branch: "master"

  depends_on "just" => :build
  depends_on "pandoc" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@1.1"
  end

  def install
    system "cargo", "install", *std_cargo_args
    bash_completion.install "completions/dog.bash" => "dog"
    zsh_completion.install "completions/dog.zsh" => "_dog"
    fish_completion.install "completions/dog.fish"
    system "just", "man"
    man1.install "target/man/dog.1"
  end

  test do
    output = shell_output("#{bin}/dog dns.google A --seconds --color=never")
    assert_match(/^A\s+dns\.google\.\s+\d+\s+8\.8\.4\.4/, output)
    assert_match(/^A\s+dns\.google\.\s+\d+\s+8\.8\.8\.8/, output)
  end
end
