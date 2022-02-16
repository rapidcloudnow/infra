import boto3
import os
import argparse

parser = argparse.ArgumentParser(description='Upload files to S3')
parser.add_argument('--bucket-name', dest='bucket_name', help='name of the s3 bucket to upload files')
parser.add_argument('--source-folder', dest='folder', help='source folder or directory of files')

args = parser.parse_args()
region = os.getenv("AWS_REGION")

bucket_name = args.bucket_name
folder = args.folder

session = boto3.Session(region_name=region)
s3 = session.resource('s3')


def upload_files(s3_bucket_name, directory):
    bucket = s3.Bucket(s3_bucket_name)
    for subdir, dirs, files in os.walk(directory):
        for file in files:
            full_path = os.path.join(subdir, file)
            with open(full_path, 'rb') as data:
                bucket.put_object(Key=full_path[len(directory) + 1:], Body=data)


if __name__ == "__main__":
    upload_files(bucket_name, folder)
