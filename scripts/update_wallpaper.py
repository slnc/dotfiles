# TODO: clean this up
import argparse

import os
import random
import json
from pathlib import Path
from PIL import Image

def get_images(directory):
    image_extensions = {'.png', '.jpg', '.jpeg'}
    return [f for f in os.listdir(directory) if Path(f).suffix.lower() in image_extensions]

def read_history(history_file):
    if not os.path.exists(history_file):
        return set()
    with open(history_file, 'r') as file:
        return set(json.load(file))

def write_history(history_file, history):
    os.makedirs(os.path.dirname(history_file), 644, True)
    with open(history_file, 'w') as file:
        json.dump(list(history), file)

def choose_image(images, history):
    print(images)
    print(history)
    available_images = list(set(images) - history)
    if not available_images:
        return None
    return random.choice(available_images)


def convert_and_resize_image(input_path, output_path, size=(3840, 2160)):
    """Convert an image to PNG format and resize it."""
    with Image.open(input_path) as img:
        # Convert to RGB if not already in RGB mode
        if img.mode != 'RGB':
            img = img.convert('RGB')
        # Resize image
        img = img.resize(size, Image.LANCZOS)
        # Save the image as PNG
        img.save(output_path, format='PNG')


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

    final_image_path = os.path.join(directory, 'today.png')

    chosen_image_path = os.path.join(directory, chosen_image)
    convert_and_resize_image(chosen_image_path, final_image_path)

    # symlink_path = os.path.join(directory, 'today.png')
    # print(symlink_path)
    # if os.path.exists(symlink_path):
    #     os.remove(symlink_path)
    # os.symlink(os.path.join(directory, chosen_image), symlink_path)

    history.add(chosen_image)
    write_history(history_file, history)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description='Randomly choose an image and create a symlink.')
    parser.add_argument('-d', '--directory', type=str, help='The directory containing images.')
    parser.add_argument('-f', '--history_file', type=str, help='The file to store the history of chosen images.')
    # /home/slnc/files/wallpapers
    # ~/.config/local/.update_wallpaper_history

    args = parser.parse_args()
    main(args.directory, args.history_file)

