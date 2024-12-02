resource "github_repository" "repositories" {
  for_each = { for repo in local.repositories : repo["name"] => repo }

  name        = each.value["name"]
  description = each.value["description"]
  private     = each.value["private"]
  is_template = each.value["isTemplate"]

  # Ensure repository is not created if already exists
  lifecycle {
    prevent_destroy = true
  }
}
