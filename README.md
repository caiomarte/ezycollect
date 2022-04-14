# Task 1
Check the `ezycollect` folder.

---
# Task 2

## SQS
Using [available CloudWatch metrics for Amazon SQS](https://docs.aws.amazon.com/AWSSimpleQueueService/latest/SQSDeveloperGuide/sqs-available-cloudwatch-metrics.html), I'd monitor the `NumberOfMessagesSent`, `ApproximateAgeOfOldestMessage`, `ApproximateNumberOfMessagesVisible`, `ApproximateNumberOfMessagesNotVisible`, `SentMessageSize`, and `NumberOfEmptyReceives` metrics.

The average `NumberOfMessagesSent`, `ApproximateAgeOfOldestMessage`, `ApproximateNumberOfMessagesVisible`, and `ApproximateNumberOfMessagesNotVisible` can help us define how many consumers should be added or can be removed without impacting performance, and the amount of time for which messages should be delayed, retained, or visible in the queue. The maximum `SentMessageSize` can help us define the size limit for messages to be accepted by the queue without impacting availability. And the average `NumberOfEmptyReceives` can help us define the amount of time for which the queue should wait before returning `ReceiveMessage` calls.


## S3
Using [available CloudWatch metrics for Amazon S3](https://docs.aws.amazon.com/AmazonS3/latest/userguide/metrics-dimensions.html), I'd monitor the `GetRequests`, `PutRequests`, and `TotalRequestLatency` metrics.

`GetRequests` can help us understand access frequency for objects in the bucket, and define the appropriate storage class and lifecycle policy without impacting availability. Together with `TotalRequestLatency`, it can also help us define whether to use a CloudFront distribution to serve objects in the bucket and enhance reading performance, whilst `PutRequests` can help us define the appropriate distribution's TTL. Meanwhile `PutRequests` and `TotalRequestLatency` can help us define a prefix partition strategy or S3 Transfer Acceleration configuration to enhance writing performance.


## NGINX
Using [available CloudWatch metrics for Amazon EC2](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/viewing_metrics_with_cloudwatch.html), I'd monitor `CPUUtilization`, `DiskReadBytes` `DiskWriteBytes`, `NetworkIn`, and `NetworkOut`. Using [custom metrics collected by the CloudWatch agent](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/metrics-collected-by-CloudWatch-agent.html), I'd monitor `mem_available` and `mem_available_percent`.

Instance metrics, such as `CPUUtilization`, `DiskReadBytes` `DiskWriteBytes`, `mem_available`, and `mem_available_percent`, can help us understand the performance of the underlying instance. Meantime, `NetworkIn` and `NetworkOut` can help us understand network load on the server.  

I'd also take a look into this AWS-provided solution template: [nginx-demo.template](https://solutions-reference.s3.amazonaws.com/amazon-cloudwatch-monitoring-framework/latest/nginx-demo.template) that monitors "traffic patterns", "throughput and latency metrics to report health of individual servers", "host-level resource metrics to determine scaling up or down", and "status to identify issues" (source: [NGINX key performance indicators](https://docs.aws.amazon.com/solutions/latest/amazon-cloudwatch-monitoring-framework/nginx-key-performance-indicators.html)).

---
# Task 3
1. Check if there's an Internet Gateway attached to the public VPC.
2. Check if the Route Table of the Load Balancer's subnet has a route to the Internet Gateway. 
3. Check if Security Groups attached to cluster nodes and the Load Balancer allow the required inbound traffic.
4. Check if ACLs attached to the subnets under cluster nodes or the Load Balancer allow the required inbound and outbound traffic.
5. Check if the VPC Peering or Transit Gateway setup is allowing traffic between both VPCs.

[VPC Flow Logs](https://docs.aws.amazon.com/vpc/latest/userguide/flow-logs.html#flow-log-records) can help us identify if traffic was not permitted by the security groups or network ACLs (`action`) and the path that egress traffic takes to the destination (`traffic-path`, `flow-direction`).