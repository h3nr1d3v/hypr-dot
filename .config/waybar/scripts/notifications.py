#!/usr/bin/env python3

import json
import subprocess


def get_notifications():
    result = subprocess.run(["dunstctl", "history"], capture_output=True, text=True)
    if result.returncode != 0:
        print("Error ejecutando dunstctl history:", result.stderr, file=sys.stderr)
        return []

    try:
        notifications = json.loads(result.stdout)
        if isinstance(notifications, list) and len(notifications) > 0:
            return notifications[0].get("data", [])
        else:
            return []
    except json.JSONDecodeError as e:
        print(f"Error al decodificar JSON: {e}", file=sys.stderr)
        return []


def format_notifications(notifications):
    formatted = []
    for notification in notifications:
        if isinstance(notification, dict):
            summary = notification.get("summary", "Sin título")
            body = notification.get("body", "Sin cuerpo")
            formatted.append(f"{summary}: {body}")
    return formatted


def main():
    notifications = get_notifications()
    formatted_notifications = format_notifications(notifications)
    count = len(formatted_notifications)

    output = {
        "text": str(count) if count > 0 else "",
        "tooltip": (
            "\n".join(formatted_notifications) if count > 0 else "No hay notificaciones"
        ),
        "class": "have-notifications" if count > 0 else "no-notifications",
    }
    print(json.dumps(output))


if __name__ == "__main__":
    main()
