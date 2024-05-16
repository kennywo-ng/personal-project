<?php

require 'vendor/autoload.php';

use Aws\Credentials\Credentials;
use Aws\Sts\StsClient;
use Aws\S3\S3Client;

// Set your AWS credentials
$accessKey = 'access';
$secretKey = 'secret';

// Set the role ARN you want to assume
$roleArn = 'arn:aws:iam::123456788:role/ROLE';

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
$objectKey = 'App/test.png';

// Specify the local file path where you want to save the downloaded file
$localFilePath = '/Users/kennywong/Downloads/test.png';

// Download the file from S3
$result = $s3Client->getObject([
    'Bucket' => $bucket,
    'Key' => $objectKey,
    'SaveAs' => $localFilePath,
]);

// Check if the download was successful
if ($result) {
    echo 'File downloaded successfully!';
} else {
    echo 'Failed to download file.';
}

?>
