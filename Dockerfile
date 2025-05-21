# -------- STAGE 1: Build Java WAR --------
FROM maven:3.8.5-openjdk-11 AS build
WORKDIR /app
COPY . .
RUN mvn clean package

# -------- STAGE 2: Run on Tomcat --------
FROM tomcat:9.0.91-jdk11
COPY --from=build /app/target/WebAppCal-1.3.5.war /usr/local/tomcat/webapps/WebAppCal.war
