#!/bin/bash
# Update system
sudo yum update -y
sudo yum install -y python3 git

# Install FastAPI dependencies
pip3 install fastapi uvicorn boto3

# Clone your FastAPI GitHub repository
cd /home/ec2-user
git clone https://github.com/dev4901/http_service_python_fastapi.git fastapi-app
cd fastapi-app

# Run FastAPI server
nohup uvicorn fastapi-main:app --host 0.0.0.0 --port 8000 &> fastapi.log &
