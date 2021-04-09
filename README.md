# Nerf Gun Call of Duty Warzone Controller (NGCDWC)

[Watch the video for this project here](https://youtu.be/ld0Pcy6F-3g)

I had the idea of using a nerf gun as a controller to play Call of Duty Warzone, but since it's just a controller, it can work for any game with the rebinding of the keys. This repo contains all the files for the client and server, the android app used to get accelerometer data, and the 3D models for the buttons, buttons assembly, and other components.

## Setup
Python 3.5 or newer required.

### Client
The client is meant to be used on a Rasberry Pi. Before running it, you must install the dependencies. This can be done using the included setup.sh script:
```
sudo sh setup.sh
```
Then set up the script by setting the `SERVER_IP` in `nerf_client.py`

### Server
The server runs on the machine running the game to setup install the python dependencies use pip

```
py -m pip install -r requirements.py
```
Then set up the script by setting the `HOST` IP in `nerf_server.py`


## Buttons
Buttons are designed to have a lead at the top and bottom components of a button. When I built it, I used aluminum foil to provide those contacts with a spring in between both components so the button rises back up.

The buttons should then be fed a voltage. In my case, I used the 3.3V source from the raspberry pi's GPIO pins. The other end of the lead is then connected to a GPIO pin that is used as an input. When these two leads make contact, the button will be registered as ON by the client python script.

## The Android App
The android app is used to get accelerometer information from an android phone, which is used to move the mouse pointer for in-game aiming. You can build the app using Android Studio.