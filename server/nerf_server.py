import socket
import json
import pydirectinput

pydirectinput.FAILSAFE = False

HOST = ""
PORT = 65432

SENSITIVITY_X = 5
SENSITIVITY_Y = 5


def activate_key(k: str):
    """
    press key
    k: key to pess
    """
    if "left mouse" == k:
        pydirectinput.mouseDown()
    elif "right mouse" == k:
        pydirectinput.mouseDown(button="right")
    elif "+" in k:
        key, mod = k.split("+")
        pydirectinput.keyDown(key)
        pydirectinput.keyDown(mod)
    else:
        pydirectinput.keyDown(k)


def deactivate_key(k: str):
    """
    stop pressing key
    k: key to stop pessing
    """
    if "left mouse" == k:
        pydirectinput.mouseUp()
    elif "right mouse" == k:
        pydirectinput.mouseUp(button="right")
    elif "+" in k:
        key, mod = k.split("+")
        pydirectinput.keyUp(key)
        pydirectinput.keyUp(mod)
    else:
        pydirectinput.keyUp(k)


with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
    s.bind((HOST, PORT))
    s.listen()
    conn, addr = s.accept()
    with conn:
        print("Connected", addr)
        key_status = {"right mouse": 0, "left mouse": 0}

        while True:
            data = conn.recv(1024)

            try:
                decoded_data = json.loads(data.decode("utf-8"))

                recv_key_status = decoded_data.get("keyboard", None)
                mouse = decoded_data.get("mouse", None)

                if recv_key_status:
                    # key -> keys sent
                    # value -> active status T/F
                    for key, status in recv_key_status.items():
                        if status == key_status.get(key, None):
                            # key action already performed
                            pass
                        else:
                            # need to perform action
                            if status:
                                activate_key(key)
                            else:
                                deactivate_key(key)

                    # update key status
                    key_status.update(recv_key_status)

                if mouse:
                    pydirectinput.moveRel(
                        -int(float(mouse["x"])) * SENSITIVITY_X,
                        -int(float(mouse["y"])) * SENSITIVITY_Y,
                        relative=True,
                        _pause=False,
                    )
            except:
                pass

            if not data:
                break

            conn.sendall(data)