# Note that this script can accept some limited command-line arguments, run
# `julia build_tarballs.jl --help` to see a usage message.
using BinaryBuilder

name = "libXftBuilder"
version = v"0.1.0"

# Collection of sources required to build libXft
sources = [
    "https://gitlab.freedesktop.org/xorg/lib/libxft.git" =>
    "c418dc7594f98359ae10815f62ee3efc0a511cf8",

]

# Bash recipe for building across all platforms
script = raw"""
cd $WORKSPACE/srcdir/libxft
apk update
apk add freetype freetype-dev fontconfig fontconfig-dev libx11 libx11-dev libxrender libxrender-dev libxext util-macros
sh autogen.sh --sysconfdir=/etc --prefix=$prefix --host=$target --mandir=/usr/share/man CFLAGS="-I/usr/include/ -I/usr/include/freetype2/" LDFLAGS="-L/usr/lib/"
make
make install

"""

# These are the platforms we will build for by default, unless further
# platforms are passed in on the command line
platforms = [
    Linux(:x86_64, :glibc),
    Linux(:x86_64, :musl),
    Linux(:i686, :glibc),
    Linux(:aarch64, :glibc),
    #Linux(:armv7l, :glibc, :eabihf),
    #Linux(:powerpc64le, :glibc)    
    #Linux(:i686, :musl)            
    #Linux(:aarch64, :musl)         
    #Linux(:armv7l, :musl, :eabihf) 
    #MacOS(:x86_64)                 
    #FreeBSD(:x86_64)               
    #Windows(:i686)                 
    #Windows(:x86_64)
]

# The products that we will ensure are always built
products(prefix) = [
    LibraryProduct(prefix, "libXft", Symbol("libXft.so"))
]

# Dependencies that must be installed before this package can be built
dependencies = [
    
]

# Build the tarballs, and possibly a `build.jl` as well.
build_tarballs(ARGS, name, version, sources, script, platforms, products, dependencies)

