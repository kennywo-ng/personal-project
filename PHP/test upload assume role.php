<?php

require 'vendor/autoload.php';

use Aws\Credentials\Credentials;
use Aws\Sts\StsClient;
use Aws\S3\S3Client;

// Set your AWS credentials
$accessKey = 'access';
$secretKey = 'secret';

// Set the role ARN you want to assume
$roleArn = 'arn:aws:iam::12345:role/ROLE';

// Set the session name (optional)
$sessionName = 'AssumedRoleSession';

// Create AWS credentials
$credentials = new Credentials($accessKey, $secretKey);

// Create the STS client
$stsClient = new StsClient([
    'version' => 'latest',
    'region' => 'ap-southeast-1', // Set your region
    'credentials' => $credentials,
]);

// Assume the role
$assumedRole = $stsClient->assumeRole([
    'RoleArn' => $roleArn,
    'RoleSessionName' => $sessionName,
]);

// Get the temporary credentials from the assumed role
$assumedRoleCredentials = $assumedRole['Credentials'];

// Create S3 client with assumed role credentials
$s3Client = new S3Client([
    'version' => 'latest',
    'region' => 'ap-southeast-1', // Set your region
    'credentials' => [
        'key' => $assumedRoleCredentials['AccessKeyId'],
        'secret' => $assumedRoleCredentials['SecretAccessKey'],
        'token' => $assumedRoleCredentials['SessionToken'],
    ],
]);

// Set the bucket and object key
$bucket = 'bucket-name';
$objectKey = 'test.txt';

// Specify the local file path that you want to upload
$localFilePath = '/Users/kennywong/Downloads/test.txt';

// Upload the file to S3
$result = $s3Client->putObject([
    'Bucket' => $bucket,
    'Key' => $objectKey,
    'Body' => fopen($localFilePath, 'r'),
]);

// Check if the upload was successful
if ($result) {
    echo 'File uploaded successfully!';
} else {
    echo 'Failed to upload file.';
}

?>
