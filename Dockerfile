# Use an OpenJDK 17 slim base image
FROM openjdk:17-jdk-slim

# Install Node.js to run the health check server
RUN apt-get update && apt-get install -y wget curl gnupg && \
    curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
    apt-get install -y nodejs && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /opt/Lavalink

# Install wget to download Lavalink.jar
RUN wget https://github.com/lavalink-devs/Lavalink/releases/download/4.0.7/Lavalink.jar -O Lavalink.jar

# Copy the application.yml and healthcheck.js to the container
COPY application.yml application.yml
COPY healthcheck.js healthcheck.js

EXPOSE 2333 8080

# Start both the Lavalink server and the health check server
CMD ["sh", "-c", "node healthcheck.js & java -jar Lavalink.jar"]
