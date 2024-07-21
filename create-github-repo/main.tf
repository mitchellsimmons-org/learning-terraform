resource "github_repository" "test" {
  name                   = "test"
  description            = "Test repo"
  visibility             = "private"
  delete_branch_on_merge = true

}
