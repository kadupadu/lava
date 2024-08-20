# Use an OpenJDK 17 slim base image
FROM openjdk:17-jdk-slim

# Update the package list and install necessary packages
RUN apt-get update && apt-get install -y wget nano netplan.io iputils-ping curl

# Create the /etc/netplan/ directory if it doesn't exist
RUN mkdir -p /etc/netplan

# Create the 99-he-tunnel.yaml file and add the tunnel configuration
RUN echo "network:\n  version: 2\n  tunnels:\n    he-ipv6:\n      mode: sit\n      remote: 216.218.226.238\n      local: 216.24.57.4\n      addresses:\n        - \"2001:470:a:9f::2/64\"\n      routes:\n        - to: default\n          via: \"2001:470:a:9f::1\"" > /etc/netplan/99-he-tunnel.yaml

# Apply the netplan configuration and try it
RUN netplan try --timeout 10 || true

# Reboot the container to apply the configuration (simulated by restarting networking services)
RUN systemctl restart networking

# Enable non-local binding for IPv6
RUN sysctl -w net.ipv6.ip_nonlocal_bind=1
RUN echo 'net.ipv6.ip_nonlocal_bind = 1' >> /etc/sysctl.conf

# Replace the local IPv6 route with the one from Tunnelbroker
RUN ip -6 route replace local 2001:470:a:9f::/64 dev lo

# Test the IPv6 configuration
RUN ping6 -c 4 google.com
RUN curl -6 https://ifconfig.co

# Set the working directory
WORKDIR /opt/Lavalink

# Download Lavalink.jar using wget
RUN wget https://github.com/lavalink-devs/Lavalink/releases/download/4.0.7/Lavalink.jar -O Lavalink.jar

# Copy the application.yml to the container
COPY application.yml application.yml

# Expose port 443 for the Lavalink server
EXPOSE 443

# Start both the Lavalink server and the health check server
CMD ["java", "-jar", "Lavalink.jar"]
