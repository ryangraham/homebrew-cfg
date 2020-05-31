# frozen_string_literal: true

class Cfg < Formula
  desc 'INI config file parser for C++'
  homepage 'https://github.com/ryangraham/cfg'
  url 'https://github.com/ryangraham/cfg/archive/v0.0.2.tar.gz'
  sha256 'dfda5c4e0a33b9b33914a147625be6de34cbbf966d303e370b083c0868dfc11f'
  head 'https://github.com/ryangraham/cfg.git', branch: 'master'
  version '0.0.2'

  depends_on 'cmake'
  depends_on 'range-v3'

  def install
    mkdir 'cfg-build' do
      system 'cmake', '..', *std_cmake_args
      system 'make', 'install'
    end
  end

  def caveats
    <<~EOS
      If built with CMake support, you can use find_package to use the library.
      Without it, please set your include path accordingly:
      CPPFLAGS: -I#{include}
    EOS
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <cfg/cfg.h>
      #include <iostream>
      #include <string>

      int main() {
        std::string input_file_name = "../input.ini";
        cfg::ctree ctree;
        cfg::read_ini(input_file_name, ctree);

        cfg::write(std::cout, ctree);
        return 0;
      }
      EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-std=c++17", "-o", "test"
    system "./test"
  end
end
