resource "random_string" "delta" {
  length           = 16
  special          = var.a2_var
  override_special = var.a1_var
}


output "id" {
  value = random_string.delta.id
}


resource "local_file" "file1" {
  filename = "m1"
  content  = var.demo
}

resource "local_file" "file2" {
  filename = "m2"
  content  = var.demo1
}

resource "local_file" "file3" {
  filename = "m3"
  content  = var.demo2
}

resource "local_file" "file4" {
  filename = "m4"
  content  = var.list_demo[2]
}

resource "local_file" "file5" {
  filename = "m5"
  content  = var.map_demo.name
}

resource "local_file" "file6" {
  filename = "m6"
  content  = var.map_demo.name
}

resource "local_file" "file7" {
  filename = "m7"
  content  = var.tuple_demo[2][1]
}

resource "local_file" "file8" {
  filename = "m8"
  content  = var.object_demo.name 
}
