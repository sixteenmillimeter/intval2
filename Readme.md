# INTVAL 2.0
##### Intervalometer for Bolex 16mm Cameras
----

 1. [Overview](#Overview)
 2. [Attachment](#Attachment)
 3. [Usage](#Usage)
 4. [Power](#Power)
 5. [Maintainance](#Maintainance)
 6. [Assembly](#Assembly)

----
### 1) <a name="Overview"></a>Overview 

The INTVAL 2.0 is an open-source/hardware intervalometer for Bolex 
16mm cameras. It enables you to expose single frames of film
at a regulated interval. Utilizing the 1:1 shaft in Bolex cameras (Rex
3 and later models) the INTVAL 2.0 can complete a full rotation of the shutter
in either 1 or 2 seconds. This allows for a range of long exposure options when
used in conjuncture with the Rexofader.

----
### 2) <a name="Attachment"></a>Attachment

To attach the INTVAL 2.0 to a Bolex camera, disable the motor and line up the four standoffs
with the mounting holes on the body of the camera and insert the key into the 1:1 shaft. 
This can be done by laying the camera on its side--with the mounting holes facing up--and placing the INTVAL 2.0 on top of the body and making sure the key fits into the slotted 1:1 opening.
If you have never attached anything to the mounts before, you may have to 
remove small screws that are in the holes. This opens up the mounting holes for 
the screws that will hold the intervalometer in place. There are four standoffs
and screws, but only three need to be attached to maintain the hold required for operation.

----
### 3) <a name="Usage">Usage

The INTVAL 2.0 has two physical interfaces: the buttons on the case and the shutter
release cable. The shutter release cable plugs into the underside of the case, next
to the DC adapter, and triggers the camera. A single, short press will trigger a ``single
frame``. Holding down the shutter release for more than 1 second will start a ``continuous sequence``
of frames. Hitting the shutter release during a running sequence will stop the intervalometer.

The buttons on the case control three variables: direction, speed and delay. The direction of the
camera can be set to ``forwards`` (default) with a quick press, and set to ``backwards`` by holding the
button for more than 1 second. 

Similarly, the speed can be set to ``1 second rotation`` (default) with a
quick press and set to ``2 second rotation`` by holding the button for more than 1 second. Remember,
during the 1 or 2 seconds that the shutter is rotating, exposure only occurs for a fraction of that time. How large a fraction depends on the setting of the Rexofader.

Delay refers to the time the intervalometer pauses between frames and only matters when running a sequence. The delay is set to ``42 ms`` by default and will be set to however long you hold it down for; holding the button for``10 seconds`` will set the delay between each frame to ``10 seconds``. Pressing the button quickly will reset the timer to the default ``42 ms``.

----
### 4) <a name="Power">Power

Power the INTVAL 2.0 with 12VDC to the 2.1mm DC power jack located on the bottom of the case.
The maximum draw of the motor is under 1 Amp, so that much current should be ample to run the
intervalometer. Portable batteries, such as those used as supplimental cellphone power supplies, 
can be used to as mobile power sources, but they must be able to provide 12V and not the typical 5V that many of these batteries provide. Two examples: 

[Anker 2nd Gen Astro Pro2 20000mAh 4-Port Aluminum Portable External Battery Charger with 9V/12V Multi-Voltage Port](http://www.amazon.com/gp/product/B005NGLTZQ/ref=as_li_tl?ie=UTF8&camp=1789&creative=390957&creativeASIN=B005NGLTZQ&linkCode=as2&tag=sixteentools-20&linkId=HXO6TQG5JADIRZCZ)

[ Rechargeable 3800mAh Lithium Ion Battery Pack with DC Connector, 12 volt](http://www.amazon.com/gp/product/B007RQW5WG/ref=as_li_tl?ie=UTF8&camp=1789&creative=390957&creativeASIN=B007RQW5WG&linkCode=as2&tag=sixteentools-20&linkId=JJV427F7SOAMASZV)

----
### 5) <a name="Maintainance">Maintainance

----
### 6) <a name="Assembly">Assembly

All parts of the INTVAL 2.0 are reproducible via 3D printing, laser cutting or purchasable for a total build cost of ~$50. The files in this repository consist of .SCAD, .STL, .DXF and .INO files. The .SCAD files contain all the elements needed to generate the physical body of the intervalometer with .DXF files for
laser cutting and .STL files for 3D printing. The .INO file contains the source code for the Arduino sketch
that powers the INTVAL 2.0.

All of the purchasable parts for this build:

 1. [Arduino Trinket Pro 5V](http://www.amazon.com/gp/product/B0131VM9I0/ref=as_li_tl?ie=UTF8&camp=1789&creative=9325&creativeASIN=B0131VM9I0&linkCode=as2&tag=sixteentools-20&linkId=PK57RTRI2YRJVT2E)
 2. [Nextrox Mini 12V DC 60 RPM High Torque Gear Box Electric Motor](http://www.amazon.com/gp/product/B00BX54O8A/ref=as_li_tl?ie=UTF8&camp=1789&creative=390957&creativeASIN=B00BX54O8A&linkCode=as2&tag=sixteentools-20&linkId=DFU3L54JZ3KQJMPU)
 3. [L298N Motor Drive Controller Board Module Dual H Bridge DC Stepper For Arduino](http://www.amazon.com/gp/product/B014KMHSW6/ref=as_li_tl?ie=UTF8&camp=1789&creative=390957&creativeASIN=B014KMHSW6&linkCode=as2&tag=sixteentools-20&linkId=QZUX2HKYZAL23WGD)
 4. [(5 Pcs) DC 3 Terminals PCB Mount 2.1x5.5mm Jacks Connectors Socket](http://www.amazon.com/gp/product/B00CQMGWIO/ref=as_li_tl?ie=UTF8&camp=1789&creative=390957&creativeASIN=B00CQMGWIO&linkCode=as2&tag=sixteentools-20&linkId=KMF43HLB5IS2CIFO) - need 1
 5. [(10 Pcs) Plastic PCB Mount 5-Pin Stereo 3.5mm Socket Audio Connector]() - need 1
 6. [3.5mm Stereo Audio Cable](http://www.amazon.com/gp/product/B004G3UK5C/ref=as_li_tl?ie=UTF8&camp=1789&creative=390957&creativeASIN=B004G3UK5C&linkCode=as2&tag=sixteentools-20&linkId=RVH32COHMFACT46V)
 7. [(10 Pcs) Mini Push Button Momentary OFF-ON Switch 7mm Black](http://www.amazon.com/gp/product/B00RMGSCPA/ref=as_li_tl?ie=UTF8&camp=1789&creative=390957&creativeASIN=B00RMGSCPA&linkCode=as2&tag=sixteentools-20&linkId=66EL3G5J4ZXONMNK) - need 4

Additionally you'll need wire and solder of your choosing.