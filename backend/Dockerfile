# syntax=docker/dockerfile:1

FROM maven:3.9-eclipse-temurin-26-alpine AS build
WORKDIR /app
COPY pom.xml .
RUN --mount=type=cache,target=/root/.m2 \
    mvn -B dependency:go-offline -DskipTests
COPY src ./src
RUN --mount=type=cache,target=/root/.m2 \
    mvn -B -DskipTests package

FROM eclipse-temurin:26-jre-alpine
RUN apk add --no-cache wget
WORKDIR /app
RUN addgroup -S app && adduser -S app -G app
USER app
COPY --from=build /app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
