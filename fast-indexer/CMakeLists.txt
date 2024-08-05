cmake_minimum_required(VERSION 3.5 FATAL_ERROR)

if (NOT OPENSSL_FOUND)
  find_package(OpenSSL REQUIRED)
endif()


set(FAST_INDEXER_SOURCE
        fast-indexer.hpp
        fast-indexer.cpp
)

add_executable(fast-indexer ${FAST_INDEXER_SOURCE})
target_link_libraries(fast-indexer overlay tdutils tdactor adnl tl_api dht
  rldp rldp2 catchain validatorsession full-node validator ton_validator validator
  fift-lib memprof git ${JEMALLOC_LIBRARIES})
