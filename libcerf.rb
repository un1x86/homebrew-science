class Libcerf < Formula
  desc "Efficient implementation of complex error functions"
  homepage "http://apps.jcns.fz-juelich.de/doku/sc/libcerf"
  url "http://apps.jcns.fz-juelich.de/src/libcerf/libcerf-1.4.tgz"
  sha256 "101265dd1e1b10339adb70b22b60e65ef12c4e01c4a3f52e508562eceef62272"

  option "without-check", "Disable build-time checking (not recommended)"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "check" if build.with? "check"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<-EOS.undent
      #include <cerf.h>
      #include <stdio.h>
      int main()
      {
        printf("%f\\n", voigt(0, 1, 0));
        return -1;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lcerf", "-o", "test"
    assert_in_delta `./test`.to_f, 1 / Math.sqrt(2 * Math::PI), 1e-6
  end
end
