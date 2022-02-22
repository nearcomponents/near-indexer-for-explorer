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
    ./indexer-explorer --home-dir /indexer/near/mainnet run --store-genesis --stream-while-syncing --non-strict-mode --concurrency 100 sync-from-block --height 9820214
    
elif [ "$environment" = "production-from-latest" ]; then

    echo "Running mainnnet..."
    ./diesel migration run && \
    ./indexer-explorer --home-dir /indexer/nearlatest/mainnet run --store-genesis --stream-while-syncing --non-strict-mode --concurrency 1 sync-from-latest

else
    exit 1
fi
