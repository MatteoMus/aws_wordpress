# aws_wordpress
AWS scalable wordpress solution

##1 - INTRODUCTION

In this repository you will find a cloudformation project that deploys an infrastructure based on AWS Beanstalk letting you run a wordpress application.

Within the cftemplate you'll find the cloudformation files, in the root path you have a source bundle ready to deploy and a wordpress folder with 3 injections:

    1- custom wp-config.php
    2- .platform folder
    3- .ebextensions folder

See section HOW TO DEPLOY APP for more details.

##2 - ARCHITECTURE*

The application is deployed on a 3 Tiers and 2 AZs infrastructure. The DB, EC2 (with the webserver) and EFS belong on private subnets. In the public subnets reside the ALB and NAT GATEAYs. An external S3 bucket is used by Beanstalk to retrieve app informations for the deploy. Secret manager is used to store the DB password If you have a domain in Route53 with a hosted zone, you could put in front of your ALB the DNS resolver. The DB is external to Beanstlk container, this way you can choose Aurora as engine and you can destroy and rebuilt the Beanstalk container without lose your data.

##3 - FEATURES

##3.1 - SECURE

Both DB and instances are deployed into private subnets. The DB password is automatically generated with cloufromation nad saved in a Secret Manager retrieved by the instances at boot. The communication between internet and ALB is based on HTTPS protocol. The communication betwe

##3.2 - FAST

The ALB let the application scales horizontally and you can choose the EC2s' size that better fit your needs. The DB is a mysql Amazon Aurora Serverless for better performance than a classic mysql.

##3.3 - FAULT TOLERANT

The use of an ALB with an Autoscaling Group covering 2 AZs ensure fault tollerance. The EC2 share a EFS to store the uploaded files through the web application interface.

3.4 - ADAPTIVE TO AVERAGE LOAD

You can define the min and max of the Autoscaling Group. 2 Cloudwatch base on alarms are implemented by Beanstalk