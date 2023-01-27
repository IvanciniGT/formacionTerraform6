# Crear un servidor

resource "aws_instance" "servidor" {
  ami           = data.aws_ami.miimagen.image_id
  instance_type = "t3.micro"
  //key_name      = "clavePublica${var.despliegue}"       // Funcionaría esto? 
                                                            // NO       100%
                                                            // SI 
                                                            // NPI ?    Ivan
                                                                    // Depende de en que orden se creen las cosas
  key_name      = aws_key_pair.deployer.key_name        // Pongo el nombre y además: Genero la dependencia
  security_groups = [ aws_security_group.reglas_servidor.name ]
  
  tags = {
    Name = "Servidor de ${var.despliegue}"
  }
  
  provisioner "local-exec" {
      command = "sleep 20 && ping -c 1 ${self.public_ip}"
  }
  
  connection {
      type       = "ssh"
      host       = self.public_ip
      port       = 22
      user       = "ubuntu"
      private_key = module.misclaves.keys.private.pem
  }
  
  provisioner "remote-exec" {
      inline = [ "echo EUREKA" ]
  }
  
}

resource "aws_security_group" "reglas_servidor" {
  name        = "reglas-servidor-${var.despliegue}"
  description = "Permitor todo"
  vpc_id      = null

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "reglas-servidor-${var.despliegue}"
  }
}


resource "aws_key_pair" "deployer" {
  key_name   = "clavePublica${var.despliegue}"
  public_key = module.misclaves.keys.public.openssh
}

module "misclaves" {
    source          =   "../modulo_claves_ssh"
    regenerate_keys = true
}

variable "despliegue" {
    type = string
    nullable = false
}

data "aws_ami" "miimagen" {
  most_recent      = true
  owners           = ["099720109477"]

  filter {
    name   = "name"
    values = ["*ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}



// Le pedimos a Terraform que haga la búsqueda por nosotros? AUTOMATIZAMOS ESA BUSQUEDA? Eso es un data !

// Canonical: 099720109477
// Imagen: ubuntu-jammy-22.04-amd64-server-
// Tipo de dispositivo raíz: ebs
// Virtualización: hvm

// Bastante inutil
// Directamente: Puedo acceder a la máquina ? NO
//  Ni claves
//  La he pinchao en una red? a la por defecto de la zona
//  Le he abierto conectividad en amazon en la red de turno         SecurityGroups
// Minima prueba 

// Tiene otro problemón esto!
// En lo que SI HEMOS HECHO !
//  La AMI podria dejar de existir en un momento dado
//  Dentro de 6 meses cuando vuelva a ejecutar este script, querré el mismo AMI? 
//  Querré una versión actualizada del mismo software