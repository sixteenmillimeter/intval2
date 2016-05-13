include <./ready.scad>

mm_x = [61.5, 21.5, 6, 45.5, 18, 39];
mm_y = [-18, 21, -27.5, -27.5, 7, 39];
mm_r = [110, -15, 0, 0, 0, -70];
mm_l = [13, 9, 0, 0, 0, 8];
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

bolt_inner = 2.55;

screw_distance = 31;

module intval_panel () {
	difference () {
		union () {
			difference () {
				translate ([0, 0, 8.5]) {
					union () {
						translate([22, -5, 0]) rotate([0, 0, -13]) rounded_cube([panel_2_x, panel_2_y, 2], d = 20, center = true);
						//reinforces
						translate([54, -12, -3]) rotate([0, 0, 89]) rounded_cube([110, 20, 4], 20, center = true);
						translate([-17, 2, -3]) rotate([0, 0, 72]) rounded_cube([94, 13, 4], 13, center = true);
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
		//frame_counter_access(); //use the space
		m_p_access();
		remove_front();
		translate([6, 18, 0]) rotate([0, 0, -13]) cube([15, 25, 40], center=true); //motor wind key hole

		for (i = [0 : len(mm_x) - 1]) {
			translate([mm_x[i], mm_y[i], 0]) cylinder(r = bolt_inner, h = 100, center = true);
		}
	}
}

module l289N_holes (r = 3/2 - .2) {
    $fn = 60;
    DISTANCE = 36.5;
    H = 50;
    translate([0, 0, 0]) cylinder(r = r, h = H * 5, center = true);
    translate([DISTANCE, 0, 0]) cylinder(r = r, h = H * 5, center = true);
    translate([DISTANCE, DISTANCE, 0]) cylinder(r = r, h = H * 5, center = true);
    translate([0, DISTANCE, 0]) cylinder(r = r, h = H * 5, center = true);
}

module l289N_hole_test () {
    $fn = 40;
    difference () {
        cube([140, 40, 3], center = true);
        cylinder(r = 3/2, h = 50, center = true);
        translate([7, 0, 0]) cylinder(r = 3/2, h = 50, center = true);
        translate([7 * 2, 0, 0]) cylinder(r = 3/2 - .1, h = 50, center = true);
        translate([7 * 3, 0, 0]) cylinder(r = 3/2 - .2, h = 50, center = true);
        translate([7 * 4, 0, 0]) cylinder(r = 3/2 - .3, h = 50, center = true);
    }
}

module intval_panel_laser () {
    $fn = 40;
	difference () {
		union () {
			difference () {
				translate ([0, 0, 8.5]) {
					union () {
						translate([12, -5, 0]) {
                            rotate([0, 0, -13]) {
                                rounded_cube([panel_2_x + 20, panel_2_y, 25.4/8], d = 20, center = true);
                            }
                        }
						//reinforces
						//translate([54, -12, -3]) rotate([0, 0, 89]) rounded_cube([110, 20, 4], 20, center = true);
						//translate([-17, 2, -3]) rotate([0, 0, 72]) rounded_cube([94, 13, 4], 13, center = true);
					}
				}
				for (i = [0 : len(xArray) - 1]) {
					bolex_pin_inner_laser(xArray[i], yArray[i]);
				}
			}
			//onetoone(26, 10, 4.5);
			//extends for onetoone
			

		}
		//onetoone(9, 14, 8.5);
		bearing_laser(54.5, 12, 6, width= 18, hole=false);
        translate([-38, -1, 0]) rotate([0, 0, -13]) l289N_holes();
        //translate ([6, -9, height + 3.5]) cylinder(r = bolt_inner, h = 50, center = true); //cover standoff hole
		//frame_counter_access(); //use the space
		m_p_access();
		remove_front();
		translate([6, 18, 0]) rotate([0, 0, -13]) cube([15, 25, 40], center=true); //motor wind key hole

		for (i = [0 : len(mm_x) - 1]) {
			translate([mm_x[i], mm_y[i], 0]) cylinder(r = bolt_inner, h = 100, center = true);
		}
        intval_laser_panel_cover();
	}
}

module intval_panel_laser_debug () {
    $fn = 40;
	difference () {
		union () {
			difference () {
				translate ([0, 0, 8.5]) {
					union () {
						translate([12 - 32.5, -5 + 9, 0]) {
                            rotate([0, 0, -13]) {
                                rounded_cube([panel_2_x + 20 + 65, panel_2_y, 25.4/8], d = 20, center = true);
                            }
                        }
						//reinforces
						//translate([54, -12, -3]) rotate([0, 0, 89]) rounded_cube([110, 20, 4], 20, center = true);
						//translate([-17, 2, -3]) rotate([0, 0, 72]) rounded_cube([94, 13, 4], 13, center = true);
					}
				}
				for (i = [0 : len(xArray) - 1]) {
					bolex_pin_inner_laser(xArray[i], yArray[i]);
				}
			}
			//onetoone(26, 10, 4.5);
			//extends for onetoone
			

		}
		//onetoone(9, 14, 8.5);
		bearing_laser(54.5, 12, 6, width= 18, hole=false);
        translate([-38, -1, 0]) rotate([0, 0, -13]) l289N_holes();
        //translate ([6, -9, height + 3.5]) cylinder(r = bolt_inner, h = 50, center = true); //cover standoff hole
		//frame_counter_access(); //use the space
		m_p_access();
		remove_front();
		translate([6, 18, 0]) rotate([0, 0, -13]) cube([15, 25, 40], center=true); //motor wind key hole

		for (i = [0 : len(mm_x) - 1]) {
			translate([mm_x[i], mm_y[i], 0]) cylinder(r = bolt_inner, h = 100, center = true);
		}
        intval_laser_panel_cover(DEBUG = true);
        translate ([4, 12, 0]) {
            translate([-51.5, -8.5, 0]) cylinder(r = 2.8/2, h = 100, center = true);
            translate([-51.5 - 66, -8.5 + 15, 0]) cylinder(r = 2.8/2, h = 100, center = true);
            translate([-51.5 + 11.5, -8 + 49, 0]) cylinder(r = 2.8/2, h = 100, center = true);
            translate([-51.5 - 54.5, -8.5 + 49 + 16, 0]) cylinder(r = 2.8/2, h = 100, center = true);
        }
	}
}

module bolex_pin_laser (x, y) {
	in = innerD;
    $fn = 120;
	translate ([x, y, 1]) {
		difference () {
			union () {
				translate([0, 0, (height / 2) - 3]) cylinder(r = (outerD + 5) / 2, h = 2, center = true);
				translate([0, 0, 1.175/2]) cylinder(r = outerD / 2, h = height + 1.175 , center = true);
			}
			cylinder(r = in / 2, h = height * 2, center = true);
			translate([0, 0, (height / 2) - 1.9]) cylinder(r1 =4.5 / 2, r2 = 6.7 / 2, h = 2, center = true);
            translate([0, 0, (height / 2) + 1]) cylinder(r = 6.7 / 2, h = 4, center = true);
		}
	}
}

module intval_laser_standoffs () {
    $fn = 40;
    for (i = [0 : len(xArray) - 1]) {
        bolex_pin_laser(xArray[i], yArray[i]);
	}
}

module intval_laser_standoffs_plate () {
    $fn = 40;
    bolex_pin_laser(0, 0);
    bolex_pin_laser(15, 0);
    bolex_pin_laser(0, 15);
    bolex_pin_laser(15, 15);
    //decoys
    //translate([7, 7, 0]) decoys(23, 5.5, 6);
}

module bolex_pin_inner_laser (x, y) {
    $fn = 40;
    innerD = 6.75;
	translate ([x, y, 1]) {
		cylinder(r = innerD / 2, h = height * 2, center = true);
		//translate([0, 0, (height / 2) - 1]) cylinder(r1 =4.5 / 2, r2 = 6.5 / 2, h = 2, center = true);
	}
}

module bearing_laser (x, y, z, width= 8, hole = true) {
	innerD = 8.05;
	outerD = 22.1 - .4;
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

module intval_laser_panel_cover (LASER = false, DEBUG = false, ALL_RED = false) {
    $fn = 60;
    cover_h = 16 + 3 + 4;
    MATERIAL = 25.4 / 8;

    module top () {
        difference () {
            rotate([0, 0, -13]) {
                rounded_cube([100, panel_2_y, MATERIAL], d = 20, center = true);
            }
            translate([53, 12, 0]) cylinder(r = 30, h = 60, center = true); //hole for motor mount
            translate([22, 20, 0]) cylinder(r = 8, h = 60, center = true); // hole for moto mount bolt holder
            translate([53, 42, 0]) cylinder(r = 15, h = 60, center = true); //removes pointy part
            translate([-44, 8, -(cover_h / 2 ) - MATERIAL - 1])  rotate([0, 0, -13]) rotate([0, 90, 0]) back_side();
            translate([2, 49, -(cover_h / 2 ) - MATERIAL - 1]) rotate([0, 0, -13]) rotate([90, 0, 0]) top_side();
            translate([-22, -45, -(cover_h / 2 ) - MATERIAL - 1]) rotate([0, 0, -13]) rotate([90, 0, 0]) bottom_side();
            for (i = [0 : len(xArray) - 1]) {
                translate([xArray[i], yArray[i], 0]) cylinder(r = 7 / 2, h = height * 20, center = true); //Access for screwdriver
            }
            translate([-13.5, 26, 0]) rotate([0, 0, -13]) cube([28, 24, 60], center = true); //heatsink hole
            translate ([8, -9, height + 3.5]) cylinder(r = bolt_inner - .5, h = 50, center = true); //standoff hole
            
            //buttons
            translate ([-44, -23, 0]) {
                rotate ([0, 0, 90-13]) {
                    if (ALL_RED) {
                        translate([7, -32, 8]) cylinder(r = 3.5, h = 190, center = true);
                        translate([7, -19, 8]) cylinder(r = 3.5, h = 190, center = true);
                    } else {
                        translate([7, -32, 8]) cylinder(r = 3.1, h = 190, center = true);
                        translate([7, -19, 8]) cylinder(r = 3.1, h = 190, center = true);
                    }
                    
                    translate([7, -5, 8]) cylinder(r = 3.5, h = 190, center = true);
                }
            }
        } 
        
    }
    module back_side () {
        difference () {
            translate([0, 1.75, 0]) cube([cover_h + 2 + (MATERIAL * 2) + 1 + 3, panel_2_y - 10, MATERIAL], center = true);
            translate([-13 - 3.1, 20, 0]) cube([MATERIAL, 20, MATERIAL], center = true);
            translate([-13 - 3.1, -20, 0]) cube([MATERIAL, 20, MATERIAL], center = true);
            translate([13 + 3.1, 20, 0]) cube([MATERIAL, 20, MATERIAL], center = true);
            translate([13 + 3.1, -20, 0]) cube([MATERIAL, 20, MATERIAL], center = true);
            translate([10 , -22 ,0]) cube([10, 15, 30], center = true); //access for usb
            translate([0, 50.5, 0]) cube([17.5, MATERIAL, MATERIAL], center = true);
            translate([0, -50.5 + (1.75 / 2) + MATERIAL - 0.25, 0]) cube([17.5, MATERIAL, MATERIAL], center = true);
        }
        
    }
    
    module top_side () {
        difference () {
            translate([-2.5, 0, 0]) cube([ panel_2_x - 41, cover_h + 2 + (MATERIAL * 2) + 1  + 3, MATERIAL], center = true);
            translate([28, -13 - 3.1, 0]) cube([25, MATERIAL, MATERIAL], center = true);
            translate([-28, -13 - 3.1, 0]) cube([25, MATERIAL, MATERIAL], center = true);
            translate([28, 13 + 3.1, 0]) cube([25, MATERIAL, MATERIAL], center = true);
            translate([-28, 13 + 3.1, 0]) cube([25, MATERIAL, MATERIAL], center = true);
            
            translate([-35.5, -13 - 8.1, 0]) cube([MATERIAL, 25, MATERIAL], center = true); //side tabs
            translate([-35.5, 13 + 8.1, 0]) cube([MATERIAL, 25, MATERIAL], center = true); //side tabs
       }

    }
    
   module bottom_side () {
        difference () {
            translate([.25, 0, 0]) cube([ panel_2_x - 39.5, cover_h + 2 + (MATERIAL * 2) + 1  + 3, MATERIAL], center = true);
            translate([25, -13 - 3.1, 0]) cube([25, MATERIAL, MATERIAL], center = true);
            translate([-25, -13 - 3.1, 0]) cube([25, MATERIAL, MATERIAL], center = true);
            translate([30, 13 + 3.1, 0]) cube([25, MATERIAL, MATERIAL], center = true);
            translate([-30, 13 + 3.1, 0]) cube([25, MATERIAL, MATERIAL], center = true);
            translate([-15, 1, 0]) cylinder(r = 6/2, h = 50, center = true); //hole for audio jack -> add countersink
            translate([9, 1, 0]) cylinder(r = 8/2, h = 20, center = true); //hole for female DC power jack, 12vdc
            
            translate([-33.5, 17.3, 0]) cube([MATERIAL, 17.5, MATERIAL], center = true);
            translate([-33.5, -17.3, 0]) cube([MATERIAL, 17.5, MATERIAL], center = true);
        }
        
        
    }
    
    if (LASER) {
        projection() top();
        if (!DEBUG) {
            translate([-75, 0, 0]) rotate([0, 0, -13]) projection() back_side();
        }
        translate([0, 80, 0]) rotate([0, 0, -13]) projection() top_side();
        translate([0, -80, 0])  rotate([0, 0, -13]) projection() bottom_side();
    } else {
        translate([0, 0, height + cover_h]) top();
        if (!DEBUG) {
            translate([-44, 8, height + (cover_h / 2 ) - 4.25]) rotate([0, 0, -13]) rotate([0, 90, 0]) back_side();
        }
        translate([2, 49, height + (cover_h / 2 ) - 4.25]) rotate([0, 0, -13]) rotate([90, 0, 0]) top_side();
        translate([-22, -45, height + (cover_h / 2 ) - 4.25]) rotate([0, 0, -13]) rotate([90, 0, 0]) bottom_side();
    }
} 

module intval_laser_panel_cover_standoff (DECOYS = false) {
    tight = 0.2;
    cover_h = 21;
    $fn = 40;
    translate ([6, -9, height + 3.5]) {
        difference() {
            cylinder(r = bolt_inner + 1.4, h = cover_h - .5, center = true);
            cylinder(r = bolt_inner - tight, h = cover_h, center = true);
        }
        if (DECOYS) {
                decoys(12, -(cover_h / 2) + 2);
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
    tighten = 0.25;
	difference () {
		cylinder(r = 6.7 / 2, h = 5, center = true);
		cylinder(r = (4.76 -+ tighten) / 2, h = 5, center = true);
	}
	translate ([0, 0, -7.5]) {
		cylinder(r = 6.7 / 2, h = 10, center = true);
	}
}
module keyHole () {
	translate ([0, 0, 1.75]) {
		cube([10, 2, 3.5], center = true);
	}
}
module key_end (rotArr = [0, 0, 0], transArr = [0, 0, 0], ALT = false) {
	translate(transArr) {
		rotate (rotArr) {
			difference () {
				key();
				keyHole();
                if (ALT) {
                    translate([-2.5, 0, 1.75]) cube([5, 3, 3.5], center= true);
                }
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
module bearing (x, y, z, width= 8, hole = true, calval = 0) {
	innerD = 8.05;
	outerD = 22.1;
	fuzz = 0.1;
	translate ([x, y, z]) {
		difference () {
			cylinder(r = outerD / 2 + fuzz + calval, h = width, center = true);
			if (hole) {
				cylinder(r = innerD / 2 - fuzz, h = width, center = true);
			}
		}
	}
}
module motor_key (half = false, DECOYS = false, sides = 1, ALT = false) {
	innerD = 7.85;
	outer_d = 27.5 + 2;
	notch_d = 10;
	height = 7 + 5;
	diff = 14 + 2.5;
    $fn = 60;
	difference () {
		union () {
			translate([one_to_one_x, one_to_one_y, 12.1]) cylinder(r1 = 12 / 2, r2 = 12/2 + 4, h = 5, center = true);// padding against bearing
			translate([one_to_one_x, one_to_one_y, diff + 1]) cylinder(r=outer_d/2, h= height -2, center= true, $fn=200); //large cylinder
			translate([one_to_one_x, one_to_one_y, 6]) cylinder(r=innerD/2, h= 10, center= true);
			//key_end([0, 180, 0], [one_to_one_x, one_to_one_y, -2.5]); //thicker-than-key_end cylinder for inner bearing
            key_end([0, 180, -20], [one_to_one_x, one_to_one_y, -3.5], ALT = ALT); // longer for laser cut board
            //key_end([0, 180, 0], [one_to_one_x, one_to_one_y, -4.5]); //experimental length
		}
        //1 notch
		translate([one_to_one_x, one_to_one_y, diff]) {
			translate ([-outer_d/2 - 2.5, 0, 0]) cylinder(r=notch_d/2, h= height, center= true); //notch
		}
		translate([one_to_one_x, one_to_one_y, diff]) {
			translate ([-outer_d/2  -.5, -3.5, 0]) rotate([0, 0, 100]) cube([15, 5, height], center = true); // smooth notch
			translate ([-outer_d/2  -.5, 3.5, 0]) rotate([0, 0, -100]) cube([15, 5, height], center = true); // smooth notch
		}
        
        if (sides == 2) {
            //2 notch
            translate([one_to_one_x, one_to_one_y, diff]) {
                translate ([outer_d/2 + 2.5, 0, 0]) cylinder(r=notch_d/2, h= height, center= true); //notch
            }
            translate([one_to_one_x, one_to_one_y, diff]) {
                translate ([outer_d/2  +.5, -3.5, 0]) rotate([0, 0, -100]) cube([15, 5, height], center = true); // smooth notch
                translate ([outer_d/2  +.5, 3.5, 0]) rotate([0, 0, 100]) cube([15, 5, height], center = true); // smooth notch
            }
        }
        
		//slot for hobbled(?) end
        translate([one_to_one_x, one_to_one_y, 17]) {
            difference () {
                translate([0, 0, 0]) cylinder(r=3.1, h = 12, center = true, $fn = 24);
                translate([5.4, 0, 0]) cube([6, 6, 12], center = true);
            }
        }
		//translate([one_to_one_x, one_to_one_y, 20.5]) cylinder(r = 11.5/2, h = 10, center = true);

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

    if (DECOYS) {
        translate([one_to_one_x, one_to_one_y, 20.5]) decoys(24);
    }
}

module motor_key_120 (half = false, DECOYS = false, sides = 1, ALT = false) {
    innerD = 7.85;
	outer_d = 27.5 + 2;
	notch_d = 10;
	height = 7 + 5 + 3;
	diff = 14 + 2.5 + 1.5;
    $fn = 60;
	difference () {
		union () {
			translate([one_to_one_x, one_to_one_y, 12.1]) cylinder(r1 = 12 / 2, r2 = 12/2 + 4, h = 5, center = true);// padding against bearing
			translate([one_to_one_x, one_to_one_y, diff + 1]) cylinder(r=outer_d/2, h= height -2, center= true, $fn=200); //large cylinder
			translate([one_to_one_x, one_to_one_y, 6]) cylinder(r=innerD/2, h= 10, center= true);
			//key_end([0, 180, 0], [one_to_one_x, one_to_one_y, -2.5]); //thicker-than-key_end cylinder for inner bearing
            key_end([0, 180, -20], [one_to_one_x, one_to_one_y, -3.5], ALT = ALT); // longer for laser cut board
            //key_end([0, 180, 0], [one_to_one_x, one_to_one_y, -4.5]); //experimental length
		}
        //1 notch
		translate([one_to_one_x, one_to_one_y, diff]) {
			translate ([-outer_d/2 - 2.5, 0, 0]) cylinder(r=notch_d/2, h= height, center= true); //notch
		}
		translate([one_to_one_x, one_to_one_y, diff]) {
			translate ([-outer_d/2  -.5, -3.5 , 0]) rotate([0, 0, 100]) cube([15, 5, height], center = true); // smooth notch
			translate ([-outer_d/2  -.5, 3.5, 0]) rotate([0, 0, -100]) cube([15, 5, height], center = true); // smooth notch
		}
        
        if (sides == 2) {
            //2 notch
            translate([one_to_one_x, one_to_one_y, diff]) {
                translate ([outer_d/2 + 2.5, 0, 0]) cylinder(r=notch_d/2, h= height, center= true); //notch
            }
            translate([one_to_one_x, one_to_one_y, diff]) {
                translate ([outer_d/2  +.5, -3.5, 0]) rotate([0, 0, -100]) cube([15, 5, height], center = true); // smooth notch
                translate ([outer_d/2  +.5, 3.5, 0]) rotate([0, 0, 100]) cube([15, 5, height], center = true); // smooth notch
            }
        }
        
		//slot for hobbled(?) end
        translate([one_to_one_x, one_to_one_y, 17 + 2]) {
             translate([0, 0, 3]) hobbled_rod_120(12);
            //translate([6.42, 0, 6 - 1.7]) motor_set_screw_120();
            translate([6.42 - .2, 0, 4.3 - 2]) rotate([0, 90, 0]) motor_set_screw_120_alt();
            translate([14, 0, 4.3 - 2]) rotate([0, 90, 0]) cylinder(r2 = 6 / 2, r1 = 5.8 / 2, h = 6, center = true); //extension
            
        }
		//translate([one_to_one_x, one_to_one_y, 20.5]) cylinder(r = 11.5/2, h = 10, center = true);

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
  // translate([one_to_one_x, one_to_one_y, 17]) translate([6.42 - .2, 0, 6 - 1.7]) rotate([0, 90, 0]) motor_set_screw_120_alt();
    if (DECOYS) {
        translate([one_to_one_x, one_to_one_y, 20.5]) decoys(24);
    }
}

module motor_set_screw_120 () {
    cube([10.19, 2.95, 2.95], center = true);
    translate([(10.19 / 2) - (2.56 / 2), 0, 0]) cube([2.56, 5.8, 5.8], center = true);    
}

module motor_set_screw_120_alt () {
    $fn = 60;
    cylinder(r = 2.95 / 2, h = 10.19, center= true);
    translate([0, 0, (10.19 / 2) - (2.56 / 2)]) cylinder(r = 5.8 / 2, h = 2.56, center = true);
}

module hobbled_rod_120 (h = 10) {
            d = 4.00;
        diff = 3.33;
    difference () {
        
        cylinder(r = d/2, h = h, center = true, $fn = 60);
        translate([d/2 + ((d/2) - (d - diff)), 0, 0]) cube([d, d, h + 1], center = true);
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
module geared_motor (ROT_1 = 0, ROT_2 = 0) {
    BODY_D = 37;
    BODY_H = 42;
    BASE_D = 12;
    BASE_H = 6;
    ROD_D = 6;
    ROD_H = 15.5;
    rotate([0, 0, ROT_1]) {
        cylinder(r = BODY_D/2, h = BODY_H, center = true);
        translate([0, BASE_D/2, -(BODY_H/2) - (BASE_H/2)]) {
            cylinder(r = BASE_D/2, h = BASE_H, center = true);
        }
        translate([0, BASE_D/2, -(BODY_H/2) - (BASE_H/2) - (ROD_H/2)]) {
            rotate([0, 0, ROT_2]) {
                difference () {
                    cylinder(r = ROD_D/2, h = ROD_H, center = true);
                    translate([0, 5, -2]) cube([ROD_D, ROD_D, 12], center = true);
                }
            }
        }
    }
}
module geared_motor_mount (DECOYS = false) {
    $fn = 60;
	base_d = 45;
	base_inner = 38;
	base_thickness = 3;
	hole_d = 12.5;
	screw_d = 4;
	height = 6;
	difference () {
		difference () {
			translate([-6, 0, 2.5]) cylinder(r=base_d/2, h=height + 5, center = true); //outer cylinder
			translate([-6, 0, base_thickness + 2.5]) cylinder(r=base_inner/2, h=height + 5, center = true); //inder cylinder
		}
		cylinder(r=hole_d/2, h=29, center = true); //center hole
		//screw holes
        translate([-6.5, 0, 0]) {
            translate([0, screw_distance/2, 0]) cylinder(r=screw_d/2, h=29, center = true);
            translate([0, -screw_distance/2, 0]) cylinder(r=screw_d/2, h=29, center = true);
        }
        translate([2, 19, 0]) cylinder(r=5, h = 100, center = true); //hole for panel bolt access
    }
	//wings
	translate ([-one_to_one_x, -one_to_one_y, 0]) bolt_holder([mm_x[0], mm_y[0], 0], mm_r[0], height, mm_l[0]);
	translate ([-one_to_one_x, -one_to_one_y, 0]) bolt_holder([mm_x[1], mm_y[1], 0], mm_r[1], height, mm_l[1]);
    //translate ([-one_to_one_x, -one_to_one_y, 0]) bolt_holder([mm_x[5] , mm_y[5], 0], mm_r[5], height, mm_l[5] - 1);
    if (DECOYS) {
        translate([-7, -6, 0]) decoys(40, -1, 4);
        translate([-9, -2, 0]) rotate([0, 0, 49]) decoys(37, -1, 4);
    }
}

module geared_motor_mount_120 (DECOYS = false) {
    $fn = 160;
	base_d = 45;
	base_inner = 25.2;
	base_thickness = 3;
	hole_d = 7;
	screw_d = 3.2;
    bolt_end = 5.4;
	height = 6;
    screw_distance = 17;
	difference () {
		difference () {
			translate([-6, 0, 2.5]) cylinder(r=base_d/2, h=height + 5, center = true); //outer cylinder
			//translate([-6, 0, base_thickness + 2.5]) cylinder(r=base_inner/2, h=height + 5, center = true); //inner cylinder
            translate([0, 0, base_thickness + 1.5]) cylinder(r=base_inner/2, h=height + 5, center = true); //inner cylinder
		}
		cylinder(r=hole_d/2, h=29, center = true); //center hole
		//screw holes
        translate([0, 0, 0]) {
            translate([0, screw_distance/2, 0]) cylinder(r=screw_d/2, h=29, center = true);
            translate([0, -screw_distance/2, 0]) cylinder(r=screw_d/2, h=29, center = true);
            
            //bolt ends
            translate([0, screw_distance/2, -3]) cylinder(r=bolt_end/2, h=2, center = true);
            translate([0, -screw_distance/2, -3]) cylinder(r=bolt_end/2, h=2, center = true);
        }
        translate([2, 19, 0]) cylinder(r=5, h = 100, center = true); //hole for panel bolt access
    }
	//wings
	translate ([-one_to_one_x, -one_to_one_y, 0]) bolt_holder([mm_x[0], mm_y[0], 0], mm_r[0], height, mm_l[0]);
	translate ([-one_to_one_x, -one_to_one_y, 0]) bolt_holder([mm_x[1], mm_y[1], 0], mm_r[1], height, mm_l[1]);
    //translate ([-one_to_one_x, -one_to_one_y, 0]) bolt_holder([mm_x[5] , mm_y[5], 0], mm_r[5], height, mm_l[5] - 1);
    if (DECOYS) {
        translate([-7, -6, 0]) decoys(40, -1, 4);
        translate([-9, -2, 0]) rotate([0, 0, 49]) decoys(37, -1, 4);
    }
}


module motor_mount_bottom (DECOYS = false) {
    $fn = 60;
	mount_d = 45;
	base_d = 45;
	outer_d = 28 + 2.3 + 4;
	height = 19 + 3.5 + 4;
	bolt_h = 22.3;
	shelf_h = 6; //match to motor_mount
    screw_d = 4;
	module motor_mount_core () {
		translate ([one_to_one_x, one_to_one_y, (height / 2 ) + 5.75]) {
			difference() {
				translate([-6, 0, 0]) cylinder(r = mount_d / 2, h = height, center = true); //main block
				translate([0, 0, (height / 2) - (shelf_h / 2)]) cylinder(r = base_d / 2 + 7, h = shelf_h, center = true); //shelf for motor_mount
				cylinder(r = outer_d / 2, h = 50, center = true); //space for spinning
				translate ([-one_to_one_x, -one_to_one_y, 0]) remove_front(); //flatten side
				translate([-32, -17, -19]) cube([40, 40, 40], center= true); //hole for notch
				translate([-42, 0, -19]) rotate([0, 0, -39]) cube([40, 40, 40], center= true); //hole for notch
				translate([2.5, 19.5, 0]) cylinder(r=10/2, h = 60, center=true); // hole for panel bolt
				translate([22.5, 19.5, 0]) cube([40, 40, 60], center = true); //remove front entirely
                translate([-6.5, 0, 7.5]) {
                    translate([0, screw_distance/2, 0]) sphere(r=screw_d, center = true);
                    translate([0, -screw_distance/2, 0]) sphere(r=screw_d,  center = true);
                }
			}
			translate ([-one_to_one_x, -one_to_one_y, 0]) bolt_holder([mm_x[0], mm_y[0], -shelf_h / 2], mm_r[0], height - shelf_h, mm_l[0], tight = 0.2); //Bottom bolt holder
			translate ([-one_to_one_x, -one_to_one_y, 0]) bolt_holder([mm_x[1] , mm_y[1], -shelf_h / 2], mm_r[1], height - shelf_h, mm_l[1], tight = 0.2); //Left bolt holder
            
			translate ([-one_to_one_x, -one_to_one_y, -2]) bolt_holder([mm_x[5] , mm_y[5], -shelf_h / 2], mm_r[5], height - shelf_h - 4, mm_l[5]); //Top bolt holder
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
			translate([mm_x[4], mm_y[4], 0]) cylinder(r = bolt_inner, h = 100, center = true); // extra bolt hole
			translate([mm_x[1], mm_y[1], 0]) cylinder(r = 4, h = 100, center = true); //clear out top left bolt hole
		}
	}
	module panel_attachment () {
            difference () {
                union() {
                    translate([0, 0, 2]) cylinder(r = 7/2, h = height - shelf_h, center = true);
                    translate([3.5, 0, 0]) cube([7, 7, height - shelf_h - 4], center = true);
                }
                cylinder(r = 3.2/2, h = height, center = true);
            }
    }
    translate([8, -9, (height - shelf_h) / 2 + 3.75]) panel_attachment();
	motor_mount_core();
	microswitch_holder();
	bolt_holder([mm_x[2], mm_y[2], ((height - shelf_h)/ 2) + 3.75], 0, height - shelf_h - 4, 6); //bottom left mount
	bolt_holder([mm_x[3], mm_y[3], ((height - shelf_h)/ 2) + 3.75], 180, height - shelf_h - 4, 6); //bottom right mount
    if (DECOYS) {
        difference () {
            translate([35, 0 , 0]) decoys(44, 8, 6);
        }
        translate([0, 0, 8]) cube([4, 4, 4], center = true);
        translate([40, 55, 8]) cube([4, 4, 4], center = true);
    }
}
module bolt_holder (position = [0, 0, 0], rotate_z = 0, h = 17, length = 4.5, hole = true, tight = 0) {
    bolt_r = 6; 
	
	translate (position) {
		difference () {
			union() {
				cylinder(r = bolt_r + 0, h = h, center = true);
				rotate([0, 0, rotate_z]) translate([length/2, 0, 0]) cube([length, bolt_r * 2, h], center=true);
			}
			if (hole) {
				cylinder(r = bolt_inner - tight, h = h + 2, center = true);
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
module l289N_mount () {
    $fn = 60;
	DISTANCE = 36.5;
	H = 4;
    THICKNESS = 3;
	module stand () {
		difference () {
			cylinder(r1 = 4, r2 = 3, h = H, center = true);
			cylinder(r = 1.5, h = H, center = true);
		}
	}
	translate([0, 0, 0]) stand();
	translate([DISTANCE, 0, 0]) stand();
	translate([DISTANCE, DISTANCE, 0]) stand();
	translate([0, DISTANCE, 0]) stand();
    difference () {
        translate([DISTANCE/2, DISTANCE/2, -3]) rounded_cube([DISTANCE + 8, DISTANCE + 8, THICKNESS], 8, center = true); //base
        translate([DISTANCE/2, DISTANCE/2, -3]) rounded_cube([DISTANCE - 5, DISTANCE - 5, THICKNESS], 10, center = true); //base
        translate([0, 0, 0]) cylinder(r = 1.5, h = H * 5, center = true);
        translate([DISTANCE, 0, 0]) cylinder(r = 1.5, h = H * 5, center = true);
        translate([DISTANCE, DISTANCE, 0]) cylinder(r = 1.5, h = H * 5, center = true);
        translate([0, DISTANCE, 0]) cylinder(r = 1.5, h = H * 5, center = true);
    }
}
module pcb_mount () {
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

module plunger () {
        $fn = 60;
        FINGER = 39;
        CYL_D = 9;
        WALL = 3;
    difference () {
        union () {
            cylinder(r1 = CYL_D, r2 = CYL_D - 1, h = 30, center = true); //outer cylinder
            difference () {
                translate([0, 0, -9]) rotate([90, 0, 0]) rounded_cube([50, 12, 10], d = 5, center = true);
                translate([23, 0, 9]) rotate([90, 0, 0]) cylinder(r = FINGER/2, h = 20, center = true);
                translate([-23, 0, 9]) rotate([90, 0, 0]) cylinder(r = FINGER/2, h = 20, center = true);
            }
        }
        translate([0, 0, 2]) cylinder( r = CYL_D - WALL,  h = 30, center = true); //inner cylinder
        cylinder(r = 7/2, h = 50, center = true); // button hole
        
    }
    
    //cylinder(r= 5, h = 50, center = true); button
}

module plunger_top () {
    $fn = 60;
    CYL_D = 9;
    WALL = 3;
    
    difference () {
        union () {
            cylinder(r = CYL_D - WALL - 0.015, h =6, center = true);
            translate([0, 0, 2]) cylinder (r = CYL_D - 1, h = 2, center = true);
        }
        translate([0, 0, -2]) cylinder(r = CYL_D - WALL - 0.015 - 1, h =6, center = true);
        //cylinder(r = 3/2, h = 50, center = true); // wire
        cylinder(r = 3.9/2, h = 50, center = true); //3.5mm wire
    }
}

module plunger_plate () {
    translate([40, 0, -12]) rotate([180, 0, 0]) plunger_top();
    plunger();
        
    //decoys
    /*translate([44,20,-13]) cube([4, 4, 4], center = true);
    translate([44,-20,-13]) cube([4, 4, 4], center = true);
    translate([-23,20,-13]) cube([4, 4, 4], center = true);
    translate([-23,-20,-13]) cube([4, 4, 4], center = true);*/
}

module trinket_mount (decoys = false) {
    $fn = 60;
    TRINKET_L = 37.5;
    TRINKET_W = 18;
    difference () {
        rounded_cube([TRINKET_L + 4.5, 21, 3.5], d = 4, center = true); //body
        translate([0, 0, 1]) cube([TRINKET_L, TRINKET_W, 1.5], center = true); //trinket
        translate([0, 0, 0]) cube([TRINKET_L - 1, TRINKET_W - 1, 10], center = true); //trinket ridge
        translate([20, 0, 1]) cube([9, 9, 1.5], center = true);
        
    }
    translate([(TRINKET_L / 2)  -2, 0, -.75]) cube([4, TRINKET_W - 1, 2], center = true);//under usb
    SPREAD = 14.25;
    translate([(TRINKET_L / 2)  -2, SPREAD/2,  1]) cylinder(r = 1.75/2, h = 2, center = true);
    translate([(TRINKET_L / 2)  -2, -SPREAD/2, 1]) cylinder(r = 1.75/2, h = 2, center = true);
    //decoys
    if (decoys){
        translate([23,20,.25]) cube([4, 4, 4], center = true);
        translate([23,-20,.25]) cube([4, 4, 4], center = true);
        translate([-23,20,.25]) cube([4, 4, 4], center = true);
        translate([-23,-20,.25]) cube([4, 4, 4], center = true);
    }
}

module metro_mount (decoys = false) {
    $fn = 60;
    TRINKET_L = 43.5;
    TRINKET_W = 18;
    difference () {
        rounded_cube([TRINKET_L + 4.5, 21, 3.5], d = 4, center = true); //body
        translate([0, 0, 1]) cube([TRINKET_L, TRINKET_W, 1.5], center = true); //trinket
        translate([0, 0, 0]) cube([TRINKET_L - 1, TRINKET_W - 1, 10], center = true); //trinket ridge
        translate([20, 0, 1]) cube([9, 9, 1.5], center = true);
        
    }
    translate([(TRINKET_L / 2)  -2, 0, -.75]) cube([4, TRINKET_W - 1, 2], center = true);//under usb
    SPREAD = 14.25;
    translate([(TRINKET_L / 2)  -2, SPREAD/2,  1]) cylinder(r = 1.75/2, h = 2, center = true);
    translate([(TRINKET_L / 2)  -2, -SPREAD/2, 1]) cylinder(r = 1.75/2, h = 2, center = true);
    //decoys
    if (decoys){
        translate([23,20,.25]) cube([4, 4, 4], center = true);
        translate([23,-20,.25]) cube([4, 4, 4], center = true);
        translate([-23,20,.25]) cube([4, 4, 4], center = true);
        translate([-23,-20,.25]) cube([4, 4, 4], center = true);
    }
}

module panel_cover (DECOYS = false) { 
    $fn = 60;
    HEIGHT = 85;
    WIDTH = 37;
    z = 25 + 8 + 5;
    translate([0, 0, (z/2) + 9.5])  {
        difference () {
            union () {
                difference () {
                    rounded_cube([WIDTH, HEIGHT, z], d = 20, center = true); //main body of case
                    translate([0, 0, -1]) rounded_cube([WIDTH - 4, HEIGHT - 4, z-2], d = 18, center = true);
                    translate([-5, 35, 5]) rotate([0, 0, 15]) cube([50, 25, 400],  center = true); //heatsink
                    translate([-10, 12, -9]) rotate([0, 0, 13]) cube([70, 40, 20],  center = true); //L289N hole
                    translate([13, -36, -15]) rotate([0, 0, 13])cube([24, 45, 8], center = true); //trinket
                    //buttons
                    translate([7, -32, 8]) cylinder(r = 3.1, h = 190, center = true);
                    translate([7, -19, 8]) cylinder(r = 3.1, h = 190, center = true);
                    translate([7, -5, 8]) cylinder(r = 3.1, h = 190, center = true);
                    
                    translate([-20, -30, 0]) rotate([90, 0, 90]) cylinder(r = 1.75, h = 10, center = true); //hole for trigger cable
                    translate([-20, -30, -19]) cube([15, 0.5, 40], center = true);
                    translate([-15, -20, 0]) rotate([90, 0, 90]) cylinder(r = 3.1, h = 19, center = true); //power
                    
                    translate([-5, -12, 7]) cylinder(r= 2, h = z + 5, center= true); //LED
                }
               // translate([-5, -26.5, 0]) cylinder(r = 5, h = z, center = true);
            }
            translate([-5, -26.5, 0]) cylinder(r = 4, h = z + 10, center = true); //access hole for
        }
        
    }
    
    //decoys
    if (DECOYS){
        DECOY_H = 40.5;
        DECOY_W = 28;
        translate([DECOY_W, 33, DECOY_H]) cube([4, 4, 4], center = true);
        translate([DECOY_W, -40, DECOY_H]) cube([4, 4, 4], center = true);
        translate([-DECOY_W, 20, DECOY_H]) cube([4, 4, 4], center = true);
        translate([-DECOY_W, -40, DECOY_H]) cube([4, 4, 4], center = true);
        translate([-DECOY_W, -10, DECOY_H]) cube([4, 4, 4], center = true);
        translate([DECOY_W, -10, DECOY_H]) cube([4, 4, 4], center = true);
    }
}

module button_nuts () {
    difference () {
        cylinder(r = 5, h = 2, center = true, $fn = 6);
        cylinder(r = 3.1, h = 19, center = true, $fn = 60);
    }
}

module button_nuts_plate (decoys = false) {
    
    translate([0, 0, 0]) button_nuts();
    translate([0, 11, 0]) button_nuts();
    translate([11, 11, 0]) button_nuts();
    translate([11, 0, 0]) button_nuts();
    translate([22, 0, 0]) button_nuts();
    translate([22, 11, 0]) button_nuts();
    
    if (decoys){
        translate([30, 24, 1]) cube([4, 4, 4], center = true);
        translate([30, -14, 1]) cube([4, 4, 4], center = true);
        translate([-10, 24, 1]) cube([4, 4, 4], center = true);
        translate([-10, -14, 1]) cube([4, 4, 4], center = true);
    }
}

module intval_electronics_mount (TYPE = "TRINKET") {
    translate([-40 + 2, -1, 14]) rotate([0, 0, -13]) l289N_mount();
    if (TYPE == "TRINKET") {
        translate([-26 + 2, -19, 11.25]) rotate([0, 0, -180 - 13]) trinket_mount();
    } else if (TYPE == "METRO") {
        translate([-26 + 2, -19, 11.25]) rotate([0, 0, -180 - 13]) metro_mount();    
    }
}

module key_cap () {
    $fn = 40;
	outerD = 22.1;
	fuzz = 0.1;
    difference () {
        cylinder(r = outerD / 2 + fuzz + 1, h = 18, center = true); 
        translate([0, 0, -1]) cylinder(r = outerD / 2, h = 16, center = true); 
    }
    //decoys(23, 7);
}

module motor_cap (DECOYS = false, HALF = false) {
    $fn = 60;
	base_d = 47;
    difference () {
        translate([-6, 0, 40]) cylinder(r = base_d/2, h = 52, center = true);
        translate([-6, 0, -5.75]) cylinder(r = base_d/2 - 1, h = 50, center = true);
        translate([-6, 0, 39]) cylinder(r = base_d/2 - 3, h = 50, center = true);
        translate([-25, 0, 19]) cube([10, 10, 15], center = true); //wire access
        if (HALF){
            translate([100, 0, 0]) cube([200, 200, 200], center = true);
        }
    }
    if (DECOYS) {
        translate([-6, 0, 0]) decoys(32, 64);
    }
}


module bearing_calibrate (val = 0) {
    mat = 25.4/8;
    difference () {
        cube([40, 40, mat], center = true);
        bearing(0, 0, 0, hole = false, calval = val);
    }
}

module stl_plate () {
    //translate([0, 0, -0.5]) cube([150, 150, 1], center = true);
    translate([-38, 41, 7.5]) rotate([0, 180, 0]) intval_laser_standoffs_plate();
    translate([-27, 40, -9.5]) rotate([0, 0, 13]) intval_electronics_mount();
    
    translate([23, 1, -5.75]) rotate([0, 0, 90]) motor_mount_bottom();
    translate([48, -13, 9]) rotate([0, 180, 0]) key_cap();
    translate([-5, -11, 3]) rotate([0, 0, 190]) geared_motor_mount();
    translate([65, 44, 22.5]) rotate([0, 180, 0]) motor_key();
    translate([0, -42, 15]) plunger_plate();
    translate([-52, -20, 66]) rotate([0, 180, 0]) motor_cap(false);
};

module dxf_plate () {
    translate([105, 0, 0]) rotate([0, 0, 13]) projection() intval_panel_laser();
    rotate([0, 0, 13]) intval_laser_panel_cover(LASER=true, ALL_RED=true);
};

module exploded_view () {
    intval_panel_laser();
    translate([0, 0, 5]) intval_electronics_mount();
    translate([0, 0, 5]) motor_mount_bottom();
    translate([0, 0, 20]) motor_key();
    translate([one_to_one_x, one_to_one_y, 50]) geared_motor_mount();
    translate([one_to_one_x, one_to_one_y, 50]) motor_cap(false);
    translate([0, 0, 60]) intval_laser_panel_cover(false, ALL_RED=true);
}

//translate([-11, -36, 11.5]) rotate([0, 0, -90]) trinket_mount();
//button_nuts_plate(true);
//plunger_plate();

//translate([-34, -8, 14]) l289N_mount();
//translate([-15, 10, 0]) decoys(30, 11.5);

//pcb_mount();
//motor_mount();
//translate([48.5, 12, 60]) geared_motor(-90);
//translate([54.5, 12, 33.5]) {
   //translate([0, 0, 11]) geared_motor_mount();
//}
//motor_cap(true);

//motor_key();
//motor_key(DECOYS= true);
//intval_panel(); //OLD

//projection() l289N_hole_test();

//intval_laser_panel_cover(LASER=true, ALL_RED=true);
//projection() intval_panel_laser();
//intval_laser_standoffs();
//translate([-40, 0, 14]) rotate([0, 0, -13]) l289N_mount();
//translate([-40, -29, 11.5]) rotate([0, 0, -90 - 13]) trinket_mount();
//translate([0, 0, 4]) motor_mount_bottom();
//translate([54.5, 12, 33.5]) {
    //geared_motor_mount();
//}
//intval_electronics_mount();

//rotate([0, 180, 0]) motor_key(DECOYS = true);

//difference () {
    //import("/Users/dev/Documents/3d/intval2/intval2_geared_motor_key.stl");
    //translate([0, -25, 0]) cube([50, 50, 50], center = true);
//}

//translate([-15, -8, 0]) rotate([0, 0, -13]) panel_cover(true);
//bearing (one_to_one_x, one_to_one_y, 5.5);
//difference () {
	//translate([one_to_one_x, one_to_one_y, 31]) motor_mount();
	//translate([one_to_one_x, one_to_one_y, 0]) cube([200, 200, 200]);
//}
//translate([0, 0, 40]) geared_motor(45, 45);
//motor_mount_bottom();

//translate([one_to_one_x, one_to_one_y, 63]) rotate([0, 180, 0]) motor_12v();

/* DEBUG */
//projection() intval_panel_laser_debug ();
//translate ([4, 12, 0]) translate([-74, 60, -25]) rotate([0, 0, -13 - 90]) import("/Users/dev/Downloads/UNO_R2_MOUNT.STL");


//bearing_calibrate();


/*

 INTVAL 2 LASER PARTS

*/

//intval_laser_standoffs_plate();
//intval_electronics_mount("METRO");
//motor_mount_bottom();
//projection () intval_panel_laser();
//intval_laser_panel_cover(true, ALL_RED=true);
//key_cap();
//geared_motor_mount();
//translate([one_to_one_x, one_to_one_y, 30]) 
//geared_motor_mount_120();
//motor_key();
motor_key_120();
//plunger_plate();
//motor_cap(false);

//exploded_view();
//stl_plate();
//dxf_plate();
