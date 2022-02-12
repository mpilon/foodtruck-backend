#!/bin/bash

eval "$(pyenv init -)"

pyenv activate foodtruck

export ELASTICACHE_REDIS_REPLICATION_GID=""

cd app && flask run
