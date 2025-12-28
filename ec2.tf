resource "aws_instance" "web" {
  count         = 2
  ami           = "ami-03f4878755434977f"   # Ubuntu 22.04 LTS (ap-south-1)
  instance_type = var.instance_type
  subnet_id     = aws_subnet.public[count.index].id
  vpc_security_group_ids = [aws_security_group.ec2_sg.id]

  user_data = <<-EOF
              #!/bin/bash
              apt update -y
              apt install -y apache2
              systemctl start apache2
              systemctl enable apache2

              cat <<HTML > /var/www/html/index.html
              <!DOCTYPE html>
              <html>
              <head>
                <title>Terraform IaC</title>
                <style>
                  body {
                    background-color: #0f172a;
                    display: flex;
                    justify-content: center;
                    align-items: center;
                    height: 100vh;
                    margin: 0;
                    font-family: Arial, sans-serif;
                  }

                  .glow-box {
                    padding: 40px;
                    border: 4px solid transparent;
                    border-radius: 15px;
                    font-size: 32px;
                    color: white;
                    text-align: center;
                    background: linear-gradient(#0f172a, #0f172a) padding-box,
                                linear-gradient(90deg, red, green, blue, red) border-box;
                    animation: glow 3s linear infinite;
                  }

                  @keyframes glow {
                    0% {
                      box-shadow: 0 0 10px red;
                    }
                    33% {
                      box-shadow: 0 0 20px green;
                    }
                    66% {
                      box-shadow: 0 0 20px blue;
                    }
                    100% {
                      box-shadow: 0 0 10px red;
                    }
                  }
                </style>
              </head>
              <body>
                <div class="glow-box">
                  Infrastructure as Code using Terraform (AWS)
                </div>
              </body>
              </html>
              HTML
              EOF

  tags = {
    Name = "web-${count.index}"
  }
}
