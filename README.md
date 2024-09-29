# Deploying-a-React.js-Web-App-Using-AWS-CI-CD-Pipeline-with-Auto-Scaling-and-Terraform-Automation
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

  git clone <github-repo-urlhttps://github.com/react-navigation/create-react-app-example>

![Screenshot from 2024-09-28 12-12-43](https://github.com/user-attachments/assets/9cc94226-10b9-4601-92b1-f5aa7b7c6be2)


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

Click on VPCs

![Screenshot from 2024-09-28 12-26-24](https://github.com/user-attachments/assets/3834b667-a073-4aa7-8743-f622e1fe7454)

Click on Create VPC:
Configuration Settings:
·	Name Tag: Assign a recognizable name, e.g., MyProjectVPC.
·	IPv4 CIDR Block: Set the range, such as 10.0.0.0/14. This range gives us 65,536 IP addresses, which is adequate for dividing into multiple subnets.
·	IPv6 CIDR Block: Optional, only if we need IPv6 support. For most web applications, IPv4 is sufficient.
·	Tenancy: Choose Default unless we have specific reasons to opt for dedicated tenancy, which isolates hardware but at a higher cost.

Click on create VPC:

![Screenshot from 2024-09-28 12-32-21](https://github.com/user-attachments/assets/64a45b15-58dd-4860-8f29-5f8e7ed4ef5e)

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

#### Steps:

1. Create an Internet Gateway and attach it to your VPC.
2. Modify the route table of the public subnet to route internet-bound traffic through the Internet Gateway.
3. Click on **Create Internet Gateway** in the top-right corner.

![Picture](https://github.com/user-attachments/assets/a4f479a0-6005-413c-acbe-7aa71cd6e77f)

The Internet gateway was made successfully. But it is in a "detached" state because we didn’t connect it to a VPC. To change it to "attached," click on “Attach to a VPC” in the top right corner.

![Picture](https://github.com/user-attachments/assets/b199a0bf-bbc2-407f-8a14-06a90dd89347)

Attach to the VPC, which we created earlier

![Picture](https://github.com/user-attachments/assets/cfb0fe82-9679-4a14-9570-1f46d85f0723)

We can see now, the state of the IGW is in Attached state, this means we successfully attached the IGW to the VPC of our current project

![Picture](https://github.com/user-attachments/assets/ef0a913d-6b0c-404a-8c2a-cf9102d0798d)

6) Configure Security Groups:
·	Purpose: Security groups act as virtual firewalls, controlling incoming and outgoing traffic.

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

  sudo yum update -y

### Version Manager - NVM

Amazon Linux 2 doesn’t have the latest Node.js version in its default repositories. The best practice is to use NVM (Node Version Manager) to install the version of Node.js that your React app requires.

#### Install NVM (Node Version Manager):

  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

#### Activate NVM:

You can close and reopen your terminal, or use the command below:

  source ~/.bashrc

#### Install Node.js (latest stable version):

  nvm install --lts

#### Verify Node.js and npm installation:

  node -v

This layout maintains clarity with headings and code blocks, making it easy for users to follow. You can paste this directly into your README file. If you have more content to add or need any modifications, just let me know!

![Picture](https://github.com/user-attachments/assets/c262f1b6-7022-4510-a1ed-8a3840a49d58)

### 2. Navigate to the Project Directory

Once you have cloned the project, change to the project’s directory. For example, assuming the project was cloned to `~/create-react-app-example`, use the following command:

  cd ~/create-react-app-example

#### Install Dependencies

Now that you are in the project directory and have Node.js installed, install the project’s dependencies using npm. This will read the package.json file in your React project and install all the necessary dependencies listed under dependencies.

  npm install

![Picture](https://github.com/user-attachments/assets/14bb1a67-cec9-4b8a-ab18-ab2c0b36c6ea)

### Build the React Application

If you’re planning to deploy your React application, you will need to build it first. This process compiles the app into static files that can be served.

To build the application, use the following command:

  npm run build

![Picture](https://github.com/user-attachments/assets/b86ff50d-0386-45cc-a2e2-7ef5116daf60)

#### Run the React App Locally

If we  want to test the app locally (for development or debugging), we can use the following command

![Picture](https://github.com/user-attachments/assets/8f51cc9a-a4ff-4025-93a7-2a6e006b7c07)

Now we can go with the Public address, of the EC2 instance

![Picture](https://github.com/user-attachments/assets/f358e8b6-9e00-4317-87bc-76ecca929025)

We’re going to append the port :3000 to the public IPLike this ( http://13.201.67.239:3000 )
