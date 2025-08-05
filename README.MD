# 🌐 Infraestructura con Terraform: EC2 + Docker + NGINX en AWS

Este proyecto crea una infraestructura mínima en AWS utilizando **Terraform**, que despliega una instancia **EC2 con Ubuntu**, instala **Docker**, y ejecuta un contenedor **NGINX** con una demo web accesible en el puerto 80.

> 🛠️ Este es un proyecto personal de práctica orientado a cloud, contenedores e infraestructura como código.

---

## 🚀 ¿Qué hace este proyecto?

- Crea una **VPC personalizada** con una subred pública.
- Crea e integra un **Internet Gateway** y una **tabla de rutas**.
- Configura un **Security Group** con acceso a:
  - HTTP (puerto 80)
  - HTTPS (puerto 443)
  - SSH (puerto 22, por default acepta conexiones desde cualquier ip en este entorno de prueba, pero puedes modificar el archivo terraform.tfvars y cambiar la variable "your_ip" con tu ip pública y asi solo aceptará conexiones desde tu ip.)
- Despliega una **instancia EC2** con:
  - Docker instalado automáticamente.
  - El contenedor `nginxdemos/hello` corriendo en el puerto 80.
- Genera una **clave SSH** (key pair) para conexión segura.

---

## 🧰 Tecnologías utilizadas

- **Terraform**
- **AWS EC2, VPC, Subnet, Security Groups, Internet Gateway, Route Tables**
- **Docker**
- **Bash (user_data script)**
- **SSH**

---

## 📦 Requisitos

- Cuenta de AWS (con permisos para EC2, VPC, etc.). Se debe usar las credenciales de AWS en Terraform.
- AWS CLI configurado (`aws configure`)
- Terraform instalado (`terraform -v`)
- Par de llaves SSH (`my-key.pub` en el directorio `keys/`)

---

## ⚙️ Cómo usar este proyecto

1. **Clona el repositorio**
   ```bash
   git clone https://github.com/frankgonzmc/AWS-EC2-DOCKER.git
   cd AWS-EC2-DOCKER

2. **Crea un directorio 'keys' para guardar las llaves de acceso**
   ```bash
   mkdir keys

3. **Crear la llave pública y privada, proteger y dar permisos a la llave privada**
   ```bash
   ssh-keygen -t rsa -b 4096 -f ./keys/my-key -N ""
   chmod 600 ./keys/my-key

4. **Opcional (Agregar la extensión .pem a la llave privada)**
   ```bash
   mv ./keys/my-key ./keys/my-key.pem

5. **Iniciar el proyecto Terraform**
   ```bash
   terraform init

6. **Crear el plan del proyecto en terraform**
   ```bash
   terraform plan

7. **Aplicar el plan para ejecución en Terraform**
   ```bash
   terraform apply

8. **Obtener la ip pública de la instancia**
    Puedes obtenerla en la consola, después de hacer apply como:
    Outputs:
        ip_publica = "x.x.x.x"

9. **Ver el servidor NGINX**
    Para visualizar el servidor NGINX debes dirigirte en el navegador a:
        ip_publica:80

10. **Para hacer una conexión SSH**
   ```bash
   ssh -i ./keys/my-key ubuntu@<ip_publica>

**Autor**
**Frank Puertas Fuentes – [LinkedIn](https://www.linkedin.coinfrank-gonzalo-puertas-fuentes-36a907240/)**