#!/bin/bash

# ./exec.sh prod-ftfp e083feec9c6e4b159efe394f9684598e prod-ftfp-api-container

aws ecs execute-command --cluster $1 \
    --task $2 \
    --container $3 \
    --interactive \
    --command "/bin/sh"
