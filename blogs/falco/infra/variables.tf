variable "region" {
  description = "Region"
  type        = string
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "oidc_id" {
  description = "EKS OIDC ID"
  type        = string
}

variable "falco_serviceaccount" {
  description = "EKS Falco service account name"
  type        = string
  default     = "falco"
}

variable "falco_namespace" {
  description = "EKS namespace where Falco service running"
  type        = string
  default     = "falco"
}
