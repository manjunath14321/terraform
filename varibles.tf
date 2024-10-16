variable "a1_var" {
  default = "@@@@@"
  type    = string
}

variable "a2_var" {
  default = true
  type    = bool
}

variable "demo" {
  type    = string
  default = "this is example for string data type"
}

variable "demo1" {
  type    = number
  default = 12345
}

variable "demo2" {
  type    = bool
  default = true
}

variable "list_demo" {
  type    = list(string)
  default = ["dev", "prod", "testing", "preprod"]
}

variable "map_demo" {
  type = map(any)
  default = {

    name = "manjunath"
    id   = 567
  }
}

variable "tuple_demo" {
  type    = tuple([string, number, list(any)])
  default = ["datatype", 7876, ["one", 4950]]
}

variable "object_demo" {
  type = object({
    id      = number
    name    = string
    address = list(map(string))
  })

  default = {
    id   = "8904"
    name = "varun"
    address = [{  area= "nagavara", addr2 = "bangalore" },
    { city = "bellery" }]
  }
}
