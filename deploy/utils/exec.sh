#!/bin/bash

# ./exec.sh prod-ftfp eefb71211454457e87dd4a5ff201ffd1 prod-ftfp-api-container

aws ecs execute-command --cluster $1 \
    --task $2 \
    --container $3 \
    --interactive \
    --command "/bin/sh"
