#!/usr/bin/env python3

import sys
import json
import subprocess

def get_player_status(player):
    result = subprocess.run(["playerctl", "--player", player, "status"], capture_output=True, text=True)
    if result.returncode != 0:
        print("Error getting player status", file=sys.stderr)
        return None
    return result.stdout.strip()

def get_player_metadata(player):
    result = subprocess.run(["playerctl", "--player", player, "metadata", "--format", "{{title}} - {{artist}}"], capture_output=True, text=True)
    if result.returncode != 0:
        print("Error getting player metadata", file=sys.stderr)
        return None
    return result.stdout.strip()

def main():
    player = sys.argv[1] if len(sys.argv) > 1 else "spotify"
    status = get_player_status(player)
    if status is None:
        print("{}")
        return

    metadata = get_player_metadata(player)
    output = {
        "status": status,
        "metadata": metadata if metadata else "No metadata available"
    }
    print(json.dumps(output))

if __name__ == "__main__":
    main()
