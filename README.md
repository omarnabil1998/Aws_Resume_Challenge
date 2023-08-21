# AWS_Cloud_Resume_Challenge

## Project Diagram
![My Image](Images/Cloud Architecture.png)

## Project Description
The Cloud Resume Challenge is a project that helps to demonstrate skills necessary for working in the cloud as the project involves integrating several cloud services together like S3, Cloudfront, Lambda, Dynamodb, Route53 alongside with other Devops skills like CI/CD and infrastructure as a code

Resume website: [omarnabeel.com](https://omarnabeel.com)

## Details
### S3
- This project requires S3 bucket to store your resume files like html, css, javascript 
- This bucket is private and can only be accessed through cloudfront

### Cloudfront
- It is a CDN service Used to cache the S3 bucket contents and to provide a secure way for accessing the bucket publicly without needing to expose the bucket directly to the internet
- Cloudfront allows us to serve our content fast to viewers around the world

### Dynamodb
- We want to include a visitors count in our website so we need a database to store it
- For that we created a Dynamodb table with a single item in it to store the visitors number

### Lambda
- Lambda function is used to retrieve the visitors count from the dynamodb table and increment it by one every time someone visits our website
- The lambda function gets invoked by the javascript code then javascript will update the HTML with the new number

### Route53
- It is used to Point a custom DNS domain name to the CloudFront distribution 
