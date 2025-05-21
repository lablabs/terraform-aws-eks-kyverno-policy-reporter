/**
 * # AWS EKS Kyverno policy reporter Terraform module
 *
 * A Terraform module to deploy the [Kyverno policy reporter](https://github.com/kyverno/policy-reporter) on Amazon EKS cluster.
 *
 * [![Terraform validate](https://github.com/lablabs/terraform-aws-eks-kyverno-policy-reporter/actions/workflows/validate.yaml/badge.svg)](https://github.com/lablabs/terraform-aws-eks-kyverno-policy-reporter/actions/workflows/validate.yaml)
 * [![pre-commit](https://github.com/lablabs/terraform-aws-eks-kyverno-policy-reporter/actions/workflows/pre-commit.yml/badge.svg)](https://github.com/lablabs/terraform-aws-eks-kyverno-policy-reporter/actions/workflows/pre-commit.yml)
 */

locals {
  addon = {
    name = "policy-reporter"

    helm_chart_version = "2.24.2"
    helm_repo_url      = "https://kyverno.github.io/policy-reporter/"
  }

  addon_irsa = {
    (local.addon.name) = {
    }
  }

  addon_values = yamlencode({
    serviceAccount = {
      create = module.addon-irsa[local.addon.name].service_account_create
      name   = module.addon-irsa[local.addon.name].service_account_name
      annotations = module.addon-irsa[local.addon.name].irsa_role_enabled ? {
        "eks.amazonaws.com/role-arn" = module.addon-irsa[local.addon.name].iam_role_attributes.arn
      } : tomap({})
    }
  })

  addon_depends_on = []
}
