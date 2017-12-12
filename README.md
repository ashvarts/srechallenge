# SREChallenge

The cookbook for this challenge is located in  `chef/cookbooks/srechallenge`, the `chef/cookbooks`  directory also contains vendored cookbooks that the main cookbook depends on. The cookbook will accomplishes the following tasks:

- Installs and configures an Nginx server.
  - Running on Ubuntu 16.04.
  - Listens for web traffic on port 80 and 443 ip4 and ip6.
  - Uses a self-signed certificate for ssl.
  - Redirects all http traffice to https.
  - Responds with a "Hello World" index.html page.


- Enables UFW firewall.
  - Allows all outbound traffic.
  - Allow incoming traffic on ports 22, 80, 443 (ip4 and ip6).
  - Blocks all other incoming traffic.


- Uses Inspec tests to verify the configuration.
- Provisions the instance on Amazon's EC2 using terraform and chef-solo.

# Prerequisites

- AWS Credentials.
- [Terraform](https://www.terraform.io/downloads.html) for creating environment and provisioning server.
- [Inspec](https://www.inspec.io/docs/) gem for testing. (install with `gem install inspec`)

# Instructions 

1. Clone repo.
2. Run `./srechallenge`
3. Enter aws api key and secrete when prompted.
4. The script will: 
   1. Create an ssh key for provisioning/accessing machine.
   2. Run terraform apply to set up a vpc and provision web server.
5. Run inspec scripts against the server.
6. To clean up run `terraform delete` and delete this directory.