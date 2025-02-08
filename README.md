### **📜 README.md**

# FastAPI Service with Terraform Deployment

This repository contains a **FastAPI service** that can be deployed on **AWS EC2 using Terraform**.  

## 📌 Features
- 🚀 FastAPI for high-performance REST API  
- 🌍 Exposes an endpoint to interact with AWS S3  
- ☁️ Infrastructure as Code (IaC) using Terraform  
- 🔗 Automatically pulls Python code from GitHub on EC2  

---

## 🛠️ Setup FastAPI Locally

### 1️⃣ **Clone the repository**
```sh
git clone https://github.com/dev4901/http_service_python_fastapi.git http_service
cd http_service/fastapi-app
```

### 2️⃣ **Create a virtual environment (optional but recommended)**
```sh
python3 -m venv fastapi-venv
source fastapi-venv/bin/activate
```

### 3️⃣ **Install dependencies**
```sh
pip install -r requirements.txt
```

### 4️⃣ ***Update vars in the python file***
- ACCESS_KEY and SECRET_KEY - keys to access AWS user or use "aws configure" in your environment.
- REGION -  Update the AWS region in which your bucket exists.
- BUCKET_NAME - update the bucket name whose directory structure you need.

### 5️⃣ **Run the FastAPI server**
```sh
uvicorn fastapi-main:app --host 0.0.0.0 --port 8000 --reload
```

### 6️⃣ **Access API**
Open a browser or use `curl`:
```
http://127.0.0.1:8000/docs - This opens the Swagger UI for testing API endpoints.

http://127.0.0.1:8000/list-bucket-content/ - This gives the main file structure of the bucket

http://127.0.0.1:8000/list-bucket-content/<folder-name> - will list the objects of that folder.
```

---

## ☁️ Deploy to AWS using Terraform

### 1️⃣ **Prerequisites**
- **Terraform installed** (`terraform -v`)
- **AWS CLI configured** (`aws configure`)
- **A key pair** for SSH access (`.pem` file in AWS EC2)

### 2️⃣ **Initialize Terraform**
```sh
terraform init
```

### 3️⃣ **Verify and Apply Terraform Configuration**
```sh
terraform plan
terraform apply
```

Terraform will: <br>
✅ Create an EC2 instance  
✅ Attach an IAM role with **S3 read-only access**  
✅ Download the FastAPI code from GitHub  
✅ Install dependencies & start the API

### 4️⃣ **Get the Public IP**
Once deployed, Terraform will output the **EC2 Public IP**.  
Run the following to check:
```sh
terraform output public_ip
```
Then, access your FastAPI service at:
```
http://<EC2_PUBLIC_IP>:8000/docs
```

### 5️⃣ **Destroy Infrastructure (if needed)**
```sh
terraform destroy -auto-approve
```

---

## 📖 API Endpoints

| Method | Endpoint | Description |
|--------|---------|------------|
| `GET` | `/` | Health check |
| `GET` | `/list-bucket-content/{path:path}` | List S3 bucket content |

Example:
```sh
curl http://127.0.0.1:8000/list-bucket-content/my-folder/
```

---

## 📜 File Structure

```
/http_service
│── /fastapi-app  # Python FastAPI code
│   ├── fastapi-main.py  # FastAPI application
│   ├── requirements.txt  # Dependencies
│── /terraform  # Terraform infrastructure code
│   ├── main.tf  # AWS resources
│   ├── userdata.sh  # EC2 startup script
│── README.md  # Project documentation
```

---
  
