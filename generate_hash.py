from werkzeug.security import generate_password_hash 

# Genera hashes para diferentes usuarios
passwords = {
    "admin": "Perfect@password1",
    "agent": "Agent@1234", 
    "user": "User@12345"
}

print("=== Hashes generados ===")
for role, password in passwords.items():
    hash_result = generate_password_hash(password)
    print(f"{role.upper()}:")
    print(f"Password: {password}")
    print(f"Hash: {hash_result}")
    print("-" * 50)