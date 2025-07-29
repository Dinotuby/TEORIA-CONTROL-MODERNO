import serial
import time

puerto = 'COM8'      # Cambia por tu puerto
baudrate = 115200
archivo_salida = 'datos_arduino.csv'

def guardar_datos():
    try:
        with serial.Serial(puerto, baudrate, timeout=1) as ser, open(archivo_salida, 'w') as f:
            print(f"Conectado a {puerto} a {baudrate} baudios. Guardando datos en {archivo_salida}...")

            # Leer cabecera tras reinicio
            cabecera = ser.readline().decode('utf-8').strip()
            print("Cabecera recibida:", cabecera)
            f.write(cabecera + '\n')

            while True:
                linea = ser.readline().decode('utf-8').strip()
                if linea:
                    print(linea)
                    f.write(linea + '\n')
                    f.flush()

    except serial.SerialException:
        print(f"No se pudo abrir el puerto {puerto}. Revisa que esté conectado.")
    except KeyboardInterrupt:
        print("\nGuardado finalizado. Programa terminado.")

if __name__ == "__main__":
    guardar_datos()
