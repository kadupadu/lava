FROM openjdk:17-jdk-slim

WORKDIR /opt/Lavalink

# Install wget to download files
RUN apt-get update && apt-get install -y wget

# Download Lavalink.jar from the official release
RUN wget https://github.com/lavalink-devs/Lavalink/releases/download/4.0.7/Lavalink.jar -O Lavalink.jar

# Copy the application.yml file to the container
COPY application.yml application.yml

EXPOSE 2333

CMD ["java", "-jar", "Lavalink.jar"]
