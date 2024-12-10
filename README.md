# PaperPiAI - Raspberry Pi Zero generated art e-ink display

## Summary 

Standalone Raspberry Pi Zero 2 running stable diffusion to generate infinite 
pictures on an e-ink display. Default set-up is of flowers in styles that I've found to work particularly well on the Inky Impressions 7.3" 7-colour 
e-ink display.

![Blooming Great!](https://raw.githubusercontent.com/vitoplantamura/OnnxStream/master/assets/paperpiai_examples.jpg)

Each image is unique and takes about 30 minutes to generate. Obviously you can change the list of image subjects and styles to anything you like in the `generate_picture.py` file. 

The display code uses salient feature analysis to crop (landscape or portrait) the 'best' part of the square image that is generated. I mostly works okay. If I knew how to get OnnxStream to generate non-square images that would be far preferable. 

# Install

## System

* Raspberry Pi Zero 2
* Inky Impression 7.3" 7-colour e-ink display
* Picture frame

Works with **Raspbian Bullseye Lite**. A similar set-up ought to work with Bookwork (install inky 2.0 using Pimoroni's instructions) but I had odd slowdowns using Bookwork which I could not resolve.

## System config

###  Increase swapfile size for compilation

Edit **/etc/dphys-swapfile** (e.g. `sudo vim /etc/dphys-swapfile`) and change the value of **CONF_SWAPSIZE** to 256

Then restart swap with `sudo /etc/init.d/dphys-swapfile restart`

### Enable e-ink interfaces

rasp-config and enable SPI interface needed.
rasp-config and enable Ic2 interface needed.

## Install required components

`scripts/install.sh` has all the commands needed to install all the required system packages, python libraries and [OnnxStream](https://github.com/vitoplantamura/OnnxStream) - Stable Diffusion for the Raspberry Pi Zero.
If you are feeling brave then run `scripts/install.sh` in the directory you want to install everything, otherwise run each command manually.

# Generating and displaying

`python generate_picture.py output_dir`

Generates a new image and saves two copies to output_dir. One with a unique name based on the prompt, another as 'output.png' to make it simple to display.

Note that if you install the python packages into a virtual env (as the script above does) then you need to use that python instance, e.g.:

`<install_path>/venv/bin/python <path_to>/generate_picture.py /tmp`

To send to the display use `python display_picture.py <image_name>`. Use the `-p` flag if the display is in portrait mode.

To automate this I make a script that runs these two commands in sequence and put an entry in crontab to call it once a day.



