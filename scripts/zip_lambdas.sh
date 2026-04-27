#!/bin/bash

set -e

echo "Starting Lambda packaging process..."


echo "Packaging EC2 scheduler Lambda"
cd ../lambdas/ec2_scheduler
zip -r ec2_scheduler.zip lambda_function.py > /dev/null


echo "Packaging snapshot cleanup Lambda"
cd ../snapshot_cleanup
zip -r snapshot_cleanup.zip lambda_function.py > /dev/null


echo "Packaging security group audit Lambda"
cd ../security_group_check
zip -r security_group_check.zip lambda_function.py > /dev/null


echo "Lambda packaging completed successfully"