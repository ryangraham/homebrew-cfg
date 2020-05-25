# frozen_string_literal: true

class Csv < Formula
  desc 'CSV Parser for C++'
  homepage 'https://github.com/ryangraham/csv'
  url 'https://github.com/ryangraham/csv/archive/v0.0.1-0e290d6.tar.gz'
  sha256 '3c0b9156ed0bff2c635af24b7e7a421fbf91bbde6e9dcf705ac0cdad86a6880b'
  head 'https://github.com/ryangraham/csv.git', branch: 'master'
  version '0.0.1'

  depends_on 'cmake'
  depends_on 'range-v3'

  def install
    mkdir 'csv-build' do
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
      #include <csv/csv.h>
      #include <iostream>
      #include <sstream>
      #include <string>

      int main() {
        std::string input = R"csv(FirstName,LastName
                            Fred,Flintstone
                            Pebbles,Flintstone
                            Barney,Rubble
                            Betty,Rubble)csv";
        std::stringstream istr(input);
        auto reader = csv::map_reader(istr);
        std::cout << reader.field_names.front() << std::endl;
        std::cout << std::string(10, '-') << std::endl;

        for (auto& row : reader.rows()) {
          std::cout << row["FirstName"] << std::endl;
        }
        return 0;
      }
      EOS
    system ENV.cxx, "test.cpp", "-I#{include}", "-std=c++17", "-o", "test"
    system "./test"
  end
end
