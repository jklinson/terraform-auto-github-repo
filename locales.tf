locals {
  repositories = jsondecode(data.local_file.repositories_json.content)
}