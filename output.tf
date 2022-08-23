//check ami
output "latest_ubuntu_ami_id_ger" {
  value = data.aws_ami.ger_latest_ubuntu.id
}

output "latest_ubuntu_ami_id_usa" {
  value = data.aws_ami.usa_latest_ubuntu.id
}

output "latest_ubuntu_ami_id" {
  value = data.aws_ami.defaut_latest_ubuntu.id
}

// Print all users details
output "created_iam_users_all" {
  value = aws_iam_user.users
}

// Print only ID of users *-all users
output "created_iam_users_ids" {
  value = aws_iam_user.users[*].id
}

// Print my Custom output list
output "created_iam_users_custom" {
  value = [
    for user in aws_iam_user.users :
    "Username: ${user.name} has ARN: ${user.arn}"
  ]
}

// Print My Custom output MAP
output "created_iam_users_map" {
  value = {
    for user in aws_iam_user.users :
    user.unique_id => user.id // "XXXXXXXXXXXXXXXXX" : "maks" (example)
  }
}

// Print List of users with name 4 characters ONLY
output "custom_if_length_4_characters" {
  value = [
    for x in aws_iam_user.users :
    x.name
    if length(x.name) == 4
  ]
}

#===================================================================

// Print nice MAP of InstanceID: PublicIP
output "server_all" {
  value = {
    for server in aws_instance.my_usa_server :
    server.id => server.public_ip // "i-00000000000000" = "99.99.99.99" (example)
  }
}
