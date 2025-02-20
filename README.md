# AWS_Terraform_EKS

This repo has a terraform main file to create a minimalistic EKS cluster in AWS

## To use ##

* Create below managed(not inline) policies in AWS IAM pplicy tab

  1. ecr_policy
    ```
    {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "ecr:CreateRepository",
                "ecr:DescribeRepositories",
                "ecr:DeleteRepository",
                "ecr:BatchCheckLayerAvailability",
                "ecr:CompleteLayerUpload",
                "ecr:UploadLayerPart",
                "ecr:InitiateLayerUpload",
                "ecr:PutImage",
                "ecr:ListTagsForResource",
                "ecr:DescribeRepositories"
            ],
            "Resource": "*"
        }
    ]
  }

    ```
    2. eks_policy

     ```
     {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "eks:DeleteFargateProfile",
                "eks:DescribeFargateProfile",
                "eks:ListTagsForResource",
                "eks:DescribeInsight",
                "eks:UpdateAddon",
                "eks:UpdateClusterConfig",
                "eks:DescribeAddon",
                "eks:DescribeNodegroup",
                "eks:CreateEksAnywhereSubscription",
                "eks:UpdateEksAnywhereSubscription",
                "eks:ListNodegroups",
                "eks:DisassociateIdentityProviderConfig",
                "eks:DescribeAccessEntry",
                "eks:RegisterCluster",
                "eks:UpdatePodIdentityAssociation",
                "eks:CreateFargateProfile",
                "eks:DescribePodIdentityAssociation",
                "eks:DeleteCluster",
                "eks:ListPodIdentityAssociations",
                "eks:DescribeIdentityProviderConfig",
                "eks:DeleteNodegroup",
                "eks:AccessKubernetesApi",
                "eks:CreateAddon",
                "eks:UpdateNodegroupConfig",
                "eks:DescribeCluster",
                "eks:ListAccessPolicies",
                "eks:ListClusters",
                "eks:DeleteAccessEntry",
                "eks:UpdateClusterVersion",
                "eks:ListEksAnywhereSubscriptions",
                "eks:CreatePodIdentityAssociation",
                "eks:ListAccessEntries",
                "eks:ListAddons",
                "eks:DescribeEksAnywhereSubscription",
                "eks:UpdateNodegroupVersion",
                "eks:ListAssociatedAccessPolicies",
                "eks:AssociateEncryptionConfig",
                "eks:ListUpdates",
                "eks:DeleteEksAnywhereSubscription",
                "eks:DescribeAddonVersions",
                "eks:DeletePodIdentityAssociation",
                "eks:ListIdentityProviderConfigs",
                "eks:CreateCluster",
                "eks:DescribeAddonConfiguration",
                "eks:UntagResource",
                "eks:UpdateAccessEntry",
                "eks:AssociateAccessPolicy",
                "eks:CreateNodegroup",
                "eks:DeregisterCluster",
                "eks:ListInsights",
                "eks:DescribeClusterVersions",
                "eks:ListFargateProfiles",
                "eks:DeleteAddon",
                "eks:DescribeUpdate",
                "eks:DisassociateAccessPolicy",
                "eks:TagResource",
                "eks:CreateAccessEntry",
                "eks:AssociateIdentityProviderConfig"
            ],
            "Resource": "*"
        }
    ]
  }     
     
     ```
3. kms_policy

   ```
   {
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "kms:CreateKey",
                "kms:DescribeKey",
                "kms:ListKeys",
                "kms:ListAliases",
                "kms:CreateAlias",
                "kms:TagResource",
                "kms:PutKeyPolicy",
                "kms:UpdateKeyDescription",
                "kms:EnableKey",
                "kms:DisableKey",
                "kms:ScheduleKeyDeletion",
                "kms:CancelKeyDeletion"
            ],
            "Resource": "*"
        }
    ]
   }   
   ```

## Issues ##

1. lots of permission issues
  -> adding permissions in terraform file didnt work. took time to reflect on console (?)
2. InvalidSubnet.Conflict: The CIDR '10.0.2.0/24' conflicts with another subnet
  -> changed the subnet addresses so they dont overlap
3. Maximum policy size of 2048 bytes exceeded for user user_local_terminal
  -> inline policy has this limit. created managed policies
4. the targeted availability zone. Retry cluster creation using control plane subnets that span at least two of these availability zones: us-east-1a, us-east-1b, us-east-1c, us-east-1d, us-east-1f
   -> needed to specify the zones of the subnets

