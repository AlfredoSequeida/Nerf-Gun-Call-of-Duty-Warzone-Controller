from subprocess import Popen, PIPE
import json
import socket

import RPi.GPIO as GPIO

GPIO.setwarnings(False)
GPIO.setmode(GPIO.BOARD)

SERVER_IP = ""
SERVER_PORT = 65432

PIN_KEY_BINDINGS = {
    7: "shift+w",
    8: "shift+a",
    10: "shift+s",
    11: "shift+d",
    12: "f",
    13: "e",
    15: "1",
    16: "q",
    18: "x",
    19: "space",
    21: "left mouse",
    22: "right mouse",
    23: "BM",
    24: "TM",
    26: "r",
    # 28: "blank",
}


def gpio_setup():
    """
    setup GPIO pins input
    """

    for key, value in PIN_KEY_BINDINGS.items():
        GPIO.setup(key, GPIO.IN, pull_up_down=GPIO.PUD_DOWN)


def get_keys_status() -> dict:
    """
    Get the current status of the GPIO inputs, to tell us which buttons are
    being pressed
    """
    keys = {}

    for key, value in PIN_KEY_BINDINGS.items():
        # with the current circuit configuration, the trigger button is always
        # on (receving current) by default, so to keep the logic of the program
        # we are negating the input value so that on == off and off == on
        if value == "left mouse":
            keys[value] = int(not GPIO.input(key))
        else:
            keys[value] = GPIO.input(key)

    return keys


def main():
    process = Popen(
        ["adb", "shell", "logcat", "-s", "'nerfgyro'", "-v", "raw"],
        stdout=PIPE,
    )

    clientsocket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    clientsocket.connect((SERVER_IP, SERVER_PORT))

    gpio_setup()

    while True:
        mouse = {}

        # logcat has an initial setup where it outputs unecessary information
        # for our purpouses, so the fetching of the accelerometer data is
        # enclosed in a try/except statement to avoid parsing of that initial
        # setup from breaking the program
        try:
            x, y, z = (
                process.stdout.readline()
                .decode("utf-8")
                .replace(" ", "")
                .replace("\n", "")
                .split(",")
            )

            # the orientation of the phone will change the x,y,z coordinates
            # for example, the following configuration is for a phone in
            # landscape orientation where the x axis is equivalent to the z
            # axis.
            mouse = {"x": z, "y": y}
        except:
            pass

        clientsocket.send(
            bytes(
                json.dumps({"keyboard": get_keys_status(), "mouse": mouse}),
                "utf-8",
            )
        )

        recv = clientsocket.recv(1024)


if __name__ == "__main__":
    main()