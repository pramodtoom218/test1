provider "aws" {
region = "us-east-2"
access_key="AKIAWRACSQDZ3VEKLGVB"
secret_key="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"
}
resource "aws_vpc"  "main" {
cidr_block = "10.0.0.0/16"
instance_tenancy = "default"
tags ={

name = "main" 
 
   } 
}


resource "aws_subnet" "publicsubnet" {

vpc_id =  "${aws_vpc.main.id}"

cidr_block =  "10.0.1.0/24"


tags ={ 

name = "publicsubnet" 
    }   

}

resource "aws_subnet" "privatesubnet" {

vpc_id =  "${aws_vpc.main.id}"

cidr_block =  "10.0.2.0/24"


tags ={

name = "privatecsubnet"
    }

} 


resource "aws_internet_gateway" "main-gw" {



vpc_id = "${aws_vpc.main.id}"



tags ={


name = "main"


    }
}


resource "aws_route_table"  "public" {

vpc_id = "${aws_vpc.main.id}"


route {

cidr_block ="0.0.0.0/0"


gateway_id = "${aws_internet_gateway.main-gw.id}"


} 


tags ={

name = "rtb"

  }

}
resource "aws_route_table" "private" {

vpc_id = "${aws_vpc.main.id}"

route {

cidr_block = "0.0.0.0/0"

nat_gateway_id = "${aws_nat_gateway.ngw.id}"

}

tags ={

name = "privatesubnet"

  }

}


resource "aws_route_table_association" "main-public" {

subnet_id = "${aws_subnet.publicsubnet.id}"

route_table_id = "${aws_route_table.public.id}"


}

resource "aws_route_table_association" "main-private" {

subnet_id = "${aws_subnet.privatesubnet.id}"

route_table_id = "${aws_route_table.private.id}"

}
resource  "aws_eip" "nat" {


vpc = true

}


resource "aws_nat_gateway" "ngw" {       

allocation_id = "${aws_eip.nat.id}"

subnet_id  = "${aws_subnet.publicsubnet.id}"

depends_on = ["aws_internet_gateway.main-gw"]

}















































