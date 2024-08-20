# Use an OpenJDK 17 slim base image
FROM openjdk:17-jdk-slim

# Update the package list and install necessary packages
RUN apt-get update && apt-get install -y wget iproute2

# Create a script to set up the IPv6 tunnel
RUN echo "#!/bin/sh\n\
ip tunnel add he-ipv6 mode sit remote 216.218.226.238 local 216.24.57.4 ttl 255\n\
ip link set he-ipv6 up\n\
ip addr add 2001:470:a:9f::2/64 dev he-ipv6\n\
ip route add ::/0 dev he-ipv6 via 2001:470:a:9f::1" > /usr/local/bin/setup-tunnel.sh

# Make the script executable
RUN chmod +x /usr/local/bin/setup-tunnel.sh

# Run the script to set up the tunnel
RUN /usr/local/bin/setup-tunnel.sh

# Set the working directory
WORKDIR /opt/Lavalink

# Download Lavalink.jar using wget
RUN wget https://github.com/lavalink-devs/Lavalink/releases/download/4.0.7/Lavalink.jar -O Lavalink.jar

# Copy the application.yml and healthcheck.js to the container
COPY application.yml application.yml

# Expose port 443 for the Lavalink server
EXPOSE 443

# Start both the Lavalink server and the health check server
CMD ["java", "-jar", "Lavalink.jar"]
