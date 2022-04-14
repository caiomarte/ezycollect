if [ ! -f $(pwd)/build/aws/dist/aws ]; then
    echo "Downloading AWS CLI"
    curl https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip
    unzip -qd build awscliv2.zip
fi

export PATH=$PATH:$(pwd)/build/aws/dist
export AWS_REGION=${AWS_REGION}
export AWS_ROLE_ARN=${AWS_ROLE}
export AWS_WEB_IDENTITY_TOKEN_FILE=$(pwd)/web-identity-token

echo $BITBUCKET_STEP_OIDC_TOKEN > $(pwd)/web-identity-token

aws --version
aws sts get-caller-identity