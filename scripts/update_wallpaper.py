import argparse
import json
import os
import random
import subprocess

from pathlib import Path
from PIL import Image


def get_images(directory):
    image_extensions = {".png", ".jpg", ".jpeg"}
    return [
        f for f in os.listdir(directory) if Path(f).suffix.lower() in image_extensions
    ]


def read_history(history_file):
    if not os.path.exists(history_file):
        return set()
    with open(history_file, "r") as file:
        return set(json.load(file))


def write_history(history_file, history):
    os.makedirs(os.path.dirname(history_file), 644, True)
    with open(history_file, "w") as file:
        json.dump(list(history), file)


def choose_image(images, history):
    # print(images)
    # print(history)
    available_images = list(set(images) - history)
    if not available_images:
        return None
    return random.choice(available_images)


def convert_and_resize_image(input_path, output_path, size=(3840, 2160)):
    """Convert an image to PNG format and resize it."""
    with Image.open(input_path) as img:
        # Convert to RGB if not already in RGB mode
        if img.mode != "RGB":
            img = img.convert("RGB")
        # Resize image
        img = img.resize(size, Image.LANCZOS)
        # Save the image as PNG
        img.save(output_path, format="PNG")


def restart_feh():
    subprocess.run(["pkill", "-f", "feh"])
    
    # Get the current display from environment or detect it
    display = os.environ.get("DISPLAY")
    if not display:
        # Try to find an active X display
        try:
            result = subprocess.run(["ps", "aux"], capture_output=True, text=True)
            for line in result.stdout.split('\n'):
                if 'Xorg' in line or 'X ' in line:
                    if ':0' in line:
                        display = ":0"
                        break
                    elif ':1' in line:
                        display = ":1"
                        break
        except:
            display = ":0"  # fallback
    
    if not display:
        display = ":0"
    
    env = {**os.environ, "DISPLAY": display}
    subprocess.run(
        [
            "feh",
            "--bg-scale",
            "--zoom",
            "fill",
            os.path.expanduser("~/files/wallpapers/today.png"),
        ],
        env=env,
        check=True,
    )


def main(directory, history_file):
    directory = os.path.abspath(directory)

    images = get_images(directory)
    if not images:
        raise RuntimeError("No images found in the directory.")

    history = read_history(history_file)

    if len(history) >= len(images):
        history.clear()

    chosen_image = choose_image(images, history)
    if not chosen_image:
        raise RuntimeError("No images available to choose from.")

    final_image_path = os.path.join(directory, "today.png")

    chosen_image_path = os.path.join(directory, chosen_image)
    convert_and_resize_image(chosen_image_path, final_image_path)
    restart_feh()

    history.add(chosen_image)
    write_history(history_file, history)


if __name__ == "__main__":
    parser = argparse.ArgumentParser(
        description="Randomly choose an image and create a symlink."
    )
    parser.add_argument(
        "-d", "--directory", type=str, help="The directory containing images."
    )
    parser.add_argument(
        "-f",
        "--history_file",
        type=str,
        help="The file to store the history of chosen images.",
    )
    # /home/slnc/files/wallpapers
    # ~/.config/local/.update_wallpaper_history

    args = parser.parse_args()
    main(args.directory, args.history_file)
