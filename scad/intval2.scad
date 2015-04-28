include <../readyCAD/ready.scad>

mm_x = [54.5 + 6, -30 + 54.5, 6, 45.5, 18, 55, 55];
mm_y = [-30 + 12, 7 + 12, -27.5, -27.5, 7, 40, 40];

//xArray = [-3, 57,  55,  10, -26]; //WITH MIDDLE PIN
//yArray = [38, 31, -56, -22, -33]; //WITH MIDDLE PIN
xArray = [-3, 57,  55,  -26]; //NO MIDDLE PIN
yArray = [38, 31, -56,  -33]; //NO MIDDLE PIN

outerD = 9;
innerD = 4.5;
height = 17;

//panel_x = 129 + 4;
//panel_y = 131;
panel_2_x = 110;
panel_2_y = 110;

one_to_one_x = 54.5;
one_to_one_y = 12;

bolt_inner = 2.7;

module intval_panel () {
	difference () {
		union () {
			difference () {
				translate ([0, 0, 8.5]) {
					union () {
						translate([22, -5, 0]) rotate([0, 0, -13]) rounded_cube([panel_2_x, panel_2_y, 2], d = 20, c = true);
						//reinforces
						translate([54, -12, -3]) rotate([0, 0, 89]) rounded_cube([110, 20, 4], 20, c = true);
						translate([-17, 2, -3]) rotate([0, 0, 72]) rounded_cube([94, 13, 4], 13, c = true);
					}
				}
				for (i = [0 : len(xArray) - 1]) {
					bolex_pin_inner(xArray[i], yArray[i]);
				}
			}
			onetoone(26, 10, 4.5);
			//extends for onetoone
			intval_pins();
			for (i = [0 : len(mm_x) - 1]) {
				translate([mm_x[i], mm_y[i], 6]) cylinder(r = 4, h = 5, center = true);
			}

		}
		onetoone(9, 14, 8.5);
		bearing(54.5, 12, 6, width= 18, hole=false);
		frame_counter_access();
		m_p_access();
		//remove center
		difference () {
			//translate([19, -5, 0]) cube([60, 60, 60], center=true);
			//translate([49, 0, 0]) rotate([0, 0, -165]) cube([30, 90, 60], center=true);
		}
		//remove front
		remove_front();
		//opto
		//opto_mount_holes(42, 29.5, 20, 5.4);
		translate([6, 18, 0]) rotate([0, 0, -13]) cube([15, 25, 40], center=true); //motor wind key hole

		for (i = [0 : len(mm_x) - 1]) {
			translate([mm_x[i], mm_y[i], 0]) cylinder(r = bolt_inner, h = 100, center = true);
		}
	}
}
module remove_front () {

	translate([87, 0, 4]) rotate([0, 0, 89]) cube([170, 40, 40], center = true);
}
module onetoone (size, height, z) {
	translate ([one_to_one_x, one_to_one_y, z]) {
		cylinder(r = size / 2, h = height, center = true);
	}
}
module m_p_access () {
	translate ([18, -44, 0]) {
		rounded_cube([35, 17, 50], 17, true);
	}
}
module bolex_pin (x, y) {
	in = innerD;
	translate ([x, y, 1]) {
		difference () {
			union () {
				translate([0, 0, (height / 2) - 2]) cylinder(r = (outerD + 4) / 2, h = 4, center = true);
				cylinder(r = outerD / 2, h = height, center = true);
			}
			cylinder(r = in / 2, h = height, center = true);
			translate([0, 0, (height / 2) - 1]) cylinder(r1 =4.5 / 2, r2 = 6.5 / 2, h = 2, center = true);
		}
	}
}
module bolex_pin_inner (x, y) {
	translate ([x, y, 1]) {
		cylinder(r = innerD / 2, h = height * 2, center = true);
		translate([0, 0, (height / 2) - 1]) cylinder(r1 =4.5 / 2, r2 = 6.5 / 2, h = 2, center = true);
	}
}
module intval_pins () {
	for (i = [0 : len(xArray) - 1]) {
		bolex_pin(xArray[i], yArray[i]);
	}
}
module key () {
	difference () {
		cylinder(r = 6.7 / 2, h = 5, center = true, $fn = 15);
		cylinder(r = 4.76 / 2, h = 5, center = true, $fn = 15);
	}
	translate ([0, 0, -7.5]) {
		cylinder(r = 6.7 / 2, h = 10, center = true, $fn = 15);
	}
}
module keyHole () {
	translate ([0, 0, 1.75]) {
		cube([10, 2, 3.5], center = true);
	}
}
module key_end (rotArr = [0, 0, 0], transArr = [0, 0, 0]) {
	translate(transArr) {
		rotate (rotArr) {
			difference () {
				key();
				keyHole();
			}
		}
	}
}
module frame_counter_access () {
	x = 37.5;
	y = 39;
	translate([x, y, 8.5]) {
		difference () {
			union () {
				rotate ([0, 0, 19]) {
					translate([0, 9, 0]) {
						cube([12, 16, 4], center = true);
					}
				}
				rotate ([0, 0, -19]) {
					translate([0, 9, 0]) {
						cube([12, 16, 4], center = true);
					}
				}
			}
			translate([0, 15.5, 0]) {
				cube([17, 6, 4], center = true);
			}
		}
		cylinder(r = 6.2, h = 4, center = true);
	}
}
module bearing (x, y, z, width= 8, hole = true) {
	innerD = 8.05;
	outerD = 22.1;
	fuzz = 0.1;
	translate ([x, y, z]) {
		difference () {
			cylinder(r = outerD / 2 + fuzz, h = width, center = true);
			if (hole) {
				cylinder(r = innerD / 2 - fuzz, h = width, center = true);
			}
		}
	}
}
module motor_key (half = false) {
	innerD = 7.85;	
	outer_d = 27.5 + 2;
	notch_d = 10;
	height = 7 + 5;
	diff = 14 + 2.5;
	difference () {
		union () {
			translate([one_to_one_x, one_to_one_y, 12.1]) cylinder(r = 12 / 2, h = 5, center = true);// padding against bearing
			translate([one_to_one_x, one_to_one_y, diff]) cylinder(r=outer_d/2, h= height, center= true); //large cylinder
			translate([one_to_one_x, one_to_one_y, 6]) cylinder(r=innerD/2, h= 10, center= true , $fn= 10);
			key_end([0, 180, 0], [one_to_one_x, one_to_one_y, -2.5]); //thicker-than-key_end cylinder for inner bearing
		}
		translate([one_to_one_x, one_to_one_y, diff]) {
			translate ([-outer_d/2 - 2.5, 0, 0]) cylinder(r=notch_d/2, h= height, center= true, $fn=30); //notch
		}
		translate([one_to_one_x, one_to_one_y, diff]) {
			translate ([-outer_d/2  -.5, -3.5, 0]) rotate([0, 0, 100]) cube([15, 5, height], center = true); // smooth notch
			translate ([-outer_d/2  -.5, 3.5, 0]) rotate([0, 0, -100]) cube([15, 5, height], center = true); // smooth notch
		}
		//slot for hobbled(?) end
		translate([one_to_one_x, one_to_one_y, 20.5]) cylinder(r = 11.5/2, h = 10, center = true);
		translate([one_to_one_x, one_to_one_y, 17.5]) {
			difference() {
				//cylinder(r = 7.5/2, h = 2, center = true);
				//translate([5, 0, 0]) cube([10, 10, 10], center = true);
			}
		}
		if (half) {
			translate([one_to_one_x - 50 , one_to_one_y, -50]) cube([100, 100, 200]);
		}
	}
}
module motor_12v () {
	motor_d = 37;
	motor_h = 63;
	end = 11.5;
	len = 17;
	cylinder(r = motor_d/2, h = motor_h, center=true);
	translate([0, 0, (motor_h / 2) + (len / 2)]) cylinder(r = end/2, h = len, center=true);
}
module motor_mount () {
	base_d = 45;
	base_inner = 39;
	base_thickness = 3;
	hole_d = 13.5;
	screw_d = 5;
	height = 6;
	difference () {
		difference () {
			translate([0, 0, 2.5])cylinder(r=base_d/2, h=height + 5, center = true);
			translate([0, 0, base_thickness + 2.5]) cylinder(r=base_inner/2, h=height + 5, center = true);
		}

		cylinder(r=hole_d/2, h=29, center = true); //center hole
		
		//screw mounts
		translate([0, 12.5, 0]) cylinder(r=screw_d/2, h=29, center = true); 	
		translate([0, -12.5, 0]) cylinder(r=screw_d/2, h=29, center = true);
		//translate([10.5, 0, 0]) cylinder(r=screw_d/2, h=29, center = true); 
		//translate([0, 0, -10]) cube([100, 100, 100]);	 
	}
	//wings
	//translate([-18, 0, 0]) cube([6, 4, 4], center= true);
	translate ([-one_to_one_x, -one_to_one_y, 0]) bolt_holder([mm_x[0], mm_y[0], 0], 100, height, 9);
	translate ([-one_to_one_x, -one_to_one_y, 0]) bolt_holder([mm_x[1], mm_y[1], 0], -10, height, 11);
}

module geared_motor_mount () {
	base_d = 45;
	base_inner = 39;
	base_thickness = 3;
	hole_d = 12.5;
	screw_d = 4;
	screw_distance = 31;
	height = 6;
	difference () {
		difference () {
			translate([0, 0, 2.5])cylinder(r=base_d/2, h=height + 5, center = true);
			translate([0, 0, base_thickness + 2.5]) cylinder(r=base_inner/2, h=height + 5, center = true);
		}

		cylinder(r=hole_d/2, h=29, center = true); //center hole
		
		//screw holes
		translate([0, screw_distance/2, 0]) cylinder(r=screw_d/2, h=29, center = true); 	
		translate([0, -screw_distance/2, 0]) cylinder(r=screw_d/2, h=29, center = true);
		//translate([10.5, 0, 0]) cylinder(r=screw_d/2, h=29, center = true); 
		//translate([0, 0, -10]) cube([100, 100, 100]);	 
	}
	//wings
	//translate([-18, 0, 0]) cube([6, 4, 4], center= true);
	translate ([-one_to_one_x, -one_to_one_y, 0]) bolt_holder([mm_x[0], mm_y[0], 0], 100, height, 9);
	translate ([-one_to_one_x, -one_to_one_y, 0]) bolt_holder([mm_x[1], mm_y[1], 0], -10, height, 11);
}

module motor_mount_bottom () {
	mount_d = 45.5;
	base_d = 45.5;
	outer_d = 28 + 2.3 + 4;
	height = 19 + 3.5 + 4;
	bolt_h = 22.3;
	shelf_h = 6; //match to motor_mount

	module motor_mount_core () {
		translate ([one_to_one_x, one_to_one_y, (height / 2 ) + 5.75]) {
			difference() {
				cylinder(r = mount_d / 2, h = height, center = true); //main block

				translate([0, 0, (height / 2) - (shelf_h / 2)]) cylinder(r = base_d / 2, h = shelf_h, center = true); //shelf for motor_mount
				cylinder(r = outer_d / 2, h = 50, center = true); //space for spinning
				translate ([-one_to_one_x, -one_to_one_y, 0]) remove_front(); //flatten side 
				translate([-32, -17, -19]) cube([40, 40, 40], center= true); //hole for notch
				translate([-42, 0, -19]) rotate([0, 0, -39]) cube([40, 40, 40], center= true); //hole for notch
				translate([2.5, 19.5, 0]) cylinder(r=9/2, h = 60, center=true); // hole for panel bolt
				//wings negative
				//translate ([-one_to_one_x, -one_to_one_y, 0]) bolt_holder([mm_x[0], mm_y[0], (height / 2) - (shelf_h / 2)], 100, shelf_h, 10, false);
				//translate ([-one_to_one_x, -one_to_one_y, 0]) bolt_holder([mm_x[1], mm_y[1], (height / 2) - (shelf_h / 2)], -42, shelf_h, 10, false);
			}
			translate ([-one_to_one_x, -one_to_one_y, 0]) bolt_holder([mm_x[0], mm_y[0], -shelf_h / 2], 100, height - shelf_h, 9);
			translate ([-one_to_one_x, -one_to_one_y, 0]) bolt_holder([mm_x[1] , mm_y[1], -shelf_h / 2], -10, height - shelf_h, 11);
			translate ([-one_to_one_x, -one_to_one_y, 0]) bolt_holder([mm_x[5] , mm_y[5], -shelf_h / 2], -90, height - shelf_h, 11);
		}
	}

	module microswitch_holder () {
		difference () {
			translate([29, -1, 14]) cube([36, 65, height - shelf_h - 4], center = true);//Base shape
			translate ([25.5, -14, 15]) {
				cube([17, 28, 39.5], center = true); //rectangle hole for center
				translate([4.5, 5.6, 0]) rotate([0, 0, -23]) cube([17, 25, 39.5], center = true); //bottom right inner
				translate([-2, -18, -3.5]) cube([7, 11, 12], center = true); // hole for bottom pins
				translate([-9.5, -1, -3.5]) cube([30, 4, 12], center = true); //hole for side pin
			}
			translate ([14, 37.5, 15]) rotate([0, 0, 44]) cube([55, 30, 30], center= true); //top left outer
			translate ([one_to_one_x, one_to_one_y, 18]) {
				cylinder(r = outer_d / 2, h = 50, center = true); //space for spinning
			}
			translate ([32, 6, 15]) {
				difference () {
					translate([3, 0, 0]) rotate([0, 0, 0]) cube([20, 25, 39.5], center = true); //removes area for microswitch arm
					translate([-2, 16, 0]) rotate([0, 0, -55]) cube([20, 50, 39.5], center = true);
				}
			}
			translate ([58, -25, 15]) {
				rotate([0, 0, 75]) cube([45, 30, 30], center= true); //bottom right outer
			}
			translate([mm_x[4], mm_y[4], 0]) cylinder(r = 6/2, h = 100, center = true); // extra bolt hole
			translate([mm_x[1], mm_y[1], 0]) cylinder(r = 4, h = 100, center = true); //clear out top left bolt hole
		}
	}

	module top_addition () {

	}
	motor_mount_core();
	microswitch_holder();	
	bolt_holder([mm_x[2], mm_y[2], ((height - shelf_h)/ 2) + 3.75], 0, height - shelf_h - 4, 6); //bottom left mount
	bolt_holder([mm_x[3], mm_y[3], ((height - shelf_h)/ 2) + 3.75], 180, height - shelf_h - 4, 6); //bottom right mount
	//microswitch([25.5, -14, 15]);
}
module bolt_holder (position = [0, 0, 0], rotate_z = 0, h = 17, length = 4.5, hole = true) {
	bolt_r = 6;
	translate (position) {
		difference () {
			union() {
				cylinder(r = bolt_r + 0, h = h, center = true);
				rotate([0, 0, rotate_z]) translate([length/2, 0, 0]) cube([length, bolt_r * 2, h], center=true);
			}
			if (hole) {
				cylinder(r = bolt_inner, h = h + 2, center = true);
			}
		}
	}
}
module microswitch (position = [0, 0, 0], rotation = [0, 0, 0]) {
	translate(position) {
		rotate(rotation) {
			cube([16, 28, 9.5], center = true);
			translate([10, 8, 0]) rotate([0, 0, -7]) cube([1, 28, 4], center = true);
			translate([8 + 7, 14 + 8, 0]) cylinder(r = 2.5, h = 4, center = true);
			translate([0, -19, 0]) cube([6, 11, 9.5], center = true);
		}
	}
}

module l289N_mount() {
	DISTANCE = 38;
	H = 8;

	module stand () {
		difference () {
			cylinder(r1 = 5, r2 = 4, h = H, center = true);
			cylinder(r = 2, h = H, center = true);
		}
	}
	translate([0, 0, 0]) stand();
	translate([DISTANCE, 0, 0]) stand();
	translate([DISTANCE, DISTANCE, 0]) stand();
	translate([0, DISTANCE, 0]) stand();
	translate([DISTANCE/2, DISTANCE/2, -4]) rounded_cube([DISTANCE + 15, DISTANCE + 15, 4], 15, center = true);
}

module pcb_mount() {
	DISTANCE_X = 41;
	DISTANCE_Y = 66;
	OUTER = 10;
	H = 8;

	module stand () {
		difference () {
			cylinder(r1 = 5, r2 = 4, h = H, center = true);
			cylinder(r = 1.75, h = H, center = true);
		}
	}
	translate([0, 0, 0]) stand();
	translate([DISTANCE_X, 0, 0]) stand();
	translate([DISTANCE_X, DISTANCE_Y, 0]) stand();
	translate([0, DISTANCE_Y, 0]) stand();
	translate([DISTANCE_X/2, DISTANCE_Y/2, -4]) rounded_cube([DISTANCE_X + OUTER, DISTANCE_Y + OUTER, 4], OUTER, center = true);
}

//l289N_mount();
//pcb_mount();
//motor_mount();
geared_motor_mount();
//motor_key();
//intval_panel();
//bearing (one_to_one_x, one_to_one_y, 5.5);
//difference () {
	//translate([one_to_one_x, one_to_one_y, 31]) motor_mount();
	//translate([one_to_one_x, one_to_one_y, 0]) cube([200, 200, 200]);
//}
//motor_mount_bottom();

//translate([one_to_one_x, one_to_one_y, 63]) rotate([0, 180, 0]) motor_12v();