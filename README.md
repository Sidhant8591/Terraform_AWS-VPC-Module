# 🏗️ Terraform AWS VPC Module
 
A production-ready Terraform module to provision a **3-tier AWS VPC** architecture with public, application (private), and database (private) subnets — dynamically distributed across Availability Zones.
 
---
 
## 📐 Architecture Overview
 
```
VPC (10.1.0.0/16)
│
├── 🌐 Public Subnets          (e.g. 10.1.1.0/24, 10.1.2.0/24)
│   └── Internet Gateway  ──► Route: 0.0.0.0/0 → IGW
│       └── NAT Gateway (optional, placed in public subnet[0])
│
├── 🖥️  App Private Subnets    (e.g. 10.1.4.0/24, 10.1.5.0/24)
│   └── Route: 0.0.0.0/0 → NAT Gateway (if enabled)
│
└── 🗄️  DB Private Subnets     (e.g. 10.1.7.0/24, 10.1.8.0/24)
    └── Route: 0.0.0.0/0 → NAT Gateway (if enabled)
```
 
Subnets are **dynamically mapped** to available Availability Zones in the selected region — no hardcoding required.
 
---
 
## 📁 File Structure
 
```
.
├── main.tf             # Core VPC resources (subnets, IGW, NAT, route tables)
├── variables.tf        # Input variable declarations
├── provider.tf         # AWS provider configuration
├── versions.tf         # Terraform and provider version constraints
└── terraform.tfvars    # Example variable values
```
 
---
 
## 🚀 Resources Created
 
| Resource | Description |
|---|---|
| `aws_vpc` | Main VPC with DNS support/hostnames |
| `aws_subnet` (public) | Public subnets, one per AZ, with auto-assign public IP |
| `aws_subnet` (app) | Private subnets for the application tier |
| `aws_subnet` (db) | Private subnets for the database tier |
| `aws_internet_gateway` | Internet Gateway attached to the VPC |
| `aws_eip` | Elastic IP for the NAT Gateway (conditional) |
| `aws_nat_gateway` | NAT Gateway in the first public subnet (conditional) |
| `aws_route_table` (public) | Routes public traffic via IGW |
| `aws_route_table` (app) | Routes app-tier outbound traffic via NAT Gateway |
| `aws_route_table` (db) | Routes DB-tier outbound traffic via NAT Gateway |
| `aws_route_table_association` | Associates each subnet with its route table |
 
---
 
## ⚙️ Variables
 
| Variable | Type | Default | Description |
|---|---|---|---|
| `vpc_cidr` | `string` | — | CIDR block for the VPC |
| `organization_prefix` | `string` | — | Prefix used in all resource names |
| `enable_dns_support` | `bool` | `true` | Enable DNS resolution in the VPC |
| `enable_dns_hostnames` | `bool` | `true` | Enable DNS hostnames in the VPC |
| `public_subnets` | `list(string)` | `[]` | CIDR blocks for public subnets |
| `app_subnets` | `list(string)` | `[]` | CIDR blocks for app-tier private subnets |
| `db_subnets` | `list(string)` | `[]` | CIDR blocks for DB-tier private subnets |
| `create_nat_gateway` | `bool` | `false` | Whether to create a NAT Gateway |
| `region` | `string` | — | AWS region to deploy resources in |
 
---
 
## 📝 Example `terraform.tfvars`
 
```hcl
region               = "ap-southeast-1"
vpc_cidr             = "10.1.0.0/16"
organization_prefix  = "myorg"
 
enable_dns_support   = true
enable_dns_hostnames = true
 
public_subnets = [
  "10.1.1.0/24",
  "10.1.2.0/24"
]
 
app_subnets = [
  "10.1.4.0/24",
  "10.1.5.0/24"
]
 
db_subnets = [
  "10.1.7.0/24",
  "10.1.8.0/24"
]
 
create_nat_gateway = true
```
 
---
 
## 🛠️ Usage
 
### 1. Prerequisites
 
- [Terraform](https://developer.hashicorp.com/terraform/downloads) `>= 1.0`
- [AWS CLI](https://aws.amazon.com/cli/) configured with appropriate credentials
- AWS Provider `>= 5.46`
 
### 2. Clone the Repository
 
```bash
git clone https://github.com/Sidhant8591/Terraform_AWS-VPC-Module.git
cd terraform-aws-vpc
```
 
### 3. Configure Variables
 
Edit `terraform.tfvars` with your desired values, or pass variables via the CLI.
 
### 4. Initialize Terraform
 
```bash
terraform init
```
 
### 5. Review the Plan
 
```bash
terraform plan
```
 
### 6. Apply
 
```bash
terraform apply
```
 
### 7. Destroy (when done)
 
```bash
terraform destroy
```
 
---
 
## 🔖 Resource Naming Convention
 
All resources are named using the `organization_prefix` variable. For example, with `organization_prefix = "myorg"`:
 
| Resource | Name |
|---|---|
| VPC | `myorg-vpc` |
| Public Subnet 1 | `myorg-public-subnet-1-ap-southeast-1a` |
| App Subnet 1 | `myorg-app-private-subnet-1-ap-southeast-1a` |
| DB Subnet 1 | `myorg-db-private-subnet-1-ap-southeast-1a` |
| Internet Gateway | `myorg-igw` |
| NAT Gateway | `myorg-nat` |
| Public Route Table | `myorg-public-rt` |
| App Route Table | `myorg-app-rt` |
| DB Route Table | `myorg-db-rt` |
 
---
 
## 📌 Design Decisions
 
- **Dynamic AZ assignment** — subnets are automatically spread across available AZs in the region using the `aws_availability_zones` data source. No manual AZ hardcoding needed.
- **Conditional NAT Gateway** — set `create_nat_gateway = false` to skip NAT Gateway creation and reduce costs in dev/test environments.
- **3-tier isolation** — public, app, and DB subnets each have their own route table, enforcing network-layer separation between tiers.
- **Scalable subnet counts** — add more CIDR blocks to any subnet list to span additional AZs automatically.
 
---
 
## ✅ Requirements
 
| Tool | Version |
|---|---|
| Terraform | `>= 1.0` |
| AWS Provider | `>= 5.46` |
 
---
 
# 📄 License
 
This project is licensed under the MIT License. See [LICENSE](LICENSE) for details.
