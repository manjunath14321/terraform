resource "local_file" "test" {
  filename = var.MY_FILE
  content  = "this is the first file"
}

