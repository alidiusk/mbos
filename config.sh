SYSTEM_HEADER_PROJECTS="libc kernel"
PROJECTS="libc kernel"

export MAKE=${MAKE:-make}
export HOST=${HOST:-$(./default-host.sh)}

export AR=llvm-ar
export AS=llvm-as
export CC=clang

export PREFIX=/usr
export EXEC_PREFIX=$PREFIX
export BOOTDIR=/boot
export LIBDIR=$EXEC_PREFIX/lib
export INCLUDEDIR=$EXEC_PREFIX/include

export CFLAGS="-O2 -g"

# Configure cross-compuler to use desired system root
export SYSROOT="$(pwd)/sysroot"
export CC="$CC --sysroot=$SYSROOT"
