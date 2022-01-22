# 7 Days to Die Dedicated Server

## Disclaimer

**Note:** This image is not officially supported by Valve, nor by The Fun Pimps.

If issues are encountered, please report them on
the [GitHub repository](https://github.com/Renegade-Master/7_days_to_die-dedicated-server/issues/new/choose)

## Badges

[![Build and Test Server Image](https://github.com/Renegade-Master/7_days_to_die-dedicated-server/actions/workflows/docker-build.yml/badge.svg?branch=main)](https://github.com/Renegade-Master/7_days_to_die-dedicated-server/actions/workflows/docker-build.yml)

![Docker Image Version (latest by date)](https://img.shields.io/docker/v/renegademaster/7_days_to_die-dedicated-server?label=Latest%20Version)
![Docker Image Size (latest by date)](https://img.shields.io/docker/image-size/renegademaster/7_days_to_die-dedicated-server?label=Image%20Size)
![Docker Pulls](https://img.shields.io/docker/pulls/renegademaster/7_days_to_die-dedicated-server?label=Docker%20Pull%20Count)

## Description

Dedicated Server for 7 Days to Die using Docker, and optionally Docker-Compose.  
Built almost from scratch to be the smallest 7 Days to Die Dedicated Server around!

## Links

Source:

- [GitHub](https://github.com/Renegade-Master/7_days_to_die-dedicated-server)
- [DockerHub](https://hub.docker.com/r/renegademaster/7_days_to_die-dedicated-server)

Resource links:

- [Valve Dedicated Server Wiki](https://developer.valvesoftware.com/wiki/7_Days_to_Die_Dedicated_Server)
- [Dedicated Server Configuration](https://7daystodie.fandom.com/wiki/Server#How_to_host_a_server)
- [Steam DB Page](https://steamdb.info/app/294420/)

## Instructions

The server can be run using plain Docker, or using Docker-Compose. The end-result is the same, but Docker-Compose is
recommended.

*Optional arguments table*:

| Argument            | Description                                                            | Values        | Default          |
|---------------------|------------------------------------------------------------------------|---------------|------------------|
| `GAME_VERSION`      | Game version to serve                                                  | [a-zA-Z0-9_]+ | `public`         |
| `PUBLIC_SERVER`     | Is the server displayed Publicly                                       | [0-3]         | 2                |
| `QUERY_PORT`        | Port for other players to connect to                                   | 1000 - 65535  | 26900            |
| `SERVER_NAME`       | Publicly visible Server Name                                           | [a-zA-Z0-9]+  | 7DaysToDieServer |
| `SERVER_DESC`       | Publicly visible Server Description                                    | [a-zA-Z0-9]+  | 7DaysToDieServer |
| `SERVER_PASSWORD`   | Server password                                                        | [a-zA-Z0-9]+  |                  |
| `SERVER_LOG_FILE`   | Path to store log file                                                 | [a-zA-Z0-9]+  |                  |
| `MAX_PLAYERS`       | Maximum amount of player to be permitted into the game                 | [0-9]+        | 8                |

### Docker

The following are instructions for running the server using the Docker image.

1. Acquire the image locally:
    * Pull the image from DockerHub:

      ```shell
      docker pull renegademaster/7_days_to_die-dedicated-server:<tagname>
      ```
    * Or alternatively, build the image:

      ```shell
      git clone https://github.com/Renegade-Master/7_days_to_die-dedicated-server.git \
          && cd 7_days_to_die-dedicated-server

      docker build -t renegademaster/7_days_to_die-dedicated-server:<tag> -f docker/7_days_to_die-dedicated-server.Dockerfile .
      ```

2. Run the container:

   ***Note**: Arguments inside square brackets are optional. If the default ports are to be overridden, then the
   `published` ports below must also be changed*

   ```shell
   mkdir 7DTDConfig 7DTDSaves 7DTDServer

   docker run --detach \
       --mount type=bind,source="$(pwd)/7DTDServer",target=/home/steam/7DTDServer \
       --mount type=bind,source="$(pwd)/7DTDConfig",target=/home/steam/7DTDConfig \
       --publish 26900:26900/tcp --publish 26900:26900/udp --publish 26901:26901/udp --publish 26902:26902/udp \
       --name 7dtd-dedicated_server \
       --user=$(id -u):$(id -g) \
       [--env=GAME_VERSION=<value>] \
       [--env=QUERY_PORT=<value>] \
       [--env=SERVER_NAME=<value>] \
       [--env=SERVER_PASSWORD=<value>] \
       [--env=SERVER_LOG_FILE=<value>] \
       [--env=MAX_PLAYERS=<value>] \
       renegademaster/7_days_to_die-dedicated-server[:<tagname>]
   ```

4. Once you see `INF [Steamworks.NET] GameServer.LogOn successful` in the console, people can start to join the server.

### Docker-Compose

The following are instructions for running the server using Docker-Compose.

1. Download the repository:

   ```shell
   git clone https://github.com/Renegade-Master/7_days_to_die-dedicated-server.git \
       && cd 7_days_to_die-dedicated-server
   ```

2. Make any configuration changes you want to in the `docker-compose.yaml` file. In
   the `services.dedicated_server.environment` section, you can change values for the server configuration.

   ***Note**: If the default ports are to be overridden, then the `published` ports must also be changed*

3. In the `docker-compose.yaml` file, you must change the `service.dedicated_server.user` values to match your local
   user. To find your local user and group ids, run the following command:

   ```shell
   printf "UID: %s\nGID: %s\n" $(id -u) $(id -g)
   ```

4. Run the following commands:

   ```shell
   mkdir 7DTDConfig 7DTDSaves 7DTDServer

   docker-compose up --build --detach
   ```

6. Once you see `INF [Steamworks.NET] GameServer.LogOn successful` in the console, people can start to join the server.
