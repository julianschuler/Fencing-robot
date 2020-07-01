include <settings.scad>
use <stepper.scad>



module front_plate(bearing_type=bearing_large) {
  plate_length = 2 * (get_wheel_radius(shoulder_modulus, shoulder_teeth, shoulder_teeth) + object_clearance);
  screw_offset = (screw_length - plate_thickness - wall_thickness)/3;
  
  steel() difference() {
    translate([-plate_width/2, -plate_length/2, 0]) cube([plate_width, plate_length, plate_thickness]);
    translate([0, 0, -e]) cylinder(h=plate_thickness + 2 * e, d=bearing_type[od_pos]/2 
      + bearing_type[id_pos]/2 + object_clearance);
    for (i = [0 : bearing_holes - 1]) {
      rotate([0, 0, i * 360/bearing_holes]) {
        translate([bearing_type[od_pos]/2 + screw_diameter/2 + wall_thickness, 0, -e]) 
          cylinder(h=plate_thickness + 2 * e, d=screw_diameter);
      }
    }
    for (i = [0 : bracket_holes - 1]) {
      if (i % 2 == bracket_orientation) {
        translate([i * plate_width/bracket_holes + plate_width/(2 * bracket_holes) - plate_width/2, 0, 0]) {
          translate([0, plate_length/2 - screw_offset, -e]) 
            cylinder(h=plate_thickness + 2 * e, d=screw_diameter);
          translate([0, -plate_length/2 + screw_offset, -e]) 
            cylinder(h=plate_thickness + 2 * e, d=screw_diameter);
        }
      }
    }
  }
}


module stepper_plate(bearing_type = bearing_medium) {;
  plate_clearance = 10;
  stepper_offset = shoulder_modulus * (spur_wheel_teeth + spur_pinion_teeth)/2;
  hole_offset = sqrt(2) * get_hole_distance()/2;
  plate_length = stepper_offset + hole_offset + plate_clearance;
  id = bearing_type[od_pos]/2 + bearing_type[id_pos]/2 + object_clearance;
  
  steel() difference() {
    union() {       
      cylinder(h=plate_thickness, d=plate_width);
      translate([-plate_width/2, -plate_length, 0]) cube([plate_width, plate_length, plate_thickness]);
    }
    translate([0, 0, -e]) cylinder(h=plate_thickness + 2 * e, d=id);
    for (i = [0 : bearing_holes - 1]) {
      rotate([0, 0, i * 360/bearing_holes]) {
        translate([bearing_type[od_pos]/2 + screw_diameter/2 + wall_thickness, 0, -e]) 
          cylinder(h=plate_thickness + 2 * e, d=screw_diameter);
      }
    }
    translate([0, -stepper_offset, -e]) {
      cylinder(h=plate_thickness + 2 * e, d=stepper_diameter);
      for (i = [0 : stepper_holes - 2]) {
        rotate([0, 0, i * 360/stepper_holes]) translate([-hole_offset, 0, 0]) 
          cylinder(h=plate_thickness + 2 * e, d=screw_diameter);
      }
    }
  }
  
  if (assembled) {
    translate([0, -stepper_offset, plate_thickness]) {
      rotate([0, 0, 45]) stepper();
      for (i = [0 : stepper_holes - 2]) stainless() {
        rotate([0, 0, i * 360/stepper_holes]) {
          translate([-hole_offset, 0, stepper_plate_thickness]) screw(screw_name);
          translate([-hole_offset, 0, stepper_plate_thickness - screw_length + screw_nut_height]) 
            rotate([0, 0, 90]) nut(screw_type);
        }
      }
    }
  }
}


module side_plate(bearing_type=bearing_medium) {
  plate_offset = screw_nut_height + bearing_large[h_pos] + pressfit_clearance + plane_thickness;
  plate_length = get_pinion_radius(shoulder_modulus, shoulder_teeth, shoulder_teeth)
    + object_clearance + plate_offset;
  bearing_type = bearing_medium;
  id = bearing_type[od_pos]/2 + bearing_type[id_pos]/2 + object_clearance;
  hole_offset = bearing_type[od_pos]/2 + screw_diameter/2 + wall_thickness + screw_head_diameter
    + object_clearance;
  screw_offset = (bearing_large[h_pos] + plane_thickness + screw_nut_height)/2;
  orientation = 0;
  
  steel() difference() {
    union() {       
      cylinder(h=plate_thickness, d=plate_width);
      translate([-plate_width/2, 0, 0]) cube([plate_width, plate_length, plate_thickness]);
    }
    translate([0, 0, -e]) cylinder(h=plate_thickness + 2 * e, d=id);
    for (i = [0 : bearing_holes - 1]) {
      rotate([0, 0, i * 360/bearing_holes]) {
        translate([hole_offset, 0, -e]) 
          cylinder(h=plate_thickness + 2 * e, d=screw_diameter);
      }
    }
    for (i = [0 : bracket_holes - 1]) {
      if (i % 2 != bracket_orientation) {
        translate([i * plate_width/bracket_holes + plate_width/(2 * bracket_holes) - plate_width/2, 0, 0]) {
          translate([0, plate_length - screw_offset, -e]) 
            cylinder(h=plate_thickness + 2 * e, d=screw_diameter);
        }
      }
    }
  }
}


module mounting_plate() {
  lid_thickness = plane_thickness/2;
  wheel_radius = get_wheel_radius(shoulder_modulus, shoulder_teeth, shoulder_teeth);
  length = 2 * (wheel_radius + 2 * plate_thickness + 4 * object_clearance + screw_head_height 
    + lid_thickness + spur_teeth_width);
  width = plate_width;
  outer_screw_offset = length/2 - lid_thickness - object_clearance - spur_teeth_width/2;
  
  steel() difference() {
    translate([-width/2, -length/2, 0]) cube([width, length, plate_thickness]);
    for (i = [1 : outer_screws/2]) {
      translate([i * plate_width/(outer_screws + 1), outer_screw_offset, -e]) 
        cylinder(h=plate_thickness + 2 * e, d=screw_diameter);
      translate([i * -plate_width/(outer_screws + 1), outer_screw_offset, -e]) 
        cylinder(h=plate_thickness + 2 * e, d=screw_diameter);
      translate([i * plate_width/(outer_screws + 1), -outer_screw_offset, -e]) 
        cylinder(h=plate_thickness + 2 * e, d=screw_diameter);
      translate([i * -plate_width/(outer_screws + 1), -outer_screw_offset, -e]) 
        cylinder(h=plate_thickness + 2 * e, d=screw_diameter);
    }
    for (i = [1 : inner_screws/2]) {
      translate([i * plate_width/(inner_screws + 1), 0, -e]) 
        cylinder(h=plate_thickness + 2 * e, d=screw_diameter);
      translate([i * -plate_width/(inner_screws + 1), 0, -e]) 
        cylinder(h=plate_thickness + 2 * e, d=screw_diameter);
    }
  }
  
  if (assembled) stainless() {
    for (i = [1 : outer_screws/2]) {
      // left screws
      translate([i * plate_width/(outer_screws + 1), outer_screw_offset, plate_thickness]) 
        screw(screw_name);
      translate([i * -plate_width/(outer_screws + 1), outer_screw_offset, plate_thickness]) 
        screw(screw_name);
      // right screws
      translate([i * plate_width/(outer_screws + 1), -outer_screw_offset, plate_thickness]) 
        screw(screw_name);
      translate([i * -plate_width/(outer_screws + 1), -outer_screw_offset, plate_thickness]) 
        screw(screw_name);
      // left nuts
      translate([i * plate_width/(outer_screws + 1), outer_screw_offset, 
        plate_thickness + screw_nut_height - screw_length ]) rotate([0, 0, 90]) nut(screw_type);
      translate([i * -plate_width/(outer_screws + 1), outer_screw_offset, 
        plate_thickness + screw_nut_height - screw_length ]) rotate([0, 0, 90]) nut(screw_type);
      // right nuts
      translate([i * plate_width/(outer_screws + 1), -outer_screw_offset,
        plate_thickness + screw_nut_height - screw_length ]) rotate([0, 0, 90]) nut(screw_type);
      translate([i * -plate_width/(outer_screws + 1), -outer_screw_offset, 
        plate_thickness + screw_nut_height - screw_length ]) rotate([0, 0, 90]) nut(screw_type);
    }
    for (i = [1 : inner_screws/2]) {
      // middle screws
      translate([i * plate_width/(inner_screws + 1), 0, plate_thickness]) screw(screw_name);
      translate([i * -plate_width/(inner_screws + 1), 0, plate_thickness]) screw(screw_name);
      // middle nuts
      translate([i * plate_width/(inner_screws + 1), 0, plate_thickness + screw_nut_height 
        - screw_length]) rotate([0, 0, 90]) nut(screw_type);
      translate([i * -plate_width/(inner_screws + 1), 0, plate_thickness + screw_nut_height 
        - screw_length]) rotate([0, 0, 90]) nut(screw_type);
    }
  }
}
