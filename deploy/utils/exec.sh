#!/bin/bash

# ./exec.sh prod-ftfp 1bf6365852ba403a84719fd46e16bc52 prod-ftfp-api-container

aws ecs execute-command --cluster $1 \
    --task $2 \
    --container $3 \
    --interactive \
    --command "/bin/sh"
