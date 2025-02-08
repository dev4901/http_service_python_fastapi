from fastapi import FastAPI, HTTPException
import boto3
import boto3.session
import json

# access_key = 
# secret = 
region = "us-east-2"
bucket_name = "devansh-test1-bucket"

# client = boto3.client('s3')
session = boto3.session.Session(
    # aws_access_key_id = access_key,
    # aws_secret_access_key = secret,
    region_name = region
)

s3_client = session.client('s3')

app = FastAPI()

@app.get("/list-bucket-content/{path:path}")
async def get_directory_details(path: str = ""):
    try:
        if path:
            if path[-1] != "/": path= f"{path}/" 
        response = s3_client.list_objects_v2(Bucket=bucket_name, Delimiter='/', Prefix=path)
        if "Contents" not in response: raise Exception("Please enter a valid path")
        if 'CommonPrefixes' in response: 
            dir = [name['Prefix'] for name in response['CommonPrefixes']]
        else:
            dir = []
        if 'Contents' in response: 
            files = [obj['Key'] for obj in response['Contents']]
        else:
            files = []
            
        path = f"devansh-test1-bucket/{path}"
        data = {}
        data["Path"] = path
        data["Content"] = {}
        # if dir: print(f"directories are {dir}")
        # if files: print(f"files are {files[1:]}")
        if dir: data["Content"]["Subdirectories"] = dir
        if files: 
            # files = files[1:]
            data["Content"]["Files"] = files
        #return f"{path}"
        #return f"{data}"
        #json_out = json.dumps(data, indent=2)
        return json.loads(json.dumps(data, indent=2))
        # return {"path": path, "sub-directories": dir, "files": files}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
