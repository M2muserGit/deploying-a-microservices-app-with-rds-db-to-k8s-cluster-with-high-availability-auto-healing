module "eks" {
    source = "terraform-aws-modules/eks/aws"
    version = "~> 19.16"

    cluster_name = = var.cluster_name
    cluster_version = var.cluster_version
    cluster_endpoint_public_access = true
    
    cluster_addons = {
        vpcCni = {
            before_compute = true
            most_recent = true
            configuaation_values = jsonencode({
                env = {
                    Enable_Pod_ENI = "true"
                    Enable_prefix_delegation = "true"
                    POD_Security_enforce_mode = "standard"
            
                }
                nodeagent = {
                    enablePolicyeventlogs = "true"
                }
                enablenetworkPolicy = "true"
           })  

        }
    }
    vpc_id = module.vpc.vpc_id
    subnet_ids = module vpc.private_subnets

    create_cluster_security_group = false
    create_node_security_group = false

    eksmanagaed_node_group = {
        default = {
            desired_capacity = 2
            max_capacity = 6
            min_capacity = 3
            instance_type = "m5.large"
            forceupdateversion = true
            relaease_version = var.cluster_version
            updateconfig = {
                max_unavailable_percentage = 50
            }
            labels = {
                workspace-default = "yes"
            }
    }
    }
        tags = merge(local.tags){
            "karpenter.sh/discovery" = var.cluster_name
        })
    }
