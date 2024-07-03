#!/bin/bash

aws ecs execute-command --cluster cs2-server-cluster \
    --task "$1" \
    --container cs2-server \
    --interactive \
    --command "/bin/bash"
