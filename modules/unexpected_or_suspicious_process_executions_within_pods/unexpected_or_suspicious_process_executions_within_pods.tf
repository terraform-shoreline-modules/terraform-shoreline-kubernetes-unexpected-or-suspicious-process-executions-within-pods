resource "shoreline_notebook" "unexpected_or_suspicious_process_executions_within_pods" {
  name       = "unexpected_or_suspicious_process_executions_within_pods"
  data       = file("${path.module}/data/unexpected_or_suspicious_process_executions_within_pods.json")
  depends_on = [shoreline_action.invoke_apply_policies]
}

resource "shoreline_file" "apply_policies" {
  name             = "apply_policies"
  input_file       = "${path.module}/data/apply_policies.sh"
  md5              = filemd5("${path.module}/data/apply_policies.sh")
  description      = "Implement security measures like network policies, container isolation, and pod security policies to prevent unauthorized process execution within the pods."
  destination_path = "/tmp/apply_policies.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_apply_policies" {
  name        = "invoke_apply_policies"
  description = "Implement security measures like network policies, container isolation, and pod security policies to prevent unauthorized process execution within the pods."
  command     = "`chmod +x /tmp/apply_policies.sh && /tmp/apply_policies.sh`"
  params      = ["NAMESPACE","POD_NAME","POLICY_NAME"]
  file_deps   = ["apply_policies"]
  enabled     = true
  depends_on  = [shoreline_file.apply_policies]
}

