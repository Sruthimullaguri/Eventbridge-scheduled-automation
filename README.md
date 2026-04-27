# EventBridge Scheduled Automation using Terraform and AWS Lambda

## Project Overview

In this project, I built a small automation setup in AWS using Terraform, EventBridge, Lambda, SNS, and EC2. The goal was to reduce manual work by scheduling common infrastructure tasks like starting and stopping development instances, cleaning old snapshots, and checking security risks automatically.

Instead of doing these checks manually every day, I created scheduled jobs that run in the background and send notifications when something needs attention.

This project helped me understand how real infrastructure automation works in a DevOps environment.


## What this project does

There are three automations in this project.

1. EC2 Scheduler  
Starts EC2 instances tagged as `Environment = Dev` after 9 AM and stops them after 6 PM to save cost.

2. Snapshot Cleanup  
Runs every Sunday at 2 AM and deletes snapshots older than 30 days if they are not tagged.

3. Security Group Check  
Runs every hour and checks if any security group allows SSH access from `0.0.0.0/0`. If found, it sends an alert email.


## Technologies used

Terraform  
AWS Lambda  
Amazon EventBridge  
Amazon SNS  
Amazon EC2  
Amazon CloudWatch  


## How I implemented this project step by step

First, I created Lambda functions for each automation task. Each function performs one job like starting instances, deleting snapshots, or checking security groups.

Then I created EventBridge rules to trigger those Lambda functions automatically based on a schedule.

After that, I created an SNS topic to send notification emails whenever automation runs or detects issues.

I also created an IAM role so Lambda could securely access EC2, snapshots, and security groups.

Finally, I used Terraform to deploy everything together instead of creating resources manually in the AWS console.


## Challenges I faced and how I fixed them

One issue I faced was Lambda deployment failing because the zip files were empty. I fixed this by creating a packaging script to generate Lambda zip files before running Terraform.

Another issue was SNS notifications not arriving for the security group alert. This happened because the message size was too large when many security groups were detected. I fixed it by sending only a summary count instead of the full list and keeping detailed logs in CloudWatch.

I also faced a provider version mismatch error in Terraform initialization. I solved it by running `terraform init -upgrade`.

While testing scheduler automation, sometimes instances were not detected. I realized the tag value must match exactly as `Environment = Dev`, including case sensitivity.

These troubleshooting steps helped me better understand real deployment behavior.


## Improvements I added during implementation

While working on this project, I added some improvements to make the automation safer and more realistic.

I added pagination support in Lambda scripts so they work correctly even if there are many snapshots or security groups.

I added DRY_RUN mode support to test automation safely without making changes.

I added structured logging so CloudWatch logs are easier to read.

I also avoided deleting tagged snapshots to protect important backups.


## What I learned from this project

I learned how to schedule infrastructure tasks using EventBridge.

I understood how Lambda can automate operations without running servers.

I learned how tagging helps control automation behavior.

I practiced writing Terraform scripts to deploy AWS infrastructure.

I also learned how to debug deployment issues like permission errors, packaging problems, and notification failures.

Most importantly, I understood how automation can reduce manual cloud operations work.


## Future improvements I am planning

In future, I would like to improve this project by adding Slack alerts instead of only email notifications.

I also plan to add Terraform modules to organize the infrastructure better.

Another improvement would be adding automatic tagging enforcement policies.


## How to deploy this project

Clone this repository

Run the Lambda packaging script
