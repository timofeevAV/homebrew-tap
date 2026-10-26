class Kyvia < Formula
  desc "Menu-bar toast notifier for coding agents"
  homepage "https://github.com/timofeevAV/kyvia"
  url "https://github.com/timofeevAV/kyvia/archive/refs/tags/v0.1.5.tar.gz"
  sha256 "5d47e0d31a6e3938378c7246dd76719f5cc09eccbc5044b9cae189c36b0ec9f7"
  license "MIT"

  depends_on "node" => :build
  depends_on :macos

  def install
    system "./build.sh", "--no-install"
    prefix.install "Kyvia.app"
    bin.install_symlink prefix/"Kyvia.app/Contents/Resources/kyvia"
    bin.install_symlink prefix/"Kyvia.app/Contents/Resources/kyvia" => "kv"
  end

  def caveats
    <<~EOS
      kyvia listens on 127.0.0.1:47321, so keep a single copy. If you installed it
      with install.sh, remove that copy before starting the service:
        curl -fsSL https://raw.githubusercontent.com/timofeevAV/kyvia/main/uninstall.sh | bash
    EOS
  end

  service do
    run opt_prefix/"Kyvia.app/Contents/MacOS/Kyvia"
    keep_alive true
    process_type :interactive
  end

  test do
    assert_match "usage", shell_output("#{bin}/kyvia 2>&1", 2)
    assert_match "usage", shell_output("#{bin}/kv 2>&1", 2)
  end
end
