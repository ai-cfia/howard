resource "tls_private_key" "pair" {
  algorithm = "RSA"
  rsa_bits  = 2048
}
