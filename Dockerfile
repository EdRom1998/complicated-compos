FROM maven:3.6.3-openjdk-8 AS build
RUN git clone https://github.com/shephertz/App42PaaS-Java-MySQL-Sample.git /app
WORKDIR /app
COPY Config.properties /app/WebContent/Config.properties
RUN mvn clean package -DskipTests

FROM tomcat:8-jre8-alpine
RUN apk add --no-cache unzip
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /app/target/*.war /tmp/app.war
RUN mkdir -p /usr/local/tomcat/webapps/ROOT && \
    cd /usr/local/tomcat/webapps/ROOT && \
    unzip /tmp/app.war && \
    rm /tmp/app.war
RUN mkdir -p /usr/local/tomcat/ROOT
COPY Config.properties /usr/local/tomcat/ROOT/Config.properties

EXPOSE 8080
CMD ["catalina.sh", "run"]