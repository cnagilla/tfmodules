locals {
  k8s_version    = "1.26.0"
  ssh_user       = "sysops"
  ssh_public_key = tls_private_key.ssh.public_key_openssh
  values = {
    argocd         = <<EOF
configs:
  secret:
    argocdServerAdminPassword: ${null_resource.argocd_admin_password.triggers["pw"]}
  params:
    server.insecure: true
    server.rootpath: "/argocd"
server:
  ingress:
    enabled: true
    ingressClassName: nginx
    annotations:
      nginx.ingress.kubernetes.io/rewrite-target: /argocd/$2
      nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
      nginx.ingress.kubernetes.io/backend-protocol: "HTTP"
    pathType: ImplementationSpecific
    paths: ["/argocd(/|$)(.*)"]
EOF
    nginx          = <<EOF
controller:
  service:
    annotations:
      service.beta.kubernetes.io/azure-load-balancer-health-probe-request-path: /healthz
defaultBackend:
  enabled: true
EOF
    nginx-internal = <<EOF
controller:
  service:
    external:
      enabled: false
    internal:
      enabled: true
      annotations:
        service.beta.kubernetes.io/azure-load-balancer-internal: "true"
        service.beta.kubernetes.io/azure-load-balancer-health-probe-request-path: /healthz
defaultBackend:
  enabled: true
EOF
  }
  parameters = {
    "argocd" : {
      "sensitive" : {
        "ui-password" : {
          "name" : "configs.secret.argocdServerAdminPassword"
          "value" : null_resource.argocd_admin_password.triggers["pw"]
        }
      }
      "plain" : {
        "dex" : {
          "name" : "dex.enabled"
          "value" : false
        }
        "http-only" : {
          name  = "configs.params.server\\.insecure"
          value = true
        }
        "root" : {
          name  = "configs.params.server\\.rootpath"
          value = "/argocd"
        }
      }
    }
    "nginx" : {
      "plain" : {
        "health-check" : {
          "name" : "controller.service.annotations.'service\\.beta\\.kubernetes\\.io/azure-load-balancer-health-probe-request-path'"
          "value" : "/healthz"
        }
        "pass-ssl" : {
          "name" : "controller.extraArgs.enable-ssl-passthrough"
          "value" : ""
        }
      }
    }
  }
}