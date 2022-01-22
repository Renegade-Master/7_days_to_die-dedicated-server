#!/usr/bin/env python3

"""
Author: Renegade-Master
Description:
    Script for editing the 7 Days to Die Dedicated Server configuration file
"""
import sys
import xml.etree.ElementTree as ET


def save_config(config: dict, config_file: str) -> None:
    """
    Saves the server config file
    :param config: Dictionary of the values
    :param config_file: Path to the server config file
    :return: None
    """

    # Read in the current config file
    with open(config_file, "r") as file:
        tree = ET.parse(file)
        root = tree.getroot()

    # Overwrite the file value with the new value
    with open(config_file, "w") as file:
        for property in root:
            if property.attrib['name'] in config:
                property.attrib['value'] = config[property.attrib['name']]

        # Write the new config file
        file.write(ET.tostring(root, encoding='unicode', method='xml'))


def load_config(config_file: str) -> dict:
    """
    Loads the server config file
    :param config_file: Path to the server config file
    :return: Dictionary of the values
    """

    config: dict = {}
    with open(config_file, "r") as file:
        tree = ET.parse(file)
        root = tree.getroot()

        for property in root:
            config[property.attrib['name']] = property.attrib['value']

    return config


def check_server_config_file(config_file: str) -> bool:
    """
    Checks if the server config file exists
    :param config_file: Path to the server config file
    :return: True if the file exists, False if not
    """

    try:
        with open(config_file, "r") as file:
            return True
    except FileNotFoundError:
        sys.stderr.write(f"{config_file} not found!\n")
        return False


if __name__ == "__main__":
    if len(sys.argv) < 3 or len(sys.argv) > 4:
        print("Usage: edit_server_config.py <config_file> <key> [<value>]")
        sys.exit(1)

    config_file: str = sys.argv[1]
    key: str = sys.argv[2]

    if check_server_config_file(config_file):
        config: dict = load_config(config_file)

        if len(sys.argv) == 3:
            # Return the value of the given key
            print(f"{config[key]}")
        else:
            # Assign a new value
            value: str = sys.argv[3]

            # Set the desired value
            config[key] = value

            # Save the config file
            save_config(config, config_file)
