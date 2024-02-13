#!/bin/bash

sudo useradd -m -d /opt/tomcat -U -s /bin/false tomcat

sudo apt update -y
          
sudo apt install default-jdk -y
          
wget https://dlcdn.apache.org/tomcat/tomcat-10/v10.1.18/bin/apache-tomcat-10.1.18.tar.gz -P /tmp
          
sudo tar xzvf /tmp/apache-tomcat-10.1.18.tar.gz -C /opt/tomcat --strip-components=1 
          
sudo chown -R tomcat:tomcat /opt/tomcat/
sudo chmod -R u+x /opt/tomcat/bin
          
# Insertar usuarios en el archivo tomcat-users.xml
sudo sed -i '/<\/tomcat-users>/i\
<role rolename="manager-gui" \/>\
<user username="manager" password="test" roles="manager-gui" \/>\
<role rolename="admin-gui" \/>\
<user username="admin" password="test" roles="manager-gui,admin-gui" \/>' /opt/tomcat/conf/tomcat-users.xml
          
          
# Comentar la línea de Valve en el archivo manager/META-INF/context.xml
sudo sed -i '/<Valve className="org.apache.catalina.valves.RemoteAddrValve"/s/^/<!--/' /opt/tomcat/webapps/manager/META-INF/context.xml
sudo sed -i '/<Manager/ i\ -->' /opt/tomcat/webapps/manager/META-INF/context.xml
          
# Comentar la línea de Valve en el archivo host-manager/META-INF/context.xml
sudo sed -i '/<Valve className="org.apache.catalina.valves.RemoteAddrValve"/s/^/<!--/' /opt/tomcat/webapps/host-manager/META-INF/context.xml
sudo sed -i '/<Manager/ i\ -->' /opt/tomcat/webapps/host-manager/META-INF/context.xml
          
# Crear y configurar el servicio de systemd para Tomcat
sudo bash -c 'cat > /etc/systemd/system/tomcat.service <<EOF
[Unit]
Description=Tomcat
After=network.target
          
[Service]
Type=forking
          
User=tomcat
Group=tomcat
          
Environment="JAVA_HOME=/usr/lib/jvm/java-1.11.0-openjdk-amd64"
Environment="JAVA_OPTS=-Djava.security.egd=file:///dev/urandom"
Environment="CATALINA_BASE=/opt/tomcat"
Environment="CATALINA_HOME=/opt/tomcat"
Environment="CATALINA_PID=/opt/tomcat/temp/tomcat.pid"
Environment="CATALINA_OPTS=-Xms512M -Xmx1024M -server -XX:+UseParallelGC"
          
ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh
          
 RestartSec=10
Restart=always
          
[Install]
WantedBy=multi-user.target
EOF'
          
# Recargar el daemon de systemd
sudo systemctl daemon-reload
          
# Iniciar Tomcat
sudo systemctl start tomcat
          
# Verificar el estado de Tomcat
# sudo systemctl status tomcat
          
# Habilitar Tomcat para que se inicie automáticamente al arrancar
sudo systemctl enable tomcat
          
# Permitir el tráfico en el puerto 8080 a través del firewall
sudo ufw allow 8080
