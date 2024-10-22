import shodan
import re

class ShodanAPI:
    """
    Clase para interactuar con la API de Shodan.
    """

    def __init__(self, api_key):
        self.api_key = api_key
        try:
            self.api = shodan.Shodan(api_key)
            # Validación inicial para comprobar si la API key es válida
            self.api.info()
        except shodan.APIError as e:
            raise ValueError(f"Error al inicializar Shodan API: {e}")
        except Exception as e:
            raise ConnectionError(f"Error desconocido al conectar con Shodan: {e}")

    def get_ip_info(self, ip_address):
        if not self.validate_ip(ip_address):
            return "Dirección IP inválida."
        try:
            result = self.api.host(ip_address)
            return result
        except shodan.APIError as e:
            return f"Error en la consulta de la IP: {e}"
        except Exception as e:
            return f"Error inesperado: {e}"

    def search(self, query):
        try:
            result = self.api.search(query)
            if result['total'] == 0:
                return f"No se encontraron resultados para la consulta: {query}"
            return result['matches']
        except shodan.APIError as e:
            return f"Error en la búsqueda: {e}"
        except Exception as e:
            return f"Error inesperado: {e}"

    def count_results(self, query):
        try:
            result = self.api.count(query)
            return result['total']
        except shodan.APIError as e:
            return f"Error al contar resultados: {e}"
        except Exception as e:
            return f"Error inesperado: {e}"

    def get_services(self):
        try:
            result = self.api.info()
            return result
        except shodan.APIError as e:
            return f"Error al obtener información de la cuenta: {e}"
        except Exception as e:
            return f"Error inesperado: {e}"

    @staticmethod
    def validate_ip(ip_address):
        pattern = r"^(?:[0-9]{1,3}\.){3}[0-9]{1,3}$"
        return re.match(pattern, ip_address) is not None


# Menú interactivo para utilizar ShodanAPI
def mostrar_menu():
    print("\nMenú Principal\n 1. Buscar información de una IP\n 2. Buscar por consulta\n 3. Contar resultados de una consulta\n 4. Obtener información de la cuenta\n 5. Salir")


def ejecutar_opcion(shodan_api, opcion):
    if opcion == '1':
        ip = input("Introduce la dirección IP: ")
        resultado = shodan_api.get_ip_info(ip)
        print(resultado)

    elif opcion == '2':
        consulta = input("Introduce tu consulta de búsqueda (por ejemplo, 'apache', 'nginx', etc.): ")
        resultado = shodan_api.search(consulta)
        print(resultado)

    elif opcion == '3':
        consulta = input("Introduce tu consulta para contar resultados: ")
        resultado = shodan_api.count_results(consulta)
        print(f"Número de resultados encontrados: {resultado}")

    elif opcion == '4':
        resultado = shodan_api.get_services()
        print(resultado)

    elif opcion == '5':
        print("Saliendo del programa. ¡Hasta luego!")
    else:
        print("Opción inválida, por favor selecciona una opción válida.")


def iniciar_menu():
    api_key = input("Introduce tu clave API de Shodan: ")

    try:
        shodan_api = ShodanAPI(api_key)
    except ValueError as e:
        print(e)
        return
    except ConnectionError as e:
        print(e)
        return

    opcion = ""
    while opcion != '5':
        mostrar_menu()
        opcion = input("Selecciona una opción (1-5): ").strip()

        # Validación de entrada: Solo aceptamos opciones válidas
        if opcion not in ['1', '2', '3', '4', '5']:
            print("Entrada no válida. Por favor selecciona una opción entre 1 y 5.")
        else:
            ejecutar_opcion(shodan_api, opcion)


if __name__ == "__main__":
    iniciar_menu()