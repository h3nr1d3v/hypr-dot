#!/usr/bin/env python3

import sys
import json
import subprocess


def get_player_status(player):
    result = subprocess.run(
        ["playerctl", "--player", player, "status"], capture_output=True, text=True
    )
    if result.returncode != 0:
        print(f"Error getting player status: {result.stderr}", file=sys.stderr)
        return None
    return result.stdout.strip()


def get_player_metadata(player):
    result = subprocess.run(
        [
            "playerctl",
            "--player",
            player,
            "metadata",
            "--format",
            "{{title}} - {{artist}}",
        ],
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        print(f"Error getting player metadata: {result.stderr}", file=sys.stderr)
        return None
    return result.stdout.strip()


def main():
    # Lista de reproductores aceptables
    valid_players = ["firefox", "spotify"]

    # Usa el primer argumento como nombre del reproductor, o "firefox" por defecto
    player = sys.argv[1] if len(sys.argv) > 1 else "firefox"

    if player not in valid_players:
        print(
            f"Invalid player specified. Valid options are: {', '.join(valid_players)}",
            file=sys.stderr,
        )
        sys.exit(1)

    status = get_player_status(player)
    if status is None:
        print("{}")
        return

    metadata = get_player_metadata(player)
    output = {
        "status": status,
        "metadata": metadata if metadata else "No metadata available",
    }
    print(json.dumps(output))


if __name__ == "__main__":
    main()
