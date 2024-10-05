<div align="center">

# Deploying a React.js Web App Using AWS CI CD Pipeline with Auto Scaling and Terraform Automation

</div>


Introduction This project showcases how to deploy a React.js web application from start to finish using AWS services, automation tools, and infrastructure as code (IaC). The main goal is to create a scalable infrastructure using CI/CD pipelines, automated resource scaling, and Terraform for one-click deployment.

## Key Components and Objectives
1. **React.js Web Application Deployment**: Cloning the React.js app from GitHub, building, testing, and deploying it via AWS CI/CD pipeline.
2. **Deployment to EC2 and S3**: Hosting the application on EC2 instances and S3 for static hosting.
3. **CI/CD Pipeline with AWS CodePipeline**: Automating the build, test, and deployment processes.
4. **Auto-Scaling**: Automatically adjusting the number of instances based on traffic.
5. **One-Click Deployment Using Terraform**: Automating the AWS resource setup with Terraform.

## Project Goals
- **Deployment**: Deploy the React app with manual steps.
- **Auto-Scaling**: Adjust system resources automatically based on traffic.
- **Security**: Follow AWS security practices.
- **Automation**: Use Terraform for reliable and repeatable AWS setup.

### Step 1: Cloning the React App
To start, clone the React.js application’s source code from GitHub:
```
  git clone https://github.com/react-navigation/create-react-app-example
```
![Picture](https://github.com/user-attachments/assets/ae3f2d51-fdf6-47fc-a934-93ed758df6bd)

### Step 2: Setting Up AWS EC2 Instance
Configure an EC2 instance for hosting the web application. Prior to that these are the following steps to create and configure VPC, subnets, route tables, and security groups.

## When to Use EC2

EC2 (Elastic Compute Cloud) is good for hosting dynamic content and applications that need backend processing:

- **Customizable Server**: Full control over the operating system and software.
- **Scalability**: Ability to change capacity based on traffic.
- **Security**: Options to control traffic with security settings.

### Before Using EC2

Before creating an EC2 instance, several configurations need to be set up to ensure a secure and functioning environment.

## Steps:

### 1) Setup a VPC (Virtual Private Cloud)

**Purpose**: A VPC isolates our resources in a private network, giving us control over IP address ranges, subnet configuration, routing, and internet access.

- **How to Set Up**:
  - Go to the AWS Console > VPC Dashboard > Create VPC.
  - Configure with a CIDR block, e.g., `10.0.0.0/16`.
  - Click on AWS (top left corner).
  - Enter the VPC dashboard.
  - A list of services will pop up.
  - Select **VPC**.

![Screenshot from 2024-09-28 12-23-34](https://github.com/user-attachments/assets/2181521b-84dc-418a-b61b-6592ab8d24ac)

#### Click on VPCs

![Screenshot from 2024-09-28 12-26-24](https://github.com/user-attachments/assets/3834b667-a073-4aa7-8743-f622e1fe7454)

## Creating a VPC:

- Click on **Create VPC** and configure the settings as follows:

  - **Name Tag**: Assign a recognizable name, e.g., `MyProjectVPC`.
  
  - **IPv4 CIDR Block**: Set the range, such as `10.0.0.0/14`. This range provides 65,536 IP addresses, adequate for dividing into multiple subnets.
  
  - **IPv6 CIDR Block**: Optional, only if you need IPv6 support. For most web applications, IPv4 is sufficient.
  
  - **Tenancy**: Choose **Default** unless you have specific reasons to opt for dedicated tenancy, which isolates hardware but incurs a higher cost.

#### Click on create VPC:

<div align="center">

![Screenshot from 2024-09-28 12-32-21](https://github.com/user-attachments/assets/64a45b15-58dd-4860-8f29-5f8e7ed4ef5e)

</div>

### 3. Create Subnets:

- After creating the VPC, we need to divide it into smaller networks (subnets).

#### How to Add Subnets:

- Click on **Subnets** on the left-hand menu, then select **Create Subnet**.

![Screenshot from 2024-09-28 12-36-09](https://github.com/user-attachments/assets/acb21a95-5b89-4a90-943b-feffedb5bf52)

#### Configure Subnet Details:

- **Name Tag**: Provide a clear name such as `PublicSubnet`, `AppSubnet`, or `DBSubnet` to indicate their roles.
- **Availability Zone**: Optionally select an availability zone to distribute resources for high availability.
- **IPv4 CIDR Block**: Define the IP range for each subnet, ensuring they are within our VPC's range and do not overlap.

Configuration for **PublicSubnet**.

![Screenshot from 2024-09-28 12-45-34](https://github.com/user-attachments/assets/1972ae23-1db0-48d5-a563-8ef6eda420d1)

We can clearly see the Subnet’s are successfully created

![Picture](https://github.com/user-attachments/assets/9f0c17a8-c197-4015-a0b4-8a54669d8532)

### 4) Configure Route Tables:

- **Purpose**: Route tables determine how network traffic is directed within the VPC.

#### Steps:

1. Go to **Route Tables** in the VPC Dashboard.
2. Create a route table for your VPC, and name it appropriately (e.g., `PublicRouteTable`).
3. **Associate Subnets**:
   - Attach the `PublicRouteTable` to your Public Subnet.
   
Click on **Create route table**.

![Screenshot from 2024-09-28 13-05-43](https://github.com/user-attachments/assets/bf51839f-f02d-437b-8a49-a65b4c6a118b)

![Screenshot from 2024-09-28 13-06-35](https://github.com/user-attachments/assets/09cb7e18-48c8-44e3-92b6-7e7800abd863)

As, we can see, the route table, was successfully created!

![Picture](https://github.com/user-attachments/assets/d590f411-c067-44b4-b5e9-da92ced19f6e)

### 5) Set Up Internet Gateway:

- **Purpose**: Allows resources in the VPC to access the internet.

#### Steps to Configure Internet Access:

1. Create an **Internet Gateway** and attach it to your VPC.
2. Modify the route table of the public subnet to route internet-bound traffic through the Internet Gateway.
3. Click on **Create Internet Gateway** in the top-right corner.
.

![Picture](https://github.com/user-attachments/assets/a4f479a0-6005-413c-acbe-7aa71cd6e77f)

The Internet gateway was made successfully. But it is in a "detached" state because we didn’t connect it to a VPC. To change it to "attached," click on “Attach to a VPC” in the top right corner.

![Picture](https://github.com/user-attachments/assets/b199a0bf-bbc2-407f-8a14-06a90dd89347)

Attach to the VPC, which we created earlier

![Picture](https://github.com/user-attachments/assets/cfb0fe82-9679-4a14-9570-1f46d85f0723)

We can see now, the state of the IGW is in Attached state, this means we successfully attached the IGW to the VPC of our current project

![Picture](https://github.com/user-attachments/assets/ef0a913d-6b0c-404a-8c2a-cf9102d0798d)

### 6) Configure Security Groups:

- **Purpose**: Security groups act as virtual firewalls, controlling incoming and outgoing traffic.

![Picture](https://github.com/user-attachments/assets/d0c66d4e-eb42-4f9c-9ec4-277e014fb3bc)

We can see, web-server LB has been created

![Picture](https://github.com/user-attachments/assets/546d9d6d-c4ac-41f0-b4d2-5b4079409635)

### Creating EC2 Instances

We need to launch EC2 instances for our web, app, and database tiers. This step occurs after setting up the network components.

- Go to the search bar, type **EC2**, and tap on **EC2 Dashboard**.

![Picture](https://github.com/user-attachments/assets/0f63c835-1b42-4566-8fe9-de5bfeaa0c5b)

#### Click on Launch Instance

For launching the EC2 instance in the web subnet (e.g., `10.0.1.0/24`) to host our React.js application:

- **Configuration**: Choose an appropriate Amazon Machine Image (AMI), such as Amazon Linux, and select an instance type (e.g., `t2.micro` for development).
- **Security Group**: Attach the security group that allows HTTP (port 80) and HTTPS (port 443) traffic.

> **Note**: I’m using AMI because we’re implementing CI/CD with AWS CodePipeline. It’s cost-effective and performs well, so I chose AMI.

![Picture](https://github.com/user-attachments/assets/df54ea91-7682-49fa-95bd-0aaa31027757)

### Cross Check the Configuration

#### View Running Instances

- Click on **Instances** in the left-hand menu to view all your running EC2 instances.
- Check the **Instance State**. Ensure it says "running." If it's in a different state (e.g., "stopped"), you’ll need to start the instance.

### EC2 Instance Connect (Browser-Based SSH)

This method allows you to connect to your instance directly from the browser without needing an SSH client or key pair. However, this works only for instances that support EC2 Instance Connect (e.g., Amazon Linux 2, Ubuntu 20.04).

#### Step-by-Step Process:

1. **Navigate to EC2 Dashboard**:
   - Go to the AWS Management Console.
   - Select EC2 from the services list or search for it in the search bar.

2. **Select the Instance**:
   - In the **Instances** section, find the instance you want to connect to.
   - Ensure the instance state is **running**.

3. **Click the Connect Button**:
   - Select the instance and click the **Connect** button at the top of the page.

4. **Choose the EC2 Instance Connect Method**:
   - By default, the **EC2 Instance Connect** tab will be selected.

5. **Enter User Details (if needed)**:
   - In most cases, for Amazon Linux or Ubuntu, the default user is already set to `ec2-user` or `ubuntu`.

![Picture](https://github.com/user-attachments/assets/e98a6994-0dfa-421c-ae3f-ede9d551c82c)

Click on Connect

![Picture](https://github.com/user-attachments/assets/a0c9ad1c-3948-402a-b9af-88557b555576)

Here we can see, we successfully logged in to the machine:

Next we can, clone the github repo, here

![Picture](https://github.com/user-attachments/assets/414caffa-ade9-48c6-94eb-727f5cf02cb8)

### After Cloning a React App on Amazon Linux 2

#### Update and Install Node.js and npm

Amazon Linux 2 doesn’t come with Node.js installed by default, so we need to install it first to run a React app.

#### Step 1: Update the Package Manager
```
  sudo yum update -y
```
### Version Manager - NVM

Amazon Linux 2 doesn’t have the latest Node.js version in its default repositories. The best practice is to use NVM (Node Version Manager) to install the version of Node.js that your React app requires.

#### Install NVM (Node Version Manager):
```
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash
```
#### Activate NVM:

You can close and reopen your terminal, or use the command below:
```
  source ~/.bashrc
```
#### Install Node.js (latest stable version):
```
  nvm install --lts
```
#### Verify Node.js and npm installation:
```
  node -v
```
This layout maintains clarity with headings and code blocks, making it easy for users to follow. You can paste this directly into your README file. If you have more content to add or need any modifications, just let me know!

![Picture](https://github.com/user-attachments/assets/c262f1b6-7022-4510-a1ed-8a3840a49d58)

### 2. Navigate to the Project Directory

Once you have cloned the project, change to the project’s directory. For example, assuming the project was cloned to `~/create-react-app-example`, use the following command:
```
  cd ~/create-react-app-example
```
#### Install Dependencies

Now that you are in the project directory and have Node.js installed, install the project’s dependencies using npm. This will read the package.json file in your React project and install all the necessary dependencies listed under dependencies.
```
  npm install
```
![Picture](https://github.com/user-attachments/assets/14bb1a67-cec9-4b8a-ab18-ab2c0b36c6ea)

### Build the React Application

If you’re planning to deploy your React application, you will need to build it first. This process compiles the app into static files that can be served.

To build the application, use the following command:
```
  npm run build
```
![Picture](https://github.com/user-attachments/assets/b86ff50d-0386-45cc-a2e2-7ef5116daf60)

#### Run the React App Locally

If we  want to test the app locally (for development or debugging), we can use the following command

![Picture](https://github.com/user-attachments/assets/8f51cc9a-a4ff-4025-93a7-2a6e006b7c07)

Now we can go with the Public address, of the EC2 instance

![Picture](https://github.com/user-attachments/assets/f358e8b6-9e00-4317-87bc-76ecca929025)

We’re going to append the port :3000 to the public IPLike this ( http://13.201.67.239:3000 )

![Picture](https://github.com/user-attachments/assets/ae4dab26-5e93-46b2-bec0-4cf4a16b7ebf)

The site is now fetching from the machine and is publicly accessible.

## CI/CD Pipeline with AWS CodePipeline

### To Set Up AWS CodePipeline:

**Log in to the AWS Console**:
   - Open your browser and navigate to the [AWS Console](https://aws.amazon.com/console/).
   
**Search for CodePipeline**:
   - In the AWS Console, locate the search bar at the top.
   - Type `CodePipeline` in the search bar and select it from the list.

**Create Pipeline**:
   - Once inside the CodePipeline service, click on the **Create Pipeline** button to begin setting up your continuous integration and continuous delivery (CI/CD) pipeline.

![Picture](https://github.com/user-attachments/assets/219b4e6a-950c-41ba-a3df-47b1e372f09a)

![Picture](https://github.com/user-attachments/assets/1710d0c4-799e-470b-9729-5534093b8e19)

**Configure the Pipeline Settings**:
   - **Pipeline Name**: Enter a unique name for the pipeline.
   - **Service Role**: Select the default AWS-managed service role unless you want to specify a custom role.
   - Click **Next** to proceed to the next step of the pipeline setup.

![Picture](https://github.com/user-attachments/assets/c661b7d4-7c81-4ff0-a16f-a62f7d9b6fd1)

### Source Stage - Set Up the Source (GitHub):

**Source Provider**:
   - Select `GitHub`.

**Repository**:
- Sign in to GitHub if not already authenticated.
- Choose the GitHub repository where the React app is hosted.

**Branch**:
- Select the branch (usually `Main`) from which the code should be pulled.

Click **Next** to proceed.

![Picture](https://github.com/user-attachments/assets/59282025-981b-414d-927a-f711e8b09858)

## Build Stage - Configure the Build Stage (CodeBuild):

- **Build Provider**: Select `AWS CodeBuild`.

- **Create a New Build Project** (if you don’t have one):
  - **Project Name**: Enter a name for the build project.
  
  - **Environment**:
    - **Managed Image**: Choose the environment image, for example, select "Ubuntu" as the operating system and "Node.js" as the runtime.
  
  - **Build Specification**: Use the built-in editor to define the build steps for the React app.

![Picture](https://github.com/user-attachments/assets/4ad628da-fe56-4e35-abe9-1bfdc048d529)

![Picture](https://github.com/user-attachments/assets/db2f5dc7-ca70-425a-8deb-6d351fd872f8)

![Picture](https://github.com/user-attachments/assets/92bef1ff-d554-4402-b5c5-2893268512ee)

![Picture](https://github.com/user-attachments/assets/7c90c8ef-eb7c-4e26-97ff-dfa26c591662)

After we click on next step, site will ask to leave, means the information, is saved, and its going to prior site, which we can see continuation of the steps

![Picture](https://github.com/user-attachments/assets/2abebca0-3939-4fec-bae5-492e9053d649)

**Service Role**: We can use the default service role or create a new one with the necessary permissions (like access to GitHub, S3, or EC2).

Click on S3 >

![Picture](https://github.com/user-attachments/assets/008602e8-3e76-489a-92f3-a30a9ec952fc)

Later it shows error in the bucket, this pop-up because we did’nt created any S3 bucket yet

![Picture](https://github.com/user-attachments/assets/41869e4d-abf8-48c5-9ed5-6b995cdfcc48)

To troubleshoot this issue, now we need to go to Amazon service console: and type S3

![Picture](https://github.com/user-attachments/assets/6f037358-2486-4d82-bae0-99c8c24dff14)

And select the option, and later click on Create Bucket

![Picture](https://github.com/user-attachments/assets/91daed90-bb73-45f4-92b5-404d9fa108bf)

## Configure Bucket Settings:

- **Bucket Name**: Enter a globally unique name for the bucket (e.g., `my-react-app-bucket`). Bucket names must be unique across all of AWS and can only contain lowercase letters, numbers, hyphens, and periods.
  
- **Region**: Select the AWS Region where you want the bucket to be created (e.g., Asia Pacific (Mumbai) `ap-south-1`).

![Picture](https://github.com/user-attachments/assets/0106ddb9-9586-47b5-b3d2-ab142d534424)

## Set Permissions:

- **Block Public Access Settings**: By default, S3 blocks all public access. If you intend to host a public static website, you will need to uncheck the box for "Block all public access" after creating the bucket. You can also set permissions later.

![Picture](https://github.com/user-attachments/assets/011451fc-173f-482e-8da1-5da55526349c)

Review and Create:
– Review the settings and click on the Create bucket button.

![Picture](https://github.com/user-attachments/assets/90818355-30f1-454b-ab83-6c222a21fdf5)

## Set Bucket Policy for Public Access:

- After creating the bucket, you need to adjust the bucket policy to allow public access. To do this:
  - Select the newly created bucket.
  - Go to the **Permissions** tab.
  - Click on **Bucket Policy** and add a policy that looks something like this (replace `my-react-app-3` with your bucket name):

![Picture](https://github.com/user-attachments/assets/11e5dea2-26d7-4944-b178-0747a700f4d4)

~~~json
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::my-react-app-bucket/*"
        }
    ]
}
~~~

## Configure Static Website Hosting:

- Since you’re hosting a static site:
  - Go to the **Properties** tab of your bucket.
  - Scroll down to the **Static website hosting** section.
  - Click on **Edit**, select **Use this bucket to host a website**, and specify `index.html` as the Index document.

![Picture](https://github.com/user-attachments/assets/cf1c7b01-530e-4281-8ad9-c220617f582f)

![Picture](https://github.com/user-attachments/assets/31dd9921-a6ae-4b46-a77b-fe718030f800)

We’re going to Objects > Upload Files:
· we can now upload files to our bucket or configure our CodePipeline to deploy to this bucket.

![Picture](https://github.com/user-attachments/assets/742fbb32-303f-4a78-aaf5-04f2ac81811f)

Click on Upload

![Picture](https://github.com/user-attachments/assets/752a00cb-5101-4bfb-9cb7-f5b97cc633db)

Now we can see. It shows the bucket we created!

![Picture](https://github.com/user-attachments/assets/067a3235-a5c1-4076-879b-193bf031ab8b)

Click on next, and click on Create pipeline!

![Picture](https://github.com/user-attachments/assets/a1b50c0c-84ed-4bf9-b8c3-19b29243174a)

We successfully automated the entire process of building, testing, and deploying the application.

![Picture](https://github.com/user-attachments/assets/3d815c78-f74d-43e4-931f-74a023978627)

--------------------------------------------------------------------------------------------------

## Auto-Scaling:

To automatically increase the number of EC2 instances during high traffic, you can set up Auto Scaling in AWS. Here’s a quick guide:

- **Create Launch Configuration**: Define how new instances should be configured (AMI, instance type, etc.).

- **Set Up Auto Scaling Group**:
  - Go to **EC2 Dashboard** → **Auto Scaling Groups** → **Create Auto Scaling Group**.
  - Select your launch configuration.
  - Specify the minimum and maximum number of instances (e.g., min=1, max=5).

- **Configure Scaling Policies**:
  - Create policies to scale out (add instances) when CPU usage exceeds a certain threshold (like 70%).
  - Set policies to scale in (remove instances) when usage drops below a lower threshold (like 30%).

- **Attach to Load Balancer (if needed)**: If you’re using a load balancer, attach it to your Auto Scaling group to distribute traffic evenly.

--------------------------------------------------------------------------------------------------

## One-Click Deployment Using Terraform:

- Designed a Terraform runbook that simplifies the setup of AWS resources. This one-click deployment script eliminates the need for manual setup, maintains consistency, and allows for quick changes or copies of the setup when needed. 

- With Terraform’s infrastructure as code approach, you can reduce mistakes and make deployment simple.

## Terraform Configuration for AWS Resources:

```hcl
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
```

## ❤ Show your support

Give a ⭐️ if this project helped you, Happy learning!

