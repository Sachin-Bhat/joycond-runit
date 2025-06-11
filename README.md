joycond is a linux daemon which uses the evdev devices provided by hid-nintendo (formerly known as hid-joycon) to implement joycon pairing.

hid-nintendo is currently in review on the linux-input mailing list. The most recent patches are currently found at https://github.com/DanielOgorchock/linux

# Installation
1. clone the repo
2. Install requirements:
   - For Debian/Ubuntu: `sudo apt install libevdev-dev libudev-dev`
   - For Fedora: `sudo dnf install libevdev-devel libudev-devel`
   - For Artix Linux: `sudo pacman -S libevdev libudev`
3. `cmake .`
4. `sudo make install`

The service will be installed as a runit service and will automatically start on boot. The service will automatically restart if it crashes.

## Artix Linux Specific Notes
On Artix Linux, the runit service directory is located at `/etc/runit/runsvdir/current/`. The installation script will automatically create the necessary symlinks.

If you need to manually enable the service:
```bash
sudo ln -sf /usr/lib/joycond/runit/service/joycond /etc/runit/runsvdir/current/
```

# Usage
When a joy-con or pro controller is connected via bluetooth or USB, the player LEDs should start blinking periodically. This signals that the controller is in pairing mode.

For the pro controller, pressing both triggers will "pair" it.

For the pro controller, pressing Plus and Minus will pair it as a virtual controller.
This is useful when using Steam.

With the joy-cons, to use a single contoller alone, hold ZL and L at the same time (ZR and R for the right joy-con). Alternatively, hold both S triggers at once.

To combine two joy-cons into a virtual input device, press a *single* trigger on both of them at the same time. A new uinput device will be created called "Nintendo Switch Combined Joy-Cons".

Rumble support is now functional for the combined joy-con uinput device.

# Service Management
The service is managed by runit. You can control it using the following commands:

- Start the service: `sv up joycond`
- Stop the service: `sv down joycond`
- Check service status: `sv status joycond`
- View service logs: `svlogtail joycond`
