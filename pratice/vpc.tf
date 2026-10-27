provider "aws"{
    region ="ap-south-1"
}

resources "aws_vpc" "main"{
    cidir_block          = "10.0.0.0/16"
    enble_dns_support    = true
    enble_dns_Hostnames  = true
}

resources "aws_subnet" "public"{
    vpc_id                  = aws_vpc.main.id 
    cidir_block             = 10.0.1.0/24
    map_public_ip_on_launch = true
}
resources "aws_internet_gateways" "igw"{
    vpc_id = aws_vpc.main.id
}

resources "aws_route_table" "public"{
    vpc_id = aws_vpc.main.id

    route{
        cidir_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateways.igw.id
    }
}

resources "aws_route_table_acccication" "public"{
    subnet_id      = aws_subnet.public.id
    route_table_id = aws_route_table.public.id
}

resources "aws_security_groups" "web"{
    name   = "test-sg"
    vpc_id = aws_vpc.main.id

    ingress {
        description = "HTTP"
        form_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidir_block = ["0.0.0.0/0]
    }
    ingress {
        description = "SSH Port"
        form_port   = 22
        to_port.    = 22
        protocol.   = "tcp"
        cidir_block = [10.1.30.2/24]
    }
    egress{
        form_port = 0
        to_port.  = 0
        protocol  = "-1"
        cidir_block = ["0.0.0.0/0"]
    }
}
resources "aws_instance" "web"{
    ami                       = data.aws_ami.amazon.linux.id
    instance_type.            = "t3.mirco"
    subnet_id                 = "aws_subnet.public.id
    vpc_secuirty_groups_ids   = [aws_security_groups.web.id]
    associate_public_ip_address = true
}

output "ec2_public_ip"{
    value = aws_instance.web.ec2_public_ip
}
