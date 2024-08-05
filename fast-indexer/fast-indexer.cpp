/*
This file is part of TON Blockchain source code.

TON Blockchain is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
    as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

    TON Blockchain is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with TON Blockchain.  If not, see <http://www.gnu.org/licenses/>.

In addition, as a special exception, the copyright holders give permission
to link the code of portions of this program with the OpenSSL library.
You must obey the GNU General Public License in all respects for all
of the code used other than OpenSSL. If you modify file(s) with this
exception, you may extend this exception to your version of the file(s),
but you are not obligated to do so. If you do not wish to do so, delete this
                                                                exception statement from your version. If you delete this exception statement
                                                                from all source files in the program, then also delete it here.

    Copyright 2017-2020 Telegram Systems LLP
            */
#include "fast-indexer.hpp"
#include "validator/interfaces/block.h"
#include "validator/interfaces/shard.h"
#include "td/actor/MultiPromise.h"

#if TD_DARWIN || TD_LINUX
#include <unistd.h>
#endif

#include <stdio.h>

int main(int argc, char *argv[]) {
  td::uint32 threads = 7;
  td::actor::Scheduler scheduler({threads});
  td::actor::ActorOwn<ton::validator::RootDb> rtDB;
  scheduler.run_in_context([&] {
    auto opts = ton::validator::ValidatorManagerOptions::create(
        ton::BlockIdExt{ton::masterchainId, ton::shardIdAll, 0, ton::RootHash::zero(), ton::FileHash::zero()},
        ton::BlockIdExt{ton::masterchainId, ton::shardIdAll, 0, ton::RootHash::zero(), ton::FileHash::zero()});
    //  auto mode = td::DbOpenMode::db_readonly;
    //  ton::validator::
    auto db_root_ = "/storage-1";
    LOG(INFO) << "Done!";
    rtDB = td::actor::create_actor<ton::validator::RootDb>(
        "db", td::actor::ActorId<ton::validator::ValidatorManager>(), db_root_, std::move(opts));
    LOG(INFO) << "Done!";

  });
  scheduler.run_in_context([&] {

  });

  while(scheduler.run(1)) {}
  LOG(INFO) << "Done!";
  return 0;
}