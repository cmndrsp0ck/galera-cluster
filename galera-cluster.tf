# Building out Galera cluster
module "sippin_db" {
  source           = "github.com/cmndrsp0ck/galera-tf-mod.git?ref=v1.0.2"
  project          = "${var.project}"
  region           = "${var.region}"
  keys             = "${var.keys}"
  private_key_path = "${var.private_key_path}"
  ssh_fingerprint  = "${var.ssh_fingerprint}"
  public_key       = "${var.public_key}"
  ansible_user     = "${var.ansible_user}"
}
