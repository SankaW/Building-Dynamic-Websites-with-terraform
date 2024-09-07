############################## S3 ######################################

# Use a module to manage template files in the specified directory
module "template_files" {
  source  = "hashicorp/dir/template" 
  base_dir = "${path.module}/site" #your_static_website.com" # your local machine project file
}

# Create an S3 bucket to host the static website
resource "aws_s3_bucket" "hosting_bucket" {
  bucket = var.bucket_name
}

# Configure public access settings for the S3 bucket
resource "aws_s3_bucket_public_access_block" "hosting_bucket_public_access" {
  bucket = aws_s3_bucket.hosting_bucket.id
  
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# Define a bucket policy to allow public read access to all objects in the bucket
resource "aws_s3_bucket_policy" "hosting_bucket_policy" {
  bucket = aws_s3_bucket.hosting_bucket.id

  policy = jsonencode({
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Principal": "*",
                "Action": "s3:GetObject",
                "Resource": "arn:aws:s3:::${var.bucket_name}/*"
            }
        ]
  })
}

# Configure the S3 bucket to host a static website
resource "aws_s3_bucket_website_configuration" "hosting_bucket_website_configuration" {
  bucket = aws_s3_bucket.hosting_bucket.id

  index_document {
    suffix = "index.html"
  }
}

# Upload the files from the local project directory to the S3 bucket
resource "aws_s3_object" "hosting_bucket_files" {
  bucket = aws_s3_bucket.hosting_bucket.id

  for_each = module.template_files.files

  key = each.key
  content_type = each.value.content_type

  source  = each.value.source_path
  content = each.value.content

  etag = each.value.digests.md5

}
 
