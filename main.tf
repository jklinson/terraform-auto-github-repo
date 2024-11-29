provider "github" {
  token = var.github_token
}

data "local_file" "repositories_json" {
  filename = "repositories.json"
}

locals {
  repositories = jsondecode(data.local_file.repositories_json.content)
}

resource "github_repository" "repositories" {
  for_each = { for repo in local.repositories : repo["name"] => repo }

  name        = each.value["name"]
  description = each.value["description"]
  private     = each.value["private"]
  visibility  = each.value["visibility"]
  is_template = each.value["isTemplate"]

  # Ensure repository is not created if already exists
  lifecycle {
    prevent_destroy = true
  }
}