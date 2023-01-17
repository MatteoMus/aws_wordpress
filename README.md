# aws_wordpress
AWS scalable wordpress solution

## 1 - Introduction

In this repository you will find a cloudformation project that deploys an infrastructure based on AWS Beanstalk letting you run a wordpress application.

Within the cftemplate you'll find the cloudformation files, in the root path you have a source bundle ready to deploy and a wordpress folder with 3 injections:

    1- custom wp-config.php
    2- .platform folder
    3- .ebextensions folder

See section HOW TO DEPLOY APP for more details.

## 2 - Architecture

The application is deployed on a 3 Tiers and 2 AZs infrastructure. The DB, EC2 (with the webserver) and EFS belong on private subnets. In the public subnets reside the ALB and NAT GATEAYs. An external S3 bucket is used by Beanstalk to retrieve app informations for the deploy. Secret manager is used to store the DB password If you have a domain in Route53 with a hosted zone, you could put in front of your ALB the DNS resolver. The DB is external to Beanstlk container, this way you can choose Aurora as engine and you can destroy and rebuilt the Beanstalk container without lose your data.

## 3 - Features

### 3.1 - Secure

Both DB and instances are deployed into private subnets. The DB password is automatically generated with cloufromation nad saved in a Secret Manager retrieved by the instances at boot. The communication between internet and ALB is based on HTTPS protocol. The communication EC2-EFS and EC2-DB are secured by security groups. EC2s and DB reach internet through the NAT Gateways, so there is now way that a communication with them is started from internet. The SSH port of the instances is closed, only with a System Mnagaer Session we can login into the webservers. Any updates of the EC2s can managed with System Manager.

### 3.2 - Fast

The ALB let the application scales horizontally and you can choose the EC2s' size that better fit your needs. The DB is a mysql Amazon Aurora Serverless for better performance than a classic mysql.

### 3.3 - Fault tolerant

The use of an ALB with an Autoscaling Group covering 2 AZs ensure fault tollerance. The EC2 share a EFS to store the uploaded files through the web application interface. The DB instances are serverless (so managed by AWS) and deployed on different AZs.

### 3.4 - Adaptive to average load

You can define the min and max of the Autoscaling Group. 2 Cloudwatch alarms based on NetworkOut metric are implemented by Beanstalk by default. The Aurora DB is serverless, so able to adapt the size of its instances automatically.
