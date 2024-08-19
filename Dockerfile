# Use an OpenJDK 17 slim base image
FROM openjdk:17-jdk-slim

WORKDIR /opt/Lavalink

# Install wget to download Lavalink.jar
RUN wget https://github.com/lavalink-devs/Lavalink/releases/download/4.0.7/Lavalink.jar -O Lavalink.jar

# Copy the application.yml and healthcheck.js to the container
COPY application.yml application.yml

EXPOSE 443

# Start both the Lavalink server and the health check server
CMD ["java", "-jar", "Lavalink.jar"]
