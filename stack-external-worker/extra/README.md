# Cycloid notes

# Update exteral workers stack templates

```bash
export AWS_ACCESS_KEY_ID=$(vault read -field=access_key secret/$CUSTOMER/aws)
export AWS_SECRET_ACCESS_KEY=$(vault read -field=secret_key secret/$CUSTOMER/aws)

# AWS
aws s3 cp aws/external-worker-aws-cf-template.yaml s3://cycloid-cloudformation/

# Flexible engine
cd flexible-engine && zip -r /tmp/flexible-engine.zip Resources/ main.yaml && cd -
aws s3 cp /tmp/flexible-engine.zip s3://cycloid-cloudformation/
```


