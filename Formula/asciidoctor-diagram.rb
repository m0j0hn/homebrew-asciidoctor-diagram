class AsciidoctorDiagram < Formula
  desc "Asciidoctor Diagram is a set of Asciidoctor extensions that enable you to add diagrams, which you describe using plain text, to your AsciiDoc document"
  homepage "https://asciidoctor.org/docs/asciidoctor-diagram"
  url "https://github.com/asciidoctor/asciidoctor-diagram/archive/v2.0.5.tar.gz"
  sha256 "3faf4d3b3b8ad139864221c1c7a1bd853ce3f7f269852cbd0378e47d6f0b5403"
  license "MIT"

  depends_on "ruby" if MacOS.version <= :sierra

  #depends_on "asciidoctor" => :recommended

  bottle do
    cellar :any_skip_relocation
    #sha256 "4af4798f8081100713a1b3d301107b5ddd01d1f85d40d5f351d12b3261148fbe" => :big_sur
    #sha256 "b6d75bed00d6ab5586634823bee006e5f0bb3c57f9f46317b675c33b28eb7552" => :catalina
    #sha256 "8ce4eb3ad0b311775a31f15d32939df21f3eefbac6dc39ac76f2d2573920b5af" => :mojave
    #sha256 "d4fa41fc1f142f4d8ad25c2063ed79dd04091386d87c7996c17c9adcb10be301" => :high_sierra
  end

  #resource "asciidoctor-diagram" do
  #   url "https://github.com/asciidoctor/asciidoctor-diagram/archive/v2.0.5.tar.gz"
  #   sha256 "3faf4d3b3b8ad139864221c1c7a1bd853ce3f7f269852cbd0378e47d6f0b5403"
  #end

  conflicts_with "asciidoctor", because: "both install `asciidoctor` binaries"

  def api_version
    Utils.safe_popen_read("#{bin}/ruby", "-e", "print Gem.ruby_api_version")
  end

  def rubygems_bindir
    HOMEBREW_PREFIX/"lib/ruby/gems/#{api_version}/bin"
  end

  def install
    ENV["GEM_HOME"] = libexec
    ENV["GEM_PATH"] = libexec/"cache"
    #resources.each do |r|
    #  r.fetch
    #  system "gem", "install", r.cached_download, "--ignore-dependencies",
    #         "--no-document", "--install-dir", libexec
    #end
 
    ohai "Hello world"
    #ohai "rubygems_bindir: #{rubygems_bindir}"
    #ohai "GEM_HOME: " + #{ENV{"GEM_HOME"}
    system "gem", "build", "asciidoctor-diagram.gemspec"
    system "gem", "install", "asciidoctor-diagram-#{version}.gem"

    # These two work by copying the script, but keeping it in libexec/bin/ directory
    #bin.install libexec/"bin/asciidoctor"
    #bin.install libexec/"bin/asciidoctor" => libexec/"bin/asciidoctor-diagram"

    #bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
    #bin.env_script_all_files(libexec/"wrappers", GEM_HOME: ENV["GEM_HOME"])


    bin.install Dir[libexec/"bin/*"]
    #bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"], GEM_PATH: ENV["GEM_PATH"])



    #bin.install_symlink Dir["#{libexec}/bin/*"]

    ohai "Goodbye world"

    #bin.install libexec/"bin/asciidoctor-diagram"
    #bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])


    #system "gem", "build", "asciidoctor.gemspec"
    #system "gem", "install", "asciidoctor-#{version}.gem"

    #system "gem", "install", "asciidoctor-diagram-#{version}.gem"
    #system "gem", "install", "--ignore-dependencies", "asciidoctor-diagram-#{version}.gem"

    #system "gem", "install", "asciidoctor-diagram-#{version}.gem", "--ignore-dependencies", "--install-dir", libexec

    #system "gem", "build", "asciidoctor-diagram.gemspec"
    #system "gem", "install", "asciidoctor-diagram-#{version}.gem"
    #system "gem", "install", "asciidoctor-diagram.gem"
    #system "gem", "install", "asciidoctor-diagram"

    #bin.install Dir[libexec/"bin/asciidoctor"]
    #bin.install Dir[libexec/"bin/asciidoctor-pdf"]
    #bin.install Dir[libexec/"bin/*"]
    #bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
    #man1.install_symlink "#{libexec}/gems/asciidoctor-#{version}/man/asciidoctor.1" => "asciidoctor.1"

    # COPIED FROM swiftgen.rb:
    # Install bundler, then use it to `rake cli:install` SwiftGen
    #ENV["GEM_HOME"] = buildpath/"gem_home"
    #system "gem", "install", "bundler"
    #ENV.prepend_path "PATH", buildpath/"gem_home/bin"
    #system "bundle", "install", "--without", "development", "release"
    #system "bundle", "exec", "rake", "cli:install[#{bin},#{lib},#{pkgshare}/templates]"
  end

  test do
    (testpath/"test.adoc").write <<~EOS
      = AsciiDoc is Writing Zen
      Random J. Author <rjauthor@example.com>
      :icons: font
      Hello, World!
      == Syntax Highlighting
      Python source.
      [source, python]
      ----
      import something
      ----
      List
      - one
      - two
      - three
    EOS
    system bin/"asciidoctor", "-b", "html5", "-o", "test.html", "test.adoc"
    assert_match "<h1>AsciiDoc is Writing Zen</h1>", File.read("test.html")
    system bin/"asciidoctor", "-r", "asciidoctor-pdf", "-b", "pdf", "-o", "test.pdf", "test.adoc"
    assert_match "/Title (AsciiDoc is Writing Zen)", File.read("test.pdf", mode: "rb")
  end
end
