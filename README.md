# cs2-docker
A Counter-Strike 2 server that runs in docker with pre-baked CSS plugins

## How It Works
1. This docker image uses the [joedwards32/cs2](https://github.com/joedwards32/CS2) image as its base image.
2. When the container starts, it will download Counter-Strike 2 into the `/home/steam/cs2-dedicated` directory, which also happens to be a volume. If the game is already present in the volume, it will attempt to update it.
3. Once the game is fully downloaded and up-to-date, it will run the dedicated game server.
    - Before running the server, it will run a `pre.sh` hook. By default this hook does nothing, but our Dockerfile overwrites the file with the contents in [hooks/pre.sh](hooks/pre.sh).
    - Because of how the base image is configured, the hook scripts are only copied if they do not currently exist in the `/home/steam/cs2-dedicated` directory. To get around any potential caching issues, we've configured our version of the `pre.sh` hook to create and execute another script by proxy. The hook will delete the existing proxy script and copy over the latest file to ensure we're running the most up-to-date version, without needing to change the `pre.sh` script.
4. The [install plugins script](hooks/ephemeral/install-plugins.sh) executed by the pre-hook will [install metamod and CounterStrikeSharp](https://docs.cssharp.dev/docs/guides/getting-started.html) if they do not already exist. It will also install any CounterStrikeSharp plugins copied to the Docker image in the `/tmp/plugins` directory.
    - Plugins are added as git submodules in the [plugins directory](plugins/) and are built in a [build stage](https://docs.docker.com/build/building/multi-stage/) in the Dockerfile.
5. When a pull request is merged into the `main` branch, a github action will build the docker image, push it to AWS Elastic Container Registry, and a task definition is deployed to AWS Elastic Container Service with the newly published image.

## AWS Architecture
![alt text](docs/architecture-diagram.png "Architecture Diagram")

## Local Setup
1. Clone the repository
    ```bash
    git clone git@github.com:atakanCocen/cs2-docker.git
    cd cs2-docker
    ```
2. Initialize and update the submodules
    ```bash
    git submodule update --init --recursive
    ```
3. Build the docker image
    ```
    docker build -t cs2-server .
    ```
