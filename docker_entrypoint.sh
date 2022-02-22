#!/bin/bash

echo "Working directory is `pwd`"
sleep 5

if [ "$environment" = "development" ]; then

    echo "Running localnet..."
    ./diesel migration run && \
    ./indexer-explorer --home-dir /indexer/near/localnet run --store-genesis --stream-while-syncing --non-strict-mode --concurrency 100 sync-from-latest

elif [ "$environment" = "staging" ]; then

    echo "Running testnet..."
    ./diesel migration run && \
    ./indexer-explorer --home-dir /indexer/near/testnet run --store-genesis --stream-while-syncing --non-strict-mode --concurrency 100 sync-from-interruption --delta 500

elif [ "$environment" = "production" ]; then

    echo "Running mainnnet..."
    ./diesel migration run && \
    ./indexer-explorer --home-dir /indexer/near/mainnet init ${BOOT_NODES:+--boot-nodes=${BOOT_NODES}} --chain-id mainnet --download-config --download-genesis && \
    cd /indexer/near/mainnet && \
    rm -rf config.json && \
    wget https://s3-us-west-1.amazonaws.com/build.nearprotocol.com/nearcore-deploy/mainnet/config.json && \
    sed -i 's/"archive": false/"archive": true/' /indexer/near/mainnet/config.json && \
    cd /near/indexer-explorer && \
    ./indexer-explorer --home-dir /indexer/near/mainnet run --store-genesis --stream-while-syncing --non-strict-mode --concurrency 100 sync-from-block --height 9820214

else
    exit 1
fi
