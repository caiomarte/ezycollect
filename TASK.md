Task 1
Create a Pipeline file using a CI/CD tool of your preference (e.q. GoCD, CircleCI,
Github Actions, Gitlab CI, etc.). You must include in the Pipeline:
a. Infrastructure step to create:
i. AWS SQS.
ii. AWS S3.
b. Nginx (HTTP) installation in a Kubernetes Cluster.
c. Configure SQS endpoint and S3 endpoint as a environment variable to Nginx:
i. SQS_ENDPOINT=xxx
ii. S3_ENDPOINT=xxx
d. Don’t need to share a Kubernetes Cluster or Pipeline tool with us, only the
Pipeline files used.