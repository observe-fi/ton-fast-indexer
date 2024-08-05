#/bin/bash

#sudo apt-get update
#sudo apt-get install -y build-essential git cmake ninja-build zlib1g-dev libsecp256k1-dev libmicrohttpd-dev libsodium-dev liblz4-dev libjemalloc-dev


if [ ! -d "build" ]; then
  mkdir build
  cd build
else
  cd build
  #rm -rf .ninja* CMakeCache.txt
fi

export CC=$(which clang-16)
export CXX=$(which clang++-16)
#export CCACHE_DISABLE=1

if [ ! -d "openssl_3" ]; then
  git clone https://github.com/openssl/openssl openssl_3
  cd openssl_3
  opensslPath=`pwd`
  git checkout openssl-3.1.4
  ./config
  make build_libs -j12
  test $? -eq 0 || { echo "Can't compile openssl_3"; exit 1; }
  cd ..
else
  opensslPath=$(pwd)/openssl_3
  echo "Using compiled openssl_3"
fi

cmake -GNinja -DTON_USE_JEMALLOC=ON .. \
-DCMAKE_BUILD_TYPE=Release \
-DOPENSSL_ROOT_DIR=$opensslPath \
-DOPENSSL_INCLUDE_DIR=$opensslPath/include \
-DOPENSSL_CRYPTO_LIBRARY=$opensslPath/libcrypto.so


test $? -eq 0 || { echo "Can't configure ton"; exit 1; }

ninja fast-indexer
      test $? -eq 0 || { echo "Can't compile ton"; exit 1; }

# simple binaries' test
./fast-indexer/fast-indexer -V || exit 1
ldd ./fast-indexer/fast-indexer || exit 1
