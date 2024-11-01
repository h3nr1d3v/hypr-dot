#!/usr/bin/env python3

import json
import subprocess
import sys


def get_player_status(player):
    result = subprocess.run(
        ["playerctl", "--player", player, "status"], capture_output=True, text=True
    )
    if result.returncode != 0:
        print("Error getting player status", file=sys.stderr)
        return None
    return result.stdout.strip()


def get_song_title(player):
    result = subprocess.run(
        ["playerctl", "--player", player, "metadata", "--format", "{{title}}"],
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        print("Error getting song title", file=sys.stderr)
        return None
    return result.stdout.strip()

'''
def main():
    player = sys.argv[1] if len(sys.argv) > 1 else "spotify"
    status = get_player_status(player)
    if status is None:
        print(json.dumps({"text": ""}))
        return

    title = get_song_title(player)
    output = {
        "text": title if title else "No title available",
        "tooltip": (
            f"Status: {status}\nTitle: {title}" if title else "No title available"
        ),
        "class": status.lower(),
    }
    print(json.dumps(output))
'''
def main():
    player = sys.argv[1] if len(sys.argv) > 1 else "spotify"
    status = get_player_status(player)
    if status is None:
        print(json.dumps({"text": ""}))
        return

    title = get_song_title(player)
    output = {
        "text": title if title else "No title available",
        "tooltip": (
            f"Status: {status}\nTitle: {title}" if title else "No title available"
        ),
        "class": "playing" if status == "Playing" else "paused",
    }
    print(json.dumps(output))


if __name__ == "__main__":
    main()
