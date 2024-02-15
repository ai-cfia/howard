# This requires that jq and openssl are installed in the runtime environment
# It creates a certificate signing request (CSR) based on the vault-csr.conf file
# The 2 jq at the beginning and end of the pipes are used to read the input and wrap the result in json
# since this is how terraform "external" passes data.
data "external" "k8s_cert_request" {
  program = [
    "bash", "-c",
    "curl -o jq https://github.com/stedolan/jq/releases/download/jq-1.6/jq-linux64 && chmod +x jq && jq -rc '.key' | openssl req -new -noenc -config ${path.module}/vault-csr.conf -key /dev/stdin | jq -rRncs '{\"request\": inputs}'"
  ]
  query = {
    "key" = tls_private_key.vault_key.private_key_pem
  }
}
