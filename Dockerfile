FROM ubuntu:20.04

# Opt-out of Microsoft's telemetry 
# shouldn't be on by default, grumble grumble
ENV DOTNET_CLI_TELEMETRY_OPTOUT 1

# Install deps and create a user so we can drop privileges
RUN apt-get update \
    && apt-get install -y wget apt-transport-https \
    && wget https://packages.microsoft.com/config/ubuntu/20.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb  \
    && dpkg -i packages-microsoft-prod.deb \
    && apt-get update \
    && apt-get install -y apt-transport-https dotnet-sdk-3.1 \
    && useradd -ms /bin/bash twitterdump

# Switch to the new user
USER twitterdump
ENV PATH="/home/twitterdump/.dotnet/tools:${PATH}"

# Install the tool
RUN dotnet tool install --global TwitterDump


    
    
