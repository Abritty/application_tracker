# Idempotent seeds for development/test

if defined?(User)
  users = [
    { email: "admin@example.com", password: "Password!123", password_confirmation: "Password!123" },
    { email: "user@example.com",  password: "Password!123", password_confirmation: "Password!123" }
  ]

  users.each do |attrs|
    User.find_or_create_by!(email: attrs[:email]) do |u|
      u.password = attrs[:password]
      u.password_confirmation = attrs[:password_confirmation]
    end
  end
end
