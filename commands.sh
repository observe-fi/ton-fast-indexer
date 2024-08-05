docker buildx build . --file fi.dockerfile --tag ar0x443/fast-indexer-dev-env:latest
docker run -d -p 8821:22 -v "/storage-1":/ton-db ar0x443/fast-indexer-dev-env:v0.0.2
docker exec -it 7f1a5deaf0fcb86c4349343cf0e87247931b670b46f59080c470783bd7ab6a3e /bin/bash
docker commit 1c9bf67f3ed8 ar0x443/fast-indexer-dev-env:v0.0.2

