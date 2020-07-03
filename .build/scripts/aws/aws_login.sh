#!/bin/bash

read -p 'Username: ' User

oktaauth  --server thoughtworks.okta.com --apptype amazon_aws --appid exk1c9mun89ywbfHW0h8 --username $User > /root/oktatoken

cat /root/oktatoken | aws_role_credentials saml --profile dev
