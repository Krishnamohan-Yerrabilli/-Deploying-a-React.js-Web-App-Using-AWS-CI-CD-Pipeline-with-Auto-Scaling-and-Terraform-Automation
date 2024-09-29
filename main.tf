# Setting up the AWS provider to use in this config
provider "aws" {
  region = "us-east-1" # Where in the world our resources will live
}

# Creating a VPC to keep our resources organized and isolated
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16" # Defining the IP range for our VPC
}

# Now, let's create a public subnet within that VPC
resource "aws_subnet" "public" {
  vpc_id     = aws_vpc.main.id # Telling it which VPC to use
  cidr_block = "10.0.1.0/24"    # This is the IP range for our subnet
}

# Time to spin up an EC2 instance for our React app
resource "aws_instance" "react_app" {
  ami           = "ami-0c55b159cbfafe1f0" # The AMI ID we need (make sure it's suitable for your region!)
  instance_type = "t2.micro"              # Choosing a small instance type (perfect for testing!)
  subnet_id     = aws_subnet.public.id     # Putting this instance in our public subnet
  tags = {                                  # Adding some tags to make this instance easy to identify
    Name = "ReactAppServer"                # Giving it a friendly name
  }
}

# Let's create an S3 bucket to host our React app
resource "aws_s3_bucket" "react_app_bucket" {
  bucket = "my-react-app-bucket" # Pick a unique name for your bucket (this one needs to be global)
  acl    = "public-read"          # Allow public read access, so anyone can see our app

  # Setting this bucket up for static website hosting
  website {
    index_document = "index.html" # This is the homepage for our site
  }
}

# Uploading the built React app's index.html to our S3 bucket
resource "aws_s3_bucket_object" "react_app" {
  bucket = aws_s3_bucket.react_app_bucket.bucket # Referring to our bucket created above
  key    = "index.html"                           # Name of the file in the bucket
  source = "build/index.html"                     # Path to the built file we want to upload
  acl    = "public-read"                          # Making sure it’s publicly readable
}

# Outputting the website URL for easy access
output "s3_website_url" {
  value = aws_s3_bucket.react_app_bucket.website_endpoint # This is the link to our S3 website
}
