variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "user_emails" {
  description = "User emails list"
  type        = list(string)
}

variable "role_actions" {
  description = "Liste des actions pour le rôle personnalisé"
  type        = list(string)
}
