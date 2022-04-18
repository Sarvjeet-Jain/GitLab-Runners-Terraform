provider "helm" {

  kubernetes {
    config_path = "~/.kube/config"
  }
}

resource "helm_release" "gitlab-runner" {
  name       = "<value>"
  repository = "https://charts.gitlab.io"
  chart      = "gitlab-runner"
  #version    = "6.0.1"
  create_namespace = true
  namespace = "gitlab-runners"
   set{
     name = "nodeseletor.cloud.google.com/gke-nodepool"
     value = "gitlab-runner-pool"
     
   }
  

  values = [
    "${file("values.yaml")}"]
}


resource "null_resource" "runer-role" {
  # ...

  provisioner "local-exec" {
    command = "kubectl apply -f runner-role.yaml"
  }
}

resource "null_resource" "role-binding" {
  # ...

  provisioner "local-exec" {
    command = "kubectl -n gitlab-runners apply -f runner-role-binding.yaml"
  }
}

resource "null_resource" "secrets" {
  # ...

  provisioner "local-exec" {
    command = "kubectl  apply -f regcred.yaml"
  }
}