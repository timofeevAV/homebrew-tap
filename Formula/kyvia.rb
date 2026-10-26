class Kyvia < Formula
  desc "Menu-bar toast notifier for coding agents"
  homepage "https://github.com/timofeevAV/kyvia"
  url "https://github.com/timofeevAV/kyvia/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "0907d5dcfeb91696473e8ebd43e2012151f4559e046fccfb665357081b3ba36e"
  license "MIT"
  revision 1

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
