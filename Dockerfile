FROM pytorch/pytorch:latest
# FROM python:3.8-slim


# Remove old lists and GPG keys
# RUN rm -rf /var/lib/apt/lists/* /etc/apt/trusted.gpg.d/* /etc/apt/trusted.gpg
# RUN  apt-get update
# RUN apt-get install --reinstall debian-keyring debian-archive-keyring
# RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 648ACFD622F3D138
# RUN apt-get install -y gnupg
# RUN apt-get clean && rm -rf /var/lib/apt/lists/*
# RUN echo "Acquire::Check-Valid-Until \"false\";" > /etc/apt/apt.conf.d/99no-check-valid-until
# RUN apt-get update --allow-insecure-repositories

# RUN apt-get clean && rm -rf /var/lib/apt/lists/* /etc/apt/trusted.gpg.d/* /etc/apt/trusted.gpg
 

# RUN  apt-get install -y iputils-ping
# RUN  ping -c 4 deb.debian.org

# Install curl and git, bypass GPG errors
# RUN apt-get update --allow-unauthenticated && apt-get install -y curl git
# RUN chmod +x run_app.sh
# RUN chmod +x frpc
# RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
# RUN apt-get update && apt-get install -y curl nodejs npm iputils-ping
# Add repository keys
# RUN rm -rf /var/lib/apt/lists/* \
#     && apt-get update \
#     && apt-get install -y curl 
# RUN apt-get update && apt-get install -y gnupg
# RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32
# RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 871920D1991BC93C


# Disable signature verification
# RUN apt-get update && apt-get install -y --no-install-recommends gnupg
# RUN echo 'Acquire::AllowInsecureRepositories "true";' > /etc/apt/apt.conf.d/99insecure \
#     && echo 'Acquire::AllowDowngradeToInsecureRepositories "true";' >> /etc/apt/apt.conf.d/99insecure \
#     && echo 'Acquire::AllowUnauthenticated "true";' >> /etc/apt/apt.conf.d/99insecure
# Disable signature verification
# RUN apt-get update 
    # && apt-get install -y --no-install-recommends gnupg --allow-unauthenticated

# Clean and update
# RUN rm -rf /var/lib/apt/lists/* \
#     && apt-get update --allow-unauthenticated \
#     && apt-get install -y curl git --allow-unauthenticated


# Clean and update
# RUN apt-get clean
# RUN   apt-get update \
    # &&
    # RUN apt-get update &&  apt-get install -y  curl 

# Remove existing APT lists and keys
# RUN rm -rf /var/lib/apt/lists/* \
#     && apt-key del 3B4FE6ACC0B21F32 || true \
#     && apt-key del 871920D1991BC93C || true

# # Add repository keys
# RUN apt-get update && apt-get install -y --no-install-recommends gnupg
# RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 3B4FE6ACC0B21F32
# RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 871920D1991BC93C

# # Clean and update
# RUN rm -rf /var/lib/apt/lists/* \
#     && apt-get update \
#     && apt-get install -y curl git

RUN apt-get update 
# && apt-get install -y curl git
# Clean and update

RUN curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
RUN apt-get install -y nodejs

WORKDIR /base
# RUN curl -o /base/frpc http://cdn-media.huggingface.co/frpc-gradio-0.2/frpc_linux_amd64


# COPY entrypoint.sh /base/entrypoint.sh
# COPY frpc /base/frpc

RUN pip install websockets

# Add these lines to your Dockerfile
# RUN apt-get update && \
#     apt-get install -y sudo && \
#     rm -rf /var/lib/apt/lists/*

# # Add user to sudoers
# RUN adduser --disabled-password --gecos '' docker && \
#     adduser docker sudo && \
#     echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
# # Install Docker Engine
# RUN apt-get update && apt-get install -y \
#     ca-certificates \
#     curl \
#     gnupg \
#     lsb-release

# # Add Docker's official GPG key
# RUN mkdir -p /etc/apt/keyrings && \
#     curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# # Set up Docker repository for Ubuntu
# RUN echo \
#     "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
#     $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# # Install Docker Engine
# RUN apt-get update && apt-get install -y \
#     docker-ce \
#     docker-ce-cli \
#     containerd.io \
#     docker-buildx-plugin \
#     docker-compose-plugin


#     RUN if ! getent group docker > /dev/null 2>&1; then \
#     groupadd docker; \
# fi && \
# useradd -m appuser && \
# usermod -aG docker appuser


# RUN apt-get install -y kmod
# RUN mkdir -p /dev/net && \
#     mknod /dev/net/tun c 10 200 && \
#     chmod 666 /dev/net/tun
RUN  apt-get update 
RUN apt-get install -y build-essential  podman=3.4.4+ds1-1ubuntu1.22.04.3 
RUN pip3 install podman-compose
RUN apt-get install -y git
# RUN echo "alias docker-compose='podman-compose'" >> ~/.bashrc
COPY entrypoint.sh .
COPY frpc .
COPY profile.sh .
COPY run_app.py .
# COPY registries.conf /etc/containers/registries.conf
# COPY containers.conf /etc/containers/containers.conf
# RUN chmod +x /base/frpc /base/entrypoint.sh /base/profile.sh
RUN chmod +x entrypoint.sh profile.sh frpc
#  && \
#     chown -R appuser:docker /base
# USER appuser
# COPY daemon.json /etc/docker/daemon.json
ENTRYPOINT ["/base/entrypoint.sh"]