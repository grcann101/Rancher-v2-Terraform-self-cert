 #-------------------------------------------------------------------------------
 # aws variables for Rancher V2.0.0 HA Server environment
 # the keys are input and not stored in the configuration for security reasons.
 #-------------------------------------------------------------------------------
resource "aws_key_pair" "rancher" {
  key_name   = "rancherv2"
  public_key = "AAAAB3NzaC1yc2EAAAADAQABAAABAQCtjmYUYKaORzzo2Io68xoEYkI4r89jjhFkMGdUtsZ1REqUi66OzzW7EMUZ6N0WnUJulAKMw8IQzDvfzGGewAGFMCiEtvDMgRLe94hsZRBdk9npP47ScrX4gewRhh8sqUzrZWtel+4RKndLDYO0FxKH4qAGWdQrc1Kl7XNHdoNNXkJJMtWLjo4U4bBF4sKIy3Bgq7gQ5aU13LT/o8v/m1QwI+ZMTZKSZ+5wGAfjY9uzWsmQvUi591EwOxX9ShNp/TlHbsZH5WhdGw8FMRPXDTUee2/lRbhi5r5MPaYonDwgI2b1GpwJ9UNgmdTtRo51+4kyTRxSyV/5pb204itvUMmZ"
}