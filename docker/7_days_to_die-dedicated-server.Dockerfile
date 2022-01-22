#######################################################################
#   Author: Renegade-Master
#   Description: Base image for running a Dedicated 7 Days to Die
#       server.
#   License: GNU General Public License v3.0 (see LICENSE)
#######################################################################

# Set the User and Group IDs
ARG USER_ID=1000
ARG GROUP_ID=1000

FROM renegademaster/steamcmd-minimal:1.0.0
ARG USER_ID
ARG GROUP_ID

# Add metadata labels
LABEL com.renegademaster.7_days_to_die-dedicated-server.authors="Renegade-Master" \
    com.renegademaster.7_days_to_die-dedicated-server.source-repository="https://github.com/Renegade-Master/7_days_to_die-dedicated-server" \
    com.renegademaster.7_days_to_die-dedicated-server.image-repository="https://hub.docker.com/renegademaster/7_days_to_die-dedicated-server"

# Copy the source files
COPY src /home/steam/

# Temporarily login as root to modify ownership
USER 0:0
RUN chown -R ${USER_ID}:${GROUP_ID} "/home/steam" \
    # Workaround for instances when the folder is linked to the root
    && ln -s /home/steam/.local/ /.local \
    && ln -s /home/steam/.config/ /.config

# Install runtime dependencies
RUN apt-get update && apt-get autoremove -y \
    && apt-get install -y --no-install-recommends \
        python3 \
    && rm -rf /var/lib/apt/lists/*

# Switch to the Steam User
USER ${USER_ID}:${GROUP_ID}

# Run the setup script
ENTRYPOINT ["/bin/bash", "/home/steam/run_server.sh"]
