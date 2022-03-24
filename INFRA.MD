# Intro

We are using terraform to provision

- cd into infra folder ``cd infra``
- create the shared workspace if it does not exists ``terraform workspace new shared``
- deploy the shared infra ``terraform apply -target module.shared``
