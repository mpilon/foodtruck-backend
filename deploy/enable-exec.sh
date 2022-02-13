#!/bin/bash

#  ./enable-exec.sh prod-ftfp prod-ftfp-service

aws ecs update-service --cluster $1 --service $2 --enable-execute-command


