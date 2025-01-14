import socket

#Puertos que utilizamos para el escaneo
START_PORT = 20
END_PORT = 80

def scan_ports(ip_address, start_port, end_port):
#Escaneo de puertos utilizando manejo de errores
    open_ports = []
    for port in range(start_port, end_port + 1):
        try:
            sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            sock.settimeout(1)
#Intenta establecer conexion con el puerto dado            
            result = sock.connect_ex((ip_address, port))
            if result == 0:
                open_ports.append(port)
            sock.close()
        except socket.gaierror:
            print(f"Error: La dirección IP dada es inválido ({ip_address})")
            return []
        except socket.error as e:
            print(f"Error al escanear el puerto {port}: {e}")
            continue
    return open_ports

#Entrada principal del script utlizando manejo de errores
def main():
    user_ip = input("Ingrese la dirección IP a escanear: ")
    try:
        print(f"Escaneando puertos en {user_ip} desde {START_PORT} hasta {END_PORT}...")
        open_ports = scan_ports(user_ip, START_PORT, END_PORT)

#Verificamos si los puertos estan abiertos
        if open_ports:
            print(f"Puertos abiertos: {', '.join(map(str, open_ports))}")
        else:
            print("No se encontraron puertos abiertos.")
    except ValueError:
        print("Por favor, ingrese números válidos para los puertos.")

if __name__ == "__main__":
    main()
