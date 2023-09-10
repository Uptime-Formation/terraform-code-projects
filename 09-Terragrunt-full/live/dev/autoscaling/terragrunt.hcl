include "root" {
  path = find_in_parent_folders()
}
include "envcommon" {
  path = "${dirname(find_in_parent_folders())}/_envcommon/autoscaling.hcl"
}
inputs = {
  instance_class    = "db.t2.micro"
  allocated_storage = 100
}
