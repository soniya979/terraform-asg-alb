#create s3 bucket for backend

resource "aws_s3_bucket" "assgn-backend-bkt" {

    bucket = "assgn-backend-bkt"

  }


resource "aws_s3_bucket_acl" "assgn-backend-acl" {

    bucket = aws_s3_bucket.assgn-backend-bkt.id

    acl    = "private"
}

resource "aws_s3_bucket_versioning" "assgn-backend-versioning" {

  bucket = aws_s3_bucket.assgn-backend-bkt.id

  versioning_configuration {

    status = "Enabled"
  }

}


resource "aws_s3_bucket_server_side_encryption_configuration" "assgn-backend-encyption" {

  bucket = aws_s3_bucket.assgn-backend-bkt.bucket

  rule {

    apply_server_side_encryption_by_default {

      sse_algorithm     = "AES256"
    }
  }
}


#create dynamodb for statelock

resource "aws_dynamodb_table" "assgn-backend-db-table" {

    name           = "assgn-backend-db-table"
    hash_key       = "LockID"
    billing_mode   = "PROVISIONED"
    read_capacity  = 10
    write_capacity = 10

attribute {

    name = "LockID"
    type = "S"

  }

tags = {

    Name = "Terraform State Lock DBTable"

    }
}

#configure terraform backend

terraform {

  backend "s3" {

    bucket = "projecta-s3-demo-bucket-01"
    key    = "terraform.tfstate"
    region = "ap-south-1"
    dynamodb_table = "s3-backend-db-table-01"

  }
}