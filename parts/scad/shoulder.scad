include <settings.scad>
use <utility.scad>
use <stepper.scad>



module shoulder_wheel() {
  hole_offset = get_hole_distance() / 2;
  
  difference () {
    bevel_gear_wheel(shoulder_modulus, shoulder_teeth, shoulder_teeth, shoulder_teeth_width, 0, 
      helix_angle=helix_angle);
    translate([0, 0, -e]) cylinder(h=shoulder_teeth_width + e, d=coupler_diameter + 2 * object_clearance);
    // stepper cutout
    translate([-stepper_size/2, -stepper_size/2, stepper_offset]) 
      cube([stepper_size, stepper_size, shoulder_teeth_width - stepper_offset]);
    translate([0, 0, stepper_offset - stepper_thickness - object_clearance])
      cylinder(h=stepper_thickness + object_clearance + e, d=stepper_diameter + 2 * object_clearance);
    
    // stepper mounting holes
    for (i = [0 : stepper_holes - 1]) {
      rotate([0, 0, i * 360/stepper_holes]) translate([hole_offset, hole_offset, -e]) {
        cylinder(h=stepper_offset + 2 * e, d=screw_diameter);
        rotate([0, 0, 135]) nutcatch_overhang(screw_type, screw_diameter, screw_nut_height);
      }
    }
    // arm mounting holes
    for (i = [0 : axle_holes - 1]) {
      rotate([0, 0, i * 360/axle_holes]) translate([bearing_large[id_pos]/4 + coupler_diameter/4
        + object_clearance/2 - pressfit_clearance, 0, -e]) {
          cylinder(h=shoulder_teeth_width + e, d=screw_diameter);
          translate([0, 0, plane_thickness + screw_nut_height + e]) 
            rotate([0, 180, 90]) nutcatch_parallel(screw_type, l=stepper_offset, clk=sliding_clearance);
        }
    }
  }
  
  if (assembled) {
    // stepper mounting
    for (i = [0 : stepper_holes - 1]) {
      rotate([0, 0, i * 360/stepper_holes]) translate([hole_offset, hole_offset, 0]) {
        rotate([0, 0, 135]) {
          translate([0, 0, stepper_offset + 5]) stainless() screw(screw_name);
          translate([0, 0, screw_nut_height]) stainless() nut(screw_type);
        }
      }
    }
    // arm mounting
    for (i = [0 : axle_holes - 1]) stainless() {
      rotate([180, 0, i * 360/axle_holes]) translate([bearing_large[id_pos]/4 
        + coupler_diameter/4 + object_clearance/2 - pressfit_clearance, 0, 
          -plane_thickness - screw_nut_height]) rotate([0, 0, 90]) nut(screw_type);
    }
    translate([0, 0, stepper_offset]) stepper();
  }
}


module shoulder_connector(height = 15) {
  _screw_name = "M5x50";
  
  shoulder_teeth_width = nut_diameter + 2 * wall_thickness;
  length = 2 * upper_arm_rod_offset;
  total_height = height + nut_height + spacer_thickness + plate_thickness + screw_head_height
    + object_clearance;
  
  difference() {
    union() {
      cylinder(h=total_height, d=bearing_large[od_pos]/2 + bearing_large[id_pos]/2 - object_clearance);
      cylinder(h=total_height + bearing_large[h_pos]/2, d=bearing_large[id_pos] - 2 * pressfit_clearance);
      translate([0, 0, height/2]) cube([shoulder_teeth_width, length, height], center=true);
      translate([0, length/2, 0]) cylinder(h=height, d=shoulder_teeth_width);
      translate([0, -length/2, 0]) cylinder(h=height, d=shoulder_teeth_width);
    }
    translate([0, 0, -e]) cylinder(h=total_height + bearing_large[h_pos]/2 + 2 * e, 
      d=thread_diameter + 2 * object_clearance);
    translate([0, length/2, -e]) cylinder(h=height + 2 * e, d=thread_diameter);
    translate([0, -length/2, -e]) cylinder(h=height + 2 * e, d=thread_diameter);
    for (i = [0 : axle_holes - 1]) {
      rotate([0, 0, i * 360/axle_holes])
        translate([bearing_large[id_pos]/4 + coupler_diameter/4 + object_clearance/2 - pressfit_clearance, 
          0, -e]) 
            cylinder(h=total_height + bearing_large[h_pos]/2 + 2 * e, d=screw_diameter);
    }
  }
  
  if (assembled) {
    // spacers
    translate([0, length/2, -spacer_thickness]) spacer();
    translate([0, -length/2, -spacer_thickness]) spacer();
    translate([0, length/2, height]) spacer();
    translate([0, -length/2, height]) spacer();
    
    if (show_all) stainless() {
      // nuts
      translate([0, length/2, -spacer_thickness]) nut(thread_name);
      translate([0, -length/2, -spacer_thickness]) nut(thread_name);
      translate([0, length/2, height + nut_height + spacer_thickness]) nut(thread_name);
      translate([0, -length/2, height + nut_height + spacer_thickness]) nut(thread_name);
      
      // screws
      for (i = [0 : axle_holes - 1]) {
        rotate([0, 180, i * 360/axle_holes])
          translate([bearing_large[id_pos]/4 + coupler_diameter/4 + object_clearance/2 
            - pressfit_clearance, 0, 0]) screw(_screw_name);
      }
    }
  }
}


module bearing_holder(bearing_type=bearing_medium, diameter_offset=0) {
  _screw_name = "M5x20";
  
  offset = plane_thickness + screw_nut_height;
  height = bearing_type[h_pos] + offset;
  screw_offset = bearing_type[od_pos]/2 + screw_diameter/2 + wall_thickness;
  
  difference() {
    cylinder(h=height, d=bearing_type[od_pos] + 4 * wall_thickness + 2 * screw_diameter + diameter_offset);
    translate([0, 0, offset]) 
      cylinder(h=height - offset + e, d=bearing_type[od_pos] + 2 * pressfit_clearance);
    translate([0, 0, -e]) cylinder(h=offset + 2 * e, d=bearing_type[od_pos]/2 
      + bearing_type[id_pos]/2 + object_clearance);
    for (i = [0 : bearing_holes - 1]) {
      rotate([0, 0, i * 360/bearing_holes]) {
        translate([screw_offset + diameter_offset/2, 0, -e]) cylinder(h=height + 2 * e, d=screw_diameter);
        translate([screw_offset + diameter_offset/2, 0, 0]) rotate([0, 0, 90]) 
          nutcatch_overhang(screw_type, screw_diameter, screw_nut_height);
      }
    }
  }
  
  if (assembled) {
    // bearing
    translate([0, 0, offset]) steel() bearing(bearing_type);
    // nuts and bolts
    for (i = [0 : bearing_holes - 1]) stainless() {
      rotate([0, 0, i * 360/bearing_holes]) {
        translate([screw_offset + diameter_offset/2, 0, height + plate_thickness]) screw(_screw_name);
        translate([screw_offset + diameter_offset/2, 0, screw_nut_height]) rotate([0, 0, 90]) 
          nut(screw_type);
      }
    }
  }
}


module bearing_holder_large() {
  bearing_holder(bearing_large);
}


module bearing_holder_wide() {
  bearing_holder(diameter_offset = 2 * screw_head_diameter + 2 * object_clearance);
}
  

module bearing_clamp_large(bearing_type=bearing_large) {
  height=plane_thickness + screw_nut_height + object_clearance;
  difference() {
    union() {
      cylinder(h=height, d=bearing_type[od_pos]/2 + bearing_type[id_pos]/2 - object_clearance);
      cylinder(h=height + bearing_type[h_pos]/2, d=bearing_type[id_pos] - 2 * pressfit_clearance);
    }
    translate([0, 0, -e]) 
      cylinder(h=height + bearing_type[h_pos]/2 + 2 * e, d=coupler_diameter + 2 * object_clearance);
    for (i = [0 : axle_holes - 1]) {
      rotate([0, 0, i * 360/axle_holes])
        translate([bearing_type[id_pos]/4 + coupler_diameter/4 + object_clearance/2 
          - pressfit_clearance, 0, -e]) 
            cylinder(h=height + bearing_type[h_pos]/2 + 2 * e, d=screw_diameter);
    }
  }
}


module bearing_clamp_halve(bearing_type=bearing_medium) {
  height = 3 * object_clearance/2 + plate_thickness + screw_head_height/2;
  screw_offset = bearing_type[id_pos]/2 - screw_diameter/2 - wall_thickness;
  id = bearing_type[od_pos]/2 + bearing_type[id_pos]/2 - object_clearance;
  
  difference() {
    union() {
      cylinder(h=height, d=id);
      cylinder(h=height + bearing_type[h_pos]/2, d=bearing_type[id_pos] - 2 * pressfit_clearance);
    }
    for (i = [0 : axle_holes - 1]) {
      rotate([0, 0, i * 360/axle_holes])
        translate([screw_offset, 0, -e]) 
          cylinder(h=height + bearing_type[h_pos]/2 + 2 * e, d=screw_diameter);
    }
  }
}



module shoulder_pinion(bearing_type=bearing_medium) {
  height = bearing_type[h_pos] + plane_thickness + screw_nut_height;
  od = bearing_type[od_pos] + 4 * wall_thickness + 2 * screw_diameter + 4 * object_clearance
     + 2 * screw_head_diameter;
  id = bearing_type[od_pos]/2 + bearing_type[id_pos]/2 - object_clearance;
  offset = bearing_type[h_pos] - object_clearance;
  screw_offset = bearing_type[id_pos]/2 - screw_diameter/2 - wall_thickness;
  screw_length = 60;
  nut_offset = 2 * plate_thickness + 3 * object_clearance + screw_head_height + spur_teeth_width - 
    screw_length;
  
  difference () {
    union() {
      difference() {
        bevel_gear_pinion(shoulder_modulus, shoulder_teeth, shoulder_teeth,
          shoulder_teeth_width, 0, helix_angle);
        translate([0, 0, -e]) cylinder(h=height + e, d=od);
      }
      translate([0, 0, offset]) cylinder(h=height - offset, d=id);
      translate([0, 0, offset - bearing_type[h_pos]/2]) 
        cylinder(h=height - offset + bearing_type[h_pos]/2, d=bearing_type[id_pos] - 2 * pressfit_clearance);
    }
    for (i = [0 : axle_holes]) {
      rotate([0, 0, i * 360/axle_holes]) {
        translate([screw_offset, 0, -e]) cylinder(h=shoulder_teeth_width, d=screw_diameter);
        translate([screw_offset, 0, shoulder_teeth_width - nut_offset - screw_nut_height]) 
          rotate([0, 180, 90]) nutcatch_overhang(screw_type, screw_diameter, shoulder_teeth_width);
      }
    }
  }
  
  if (assembled) {
    for (i = [0 : axle_holes]) stainless() {
      rotate([0, 0, i * 360/axle_holes]) {
        translate([screw_offset, 0, -nut_offset - screw_length]) rotate([0, 180, 0]) screw("M5x50");
        translate([screw_offset, 0, -nut_offset]) rotate([0, 0, 90]) nut(screw_type);
      }
    }
  }
}


module shoulder_spur_wheel(bearing_type=bearing_medium) {
  _screw_type = "M5x50";
  
  height = bearing_type[h_pos] + plane_thickness + screw_nut_height;
  id = bearing_type[od_pos]/2 + bearing_type[id_pos]/2 - object_clearance;
  od = bearing_type[od_pos] + 2 * wall_thickness + screw_diameter + screw_head_diameter 
    + 2 * object_clearance;
  screw_offset = bearing_type[id_pos]/2 - screw_diameter/2 - wall_thickness;
  
  difference() {
    union() {
      difference() {
        spur_gear(shoulder_modulus, spur_wheel_teeth, spur_teeth_width, 0, helix_angle);
        translate([0, 0, spur_teeth_width - height]) cylinder(h=height + e, d=od);
      }
      cylinder(h=spur_teeth_width - bearing_type[h_pos] + object_clearance, d=id);
      cylinder(h=spur_teeth_width - bearing_type[h_pos]/2 + object_clearance, d=bearing_type[id_pos]);
    }
    for (i = [0 : axle_holes]) {
      rotate([0, 0, i * 360/axle_holes]) {
        translate([screw_offset, 0, -e]) cylinder(h=spur_teeth_width + 2 * e, d=screw_diameter);
      }
    }
  }
}


module shoulder_spur_pinion() {
  spur_gear(shoulder_modulus, spur_pinion_teeth, spur_teeth_width, thread_diameter, -helix_angle);
}



module coupler() {
  steel() ring(od=coupler_diameter, id=thread_diameter, h=coupler_height);
}



module plate(bearing_type = bearing_large) {;
  steel() difference() {
    cube([100, 100, plate_thickness], center=true);
    cylinder(h=plate_thickness + 2 * e, d=bearing_type[od_pos]/2 
      + bearing_type[id_pos]/2 + object_clearance, center=true);
    for (i = [0 : bearing_holes - 1]) {
      rotate([0, 0, i * 360/bearing_holes]) {
        translate([bearing_type[od_pos]/2 + screw_diameter/2 + wall_thickness, 0, 0]) 
          cylinder(h=plate_thickness + 2 * e, d=screw_diameter, center=true);
      }
    }
  }
}


module stepper_plate(bearing_type = bearing_medium) {;
  plate_clearance = 10;
  plate_width = 100;
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
          translate([-hole_offset, 0, -plate_thickness]) nut(screw_type);
        }
      }
    }
  }
}


module side_plate(bearing_type=bearing_medium) {
  plate_width = 100;
  plate_length = get_pinion_radius(shoulder_modulus, shoulder_teeth, shoulder_teeth);
  bearing_type = bearing_medium;
  id = bearing_type[od_pos]/2 + bearing_type[id_pos]/2 + object_clearance;
  
  steel() difference() {
    union() {       
      cylinder(h=plate_thickness, d=plate_width);
      translate([-plate_width/2, 0, 0]) cube([plate_width, plate_length, plate_thickness]);
    }
    translate([0, 0, -e]) cylinder(h=plate_thickness + 2 * e, d=id);
    for (i = [0 : bearing_holes - 1]) {
      rotate([0, 0, i * 360/bearing_holes]) {
        translate([bearing_type[od_pos]/2 + screw_diameter/2 + wall_thickness, 0, -e]) 
          cylinder(h=plate_thickness + 2 * e, d=screw_diameter);
      }
    }
  }
}
