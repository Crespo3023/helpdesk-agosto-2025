import pymysql
from config import Config

def test_connection():
    """Prueba la conexión a la base de datos"""
    print("=" * 60)
    print("PRUEBA DE CONEXIÓN A LA BASE DE DATOS")
    print("=" * 60)
    
    # Mostrar configuración (sin mostrar la contraseña completa)
    print("\n Configuración:")
    print(f"   Host: {Config.DB_HOST}")
    print(f"   Usuario: {Config.DB_USER}")
    print(f"   Base de datos: {Config.DB_NAME}")
    print(f"   Contraseña: {'(vacía)' if not Config.DB_PASSWORD else '***'}")
    
    try:
        print("\n🔌 Intentando conectar...")
        conn = pymysql.connect(
            host=Config.DB_HOST,
            user=Config.DB_USER,
            password=Config.DB_PASSWORD,
            database=Config.DB_NAME,
            cursorclass=pymysql.cursors.DictCursor
        )
        print("✅ ¡Conexión de la base de datos exitosa!")
        
        # Probar algunas consultas
        with conn.cursor() as cursor:
            # Verificar tablas existentes
            print("\n📊 Verificando tablas existentes...")
            cursor.execute("SHOW TABLES")
            tables = cursor.fetchall()
            
            if tables:
                print(f"   Tablas encontradas: {len(tables)}")
                for table in tables:
                    table_name = list(table.values())[0]
                    print(f"   - {table_name}")
                    
                    # Contar registros en cada tabla
                    cursor.execute(f"SELECT COUNT(*) as count FROM {table_name}")
                    count = cursor.fetchone()['count']
                    print(f"     └─ Registros: {count}")
            else:
                print("   ⚠️ No se encontraron tablas en la base de datos")
            
            # Verificar usuarios
            print("\n👥 Verificando usuarios...")
            cursor.execute("SELECT id, name, email, role FROM users")
            users = cursor.fetchall()
            
            if users:
                print(f"   Usuarios encontrados: {len(users)}")
                for user in users:
                    print(f"   - ID: {user['id']} | {user['name']} ({user['email']}) - Rol: {user['role']}")
            else:
                print("   ⚠️ No hay usuarios en la base de datos")
                print("   💡 Sugerencia: Ejecuta el script de inicialización para crear un usuario admin")
        
        conn.close()
        print("\n" + "=" * 60)
        print("✅ TODAS LAS PRUEBAS COMPLETADAS EXITOSAMENTE")
        print("=" * 60)
        return True
        
    except pymysql.err.OperationalError as e:
        error_code, error_msg = e.args
        print(f"\n❌ Error de conexión (código {error_code}):")
        print(f"   {error_msg}")
        
        if error_code == 1045:
            print("\n Solución:")
            print("   1. Verifica tu archivo .env")
            print("   2. Usuario y contraseña deben coincidir con MySQL")
            print("   3. Para XAMPP, usuario='root' y contraseña='' (vacía)")
        elif error_code == 1049:
            print("\n Solución:")
            print("   1. La base de datos no existe")
            print("   2. Crea la base de datos ejecutando el script SQL en phpMyAdmin")
        
        print("\n" + "=" * 60)
        print("❌ PRUEBA FALLIDA")
        print("=" * 60)
        return False
        
    except Exception as e:
        print(f"\n❌ Error inesperado: {str(e)}")
        print("\n" + "=" * 60)
        print("❌ PRUEBA FALLIDA")
        print("=" * 60)
        return False

if __name__ == "__main__":
    test_connection()