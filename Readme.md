# INTVAL 2.0
##### Intervalometer for Bolex 16mm Cameras
----

 1. Overview
 2. Attachment
 3. Usage
 4. Power
 5. Assembly
 6. Maintainance
 
----
### 1) Overview

The INTVAL 2.0 is an open-source/hardware intervalometer for Bolex 
16mm cameras. It enables you to expose single frames of film
at a regulated interval. Utilizing the 1:1 shaft in Bolex cameras (Rex
3 and later models) the INTVAL 2.0 can complete a full rotation of the shutter
in either 1 or 2 seconds. This allows for a range of long exposure options when
used in conjuncture with the Rexofader.

----
### 2) Attachment

To attach the INTVAL 2.0 to a Bolex camera, disable the motor and line up the four standoffs
with the mounting holes on the body of the camera and insert the key into the 1:1 shaft. 
This can be done by laying the camera on its side--with the mounting holes facing up--and placing the INTVAL 2.0 on top of the body and making sure the key fits into the slotted 1:1 opening.
If you have never attached anything to the mounts before, you may have to 
remove small screws that are in the holes. This opens up the mounting holes for 
the screws that will hold the intervalometer in place. There are four standoffs
and screws, but only three need to be attached to maintain the hold required for operation.

----
### 3) Usage

The INTVAL 2.0 has two physical interfaces: the buttons on the case and the shutter
release cable. The shutter release cable plugs into the underside of the case, next
to the DC adapter, and triggers the camera. A single, short press will trigger a ``single
frame``. Holding down the shutter release for more than 1 second will start a ``continuous sequence``
of frames. Hitting the shutter release during a running sequence will stop the camera.

The buttons on the case control three variables: direction, speed and delay. The camera
direction can be set to ``forward`` (default) with a quick press, and set to ``backwards`` by holding the
button for more than 1 second. Similarly, the speed can be set to ``1 second rotation`` (default) with a
quick press and set to ``2 second rotation`` by holding the button for more than 1 second. Delay refers 
to the time the intervalometer pauses between frames and only matters when running a sequence. The delay is
set to ``42 ms`` by default and will be set to however long you hold it down for; holding the button for``10 seconds`` will set the delay between each frame to ``10 seconds``. Pressing the button quickly will reset
the timer to the default ``42 ms``.

----
### 4) Power

Power the INTVAL 2.0 with 12VDC to the 2.1mm DC power jack located on the bottom of the case.
The maximum draw of the motor is under 1 Amp, so that much current should be ample to run the
intervalometer. Portable batteries, such as those used as supplimental cellphone power supplies, 
can be used to as mobile power sources, they just must be able to provide 12V and not the typical (ex. http://www.anker.com/product/79AN7906-BA).