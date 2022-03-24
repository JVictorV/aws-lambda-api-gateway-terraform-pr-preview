data "terraform_remote_state" "shared" {
  backend = "local" //TODO Change that to remote state

  config = {
	path = "${path.module}/../../terraform.tfstate.d/shared/terraform.tfstate"
  }
}
