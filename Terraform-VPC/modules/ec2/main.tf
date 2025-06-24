resource "aws_instance" "ec2" {
  count = length(var.subnet_ids)
  ami           = data.aws_ami.amazon_linux_2.id
  instance_type = "t2.micro"
  vpc_security_group_ids = [var.sg-id]
  associate_public_ip_address = true
  subnet_id = var.subnet_ids[count.index]
  availability_zone = data.aws_availability_zones.available.names[count.index]
  


  user_data = <<-EOF
#!/bin/bash
sudo yum update -y
sudo yum install -y httpd
sudo yum install -y git

META_INST_ID=$(curl -s http://169.254.169.254/latest/meta-data/instance-id)
META_INST_TYPE=$(curl -s http://169.254.169.254/latest/meta-data/instance-type)
META_INST_AZ=$(curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone)

cat <<HTML > /var/www/html/index.html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>EC2 Instance Info</title>
  <style>
    body { font-family: Arial, sans-serif; background-color: #f4f4f4; padding: 40px; }
    .card {
      background: white;
      padding: 20px;
      max-width: 600px;
      margin: auto;
      border-radius: 10px;
      box-shadow: 0 4px 8px rgba(0,0,0,0.1);
    }
    h1 { color: #333; }
    .info { margin-top: 20px; }
    .label { font-weight: bold; color: #555; }
  </style>
</head>
<body>
  <div class="card">
    <h1>EC2 Instance Info</h1>
    <div class="info"><span class="label">Instance ID:</span> $META_INST_ID</div>
    <div class="info"><span class="label">Instance Type:</span> $META_INST_TYPE</div>
    <div class="info"><span class="label">Availability Zone:</span> $META_INST_AZ</div>
  </div>
</body>
</html>
HTML

sudo systemctl start httpd
sudo systemctl enable httpd
EOF



  tags = {
    Name = "proj-2-instance-${count.index + 1}"
  }
}