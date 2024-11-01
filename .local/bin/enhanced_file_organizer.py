import argparse
import datetime
import hashlib
import logging
import os
import shutil
import zipfile
from pathlib import Path
from tkinter import Button, Label, Tk, filedialog

import yaml


def load_config():
    script_dir = os.path.dirname(os.path.abspath(__file__))
    config_path = os.path.join(script_dir, "config.yaml")
    with open(config_path, "r") as f:
        return yaml.safe_load(f)


config = load_config()

# Configurar logging
logging.basicConfig(
    filename=config["LOGGING"]["file"],
    level=getattr(logging, config["LOGGING"]["level"]),
    format="%(asctime)s - %(message)s",
    datefmt="%d-%b-%y %H:%M:%S",
)


def organize_files(directory, dry_run=False):
    directory = Path(directory)
    for file in directory.iterdir():
        if file.is_file():
            file_type = get_file_type(file)
            destination = directory / file_type
            if not dry_run:
                move_file(file, destination)
            else:
                print(f"Would move {file} to {destination}")


def get_file_type(file):
    extension = file.suffix.lower()
    for file_type, extensions in config["FILE_TYPES"].items():
        if extension in extensions:
            return file_type
    return "others"


def move_file(file, destination):
    destination.mkdir(exist_ok=True)
    new_name = (
        clean_filename(file.name) if config["CLEAN_FILENAMES"]["enabled"] else file.name
    )
    shutil.move(str(file), str(destination / new_name))
    logging.info(f"Moved {file.name} to {destination}")


def clean_filename(filename):
    if not config["CLEAN_FILENAMES"]["enabled"]:
        return filename

    clean_name = filename
    if config["CLEAN_FILENAMES"]["replace_spaces"]:
        clean_name = clean_name.replace(" ", "_")
    if config["CLEAN_FILENAMES"]["remove_special_chars"]:
        clean_name = "".join(c for c in clean_name if c.isalnum() or c in "._-")
    clean_name = clean_name[: config["CLEAN_FILENAMES"]["max_length"]]
    return clean_name.strip()


def archive_old_files(directory, dry_run=False):
    if not config["ARCHIVE"]["enabled"]:
        return

    directory = Path(directory)
    archive_dir = directory / "archived"
    archive_dir.mkdir(exist_ok=True)

    days_old = config["ARCHIVE"]["days_old"]
    threshold = datetime.datetime.now() - datetime.timedelta(days=days_old)

    for file in directory.rglob("*"):
        if file.is_file() and file.stat().st_mtime < threshold.timestamp():
            file_type = get_file_type(file)
            if file_type not in config["ARCHIVE"]["exclude_types"]:
                relative_path = file.relative_to(directory)
                destination = archive_dir / relative_path
                if not dry_run:
                    destination.parent.mkdir(parents=True, exist_ok=True)
                    shutil.move(str(file), str(destination))
                    logging.info(f"Archived {file.name} to {destination}")
                else:
                    print(f"Would archive {file} to {destination}")


def compress_large_files(directory, dry_run=False):
    if not config["COMPRESS"]["enabled"]:
        return

    directory = Path(directory)
    size_threshold = config["COMPRESS"]["size_threshold_mb"] * 1024 * 1024
    for file in directory.rglob("*"):
        if file.is_file() and file.stat().st_size > size_threshold:
            file_type = get_file_type(file)
            if file_type not in config["COMPRESS"]["exclude_types"]:
                zip_file = file.with_suffix(".zip")
                if not dry_run:
                    with zipfile.ZipFile(zip_file, "w", zipfile.ZIP_DEFLATED) as zipf:
                        zipf.write(file, file.name)
                    file.unlink()
                    logging.info(f"Compressed {file.name} to {zip_file.name}")
                else:
                    print(f"Would compress {file} to {zip_file}")


def generate_report(directory):
    directory = Path(directory)
    report = f"File Organization Report for {directory}\n"
    report += "=" * 50 + "\n"

    total_files = 0
    total_size = 0

    for file_type in config["FILE_TYPES"].keys():
        type_dir = directory / file_type
        if type_dir.exists():
            files = list(type_dir.iterdir())
            count = len(files)
            size = sum(f.stat().st_size for f in files if f.is_file())
            total_files += count
            total_size += size
            report += f"{file_type.capitalize()}: {count} files, {size / (1024 * 1024):.2f} MB\n"

    archive_dir = directory / "archived"
    if archive_dir.exists():
        archived_files = list(archive_dir.rglob("*"))
        count = sum(1 for _ in archived_files if _.is_file())
        size = sum(f.stat().st_size for f in archived_files if f.is_file())
        total_files += count
        total_size += size
        report += f"Archived: {count} files, {size / (1024 * 1024):.2f} MB\n"

    report += f"\nTotal: {total_files} files, {total_size / (1024 * 1024):.2f} MB\n"

    with open(directory / "organization_report.txt", "w") as f:
        f.write(report)
    logging.info("Generated organization report")
    return report


def detect_duplicates(directory):
    if not config["DUPLICATES"]["enabled"]:
        return

    hashes = {}
    for file in Path(directory).rglob("*"):
        if file.is_file():
            file_hash = hashlib.md5(file.read_bytes()).hexdigest()
            if file_hash in hashes:
                print(f"Duplicate found: {file} is identical to {hashes[file_hash]}")
                if config["DUPLICATES"]["action"] == "delete_newer":
                    if file.stat().st_mtime > hashes[file_hash].stat().st_mtime:
                        file.unlink()
                        print(f"Deleted newer duplicate: {file}")
                    else:
                        hashes[file_hash].unlink()
                        print(f"Deleted newer duplicate: {hashes[file_hash]}")
                        hashes[file_hash] = file
                elif config["DUPLICATES"]["action"] == "delete_older":
                    if file.stat().st_mtime < hashes[file_hash].stat().st_mtime:
                        file.unlink()
                        print(f"Deleted older duplicate: {file}")
                    else:
                        hashes[file_hash].unlink()
                        print(f"Deleted older duplicate: {hashes[file_hash]}")
                        hashes[file_hash] = file
            else:
                hashes[file_hash] = file


def create_gui():
    if not config["GUI"]["enabled"]:
        return

    root = Tk()
    root.title("File Organizer")

    def select_directory():
        directory = filedialog.askdirectory()
        if directory:
            organize_files(directory)
            archive_old_files(directory)
            compress_large_files(directory)
            detect_duplicates(directory)
            report = generate_report(directory)
            result_label.config(text="Organization complete!\n" + report)

    Label(root, text="Click the button to select a directory to organize:").pack(
        pady=10
    )
    Button(root, text="Select Directory", command=select_directory).pack(pady=10)
    result_label = Label(root, text="")
    result_label.pack(pady=10)

    root.mainloop()


def main():
    parser = argparse.ArgumentParser(
        description="Organize files in specified directories."
    )
    parser.add_argument(
        "directories",
        nargs="*",
        default=config["DEFAULT_DIRECTORIES"],
        help="Directories to organize",
    )
    parser.add_argument(
        "--dry-run",
        action="store_true",
        help="Show what would be done without making changes",
    )
    parser.add_argument(
        "--gui", action="store_true", help="Launch graphical user interface"
    )
    args = parser.parse_args()

    if args.gui or config["GUI"]["enabled"]:
        create_gui()
    else:
        for directory in args.directories:
            logging.info(f"Starting organization for {directory}")
            organize_files(directory, args.dry_run)
            archive_old_files(directory, args.dry_run)
            compress_large_files(directory, args.dry_run)
            detect_duplicates(directory)
            report = generate_report(directory)
            print(report)
            logging.info(f"Finished organization for {directory}")


if __name__ == "__main__":
    main()
