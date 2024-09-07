################ Register application ######################

# Register application
resource "aws_servicecatalogappregistry_application" "wisdom_pet_medicine_web_app" {
  name        = "WisdomPetMedicine"
  description = "Register WisdomPetMedicine web application"
}

