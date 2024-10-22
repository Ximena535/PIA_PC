import logging
import webbrowser
import pyperclip
import pyautogui
import time
from colorama import Fore, Style

def menu ():
    print(Fore.GREEN + "Abuse IP" + Fore.YELLOW + 
          "\nElige una opcion\n1. Busqueda por archivo de texto\n2. Busqueda por un ip\n3. Regresar al script principal"
           + Style.RESET_ALL)

def ip_man():
        ip=input("Ingrese la IP: ")
        webbrowser.open_new("https://www.abuseipdb.com/")
        time.sleep(3)
        for i in range(15):
                pyautogui.press('tab')
        pyperclip.copy(ip)
        pyautogui.hotkey('ctrl', 'v', interval = 0.15)
        pyautogui.press("enter")

def ip_txt():
    doc=input("Nombre del documento: ")
    documento = open(doc,'r')
    documento = documento.read().split('\n')
    for ip in documento:
            webbrowser.open_new("https://www.abuseipdb.com/")
            time.sleep(3)
            for i in range(15):
                pyautogui.press('tab')
            pyperclip.copy(ip)
            pyautogui.hotkey('ctrl', 'v', interval = 0.15)
            pyautogui.press("enter")

def main():
    while True:
        menu()
        opcion = input("-------> ")

        if opcion == '1':
            ip_man()
        elif opcion == '2':
            ip_txt()
        elif opcion == '3':
            print("Regresando al script principal")
            break
        else:
            print("Opción no válida, por favor intenta de nuevo.")

if __name__=="__main__":
     main()