# Use an OpenJDK 17 slim base image
FROM openjdk:17-jdk-slim

# Update the package list and install necessary packages
RUN apt-get update && apt-get install -y wget iproute2 iputils-ping curl

# Manually configure the IPv6 tunnel
RUN ip tunnel add he-ipv6 mode sit remote 216.218.226.238 local 216.24.57.4 ttl 255
RUN ip link set he-ipv6 up
RUN ip addr add 2001:470:a:9f::2/64 dev he-ipv6
RUN ip -6 route add ::/0 dev he-ipv6

# Enable non-local binding for IPv6
RUN sysctl -w net.ipv6.ip_nonlocal_bind=1
RUN echo 'net.ipv6.ip_nonlocal_bind = 1' >> /etc/sysctl.conf

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
