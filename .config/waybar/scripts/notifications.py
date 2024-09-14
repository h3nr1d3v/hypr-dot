#!/usr/bin/env python3

import subprocess
import json

def get_notifications():
    result = subprocess.run(["dunstctl", "history"], capture_output=True, text=True)
    if result.returncode != 0:
        print("Error ejecutando dunstctl history:", result.stderr)
        return []

    try:
        notifications = json.loads(result.stdout)
    except json.JSONDecodeError as e:
        print(f"Error al decodificar JSON: {e}")
        print("Salida de dunstctl history:", result.stdout)
        return []

    return notifications
def format_notifications(notifications):
    formatted = []
    for notification in notifications:
        if isinstance(notification, dict):  # Verifica si el elemento es un diccionario
            formatted.append(f"{notification['summary']}: {notification['body']}")
        else:
            print("Error: Elemento no es un diccionario:", notification)
    return formatted

def main():
    notifications = get_notifications()
    formatted_notifications = format_notifications(notifications)
    for notification in formatted_notifications:
        print(notification)

if __name__ == "__main__":
    main()
