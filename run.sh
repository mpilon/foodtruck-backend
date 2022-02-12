#!/bin/bash

eval "$(pyenv init -)"

pyenv activate foodtruck

export ELASTICACHE_REDIS_REPLICATION_GID="test"

cd app && flask run
