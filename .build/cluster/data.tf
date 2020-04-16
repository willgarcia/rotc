data "local_file" "attendees" {
  filename = "${path.module}/../attendees.txt"
}

locals {
  attendees = split("\n", trimspace(data.local_file.attendees.content))
  attendees_as_gcp_identities = formatlist("user:%s", local.attendees)
}