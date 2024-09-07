# Step 1: Create SES Email Identity
resource "aws_ses_email_identity" "email_identity" {
  email = "sdweerathunga5@gmail.com"
}

# Step 2: Output the status
output "email_identity_arn" {
  value = aws_ses_email_identity.email_identity.arn
}


output "note_ses" {
  value = "Verify the newly created email identity to activate."
}
