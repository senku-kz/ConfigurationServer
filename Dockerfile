# Stage 1: Build
FROM maven:3.8.5-openjdk-17 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Stage 2: Package
FROM openjdk:17-jdk-slim

# Create a non-root user
RUN useradd -m springuser

# Set the working directory and copy the application JAR
WORKDIR /app
COPY --from=build /app/target/*-SNAPSHOT.jar app.jar

# Set permissions
RUN chown -R springuser:springuser /app

# Switch to non-root user
USER springuser

EXPOSE 8888
ENTRYPOINT ["java", "-jar", "app.jar"]