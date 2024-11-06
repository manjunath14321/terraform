resource "docker_container" "tomcat" {
  name  = "tomcat"
  image = docker_image.tomcat.name
  ports {
    internal = 8080
    external = 8082
  }
  command = ["bin/catalina.sh", "run"]
}

resource "docker_image" "tomcat" {
  name = "tomcat"
}

resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false # Optional, set to true if you want to keep the image locally
}

# Create a container from the Nginx image
resource "docker_container" "nginx_container" {
  name  = "nginx_container"
  image = docker_image.nginx.name
  ports {
    internal = 80   # Nginx default internal port
    external = 8081 # External port to access Nginx on host machine
  }
}

# Output the container IP address
output "nginx_container_ip" {
  value = "docker_container.nginx_container.ip_address"
}

# Output the container external port
output "nginx_container_external_port" {
  value = 8081
}
