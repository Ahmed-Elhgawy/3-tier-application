# In This File the script which creates the instance is defined, and its dependency

# Key Pair
resource "aws_key_pair" "key_pair" {
  count = var.create_key_pair ? 1 : 0

  key_name   = "key-pair"
  public_key = file(var.public_key_path)

  tags = merge(local.common_tags, var.tags, {
    Name = "key-pair"
  })
}

# Instance Created in Public Subnet
resource "aws_instance" "public_instance" {
  count                       = var.create_public_instance ? length(var.public_subnet_id) : 0
  ami                         = var.amazon_or_ubuntu == "amazon" ? local.amazon_linux : local.ubuntu
  instance_type               = var.public_instance_type
  key_name                    = var.create_key_pair ? aws_key_pair.key_pair[0].key_name : null
  associate_public_ip_address = true
  subnet_id                   = var.public_subnet_id[count.index]
  vpc_security_group_ids      = [aws_security_group.public_instance_sg.id]
  user_data                   = var.add_public_instance_user_data ? var.public_instance_user_data : null

  tags = merge(local.common_tags, var.tags, {
    Name   = "public-instance-${count.index + 1}"
    type   = var.amazon_or_ubuntu == "amazon" ? "amazon_linux" : "ubuntu"
    Punlic = "true"
  })
}

# Instance Created in Private Subnet
resource "aws_instance" "private_instance" {
  count                       = var.create_private_instance ? length(var.private_subnet_id) : 0
  ami                         = var.amazon_or_ubuntu == "amazon" ? local.amazon_linux : local.ubuntu
  instance_type               = var.private_instance_type
  key_name                    = var.create_key_pair ? aws_key_pair.key_pair[0].key_name : null
  associate_public_ip_address = false
  subnet_id                   = var.private_subnet_id[count.index]
  vpc_security_group_ids      = [aws_security_group.private_instance_sg.id]
  user_data                   = var.add_private_instance_user_data ? var.private_instance_user_data : null

  tags = merge(local.common_tags, var.tags, {
    Name   = "private-instance-${count.index + 1}"
    type   = var.amazon_or_ubuntu == "amazon" ? "amazon_linux" : "ubuntu"
    Public = "false"
  })
}
