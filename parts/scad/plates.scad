include <settings.scad>
use <stepper.scad>
use <utility.scad>



module front_plate(bearing_type=bearing_large) {
  plate_length = 2 * shoulder_gear_radius + 2 * object_clearance;
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
  stepper_offset = spur_pinion_radius + spur_wheel_radius;
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
  plate_length = shoulder_gear_radius + object_clearance + plate_offset;
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
  length = 2 * (stepper_plate_offset + plate_thickness + lid_thickness + spur_teeth_width 
    + 2 * object_clearance);
  width = plate_width;
  outer_screw_offset = length/2 - lid_thickness - object_clearance - spur_teeth_width/2;
  screw_height_offset = plate_thickness + screw_spacer_thickness;
  
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
  
  if (assembled) {
    for (i = [1 : outer_screws/2]) {
      // left screws, nuts and spacers
      translate([i * plate_width/(outer_screws + 1), outer_screw_offset, screw_height_offset]) {
        stainless() screw(screw_name);
        translate([0, 0, -screw_spacer_thickness]) screw_spacer();
        translate([0, 0, -screw_length]) rotate([180, 0, 90]) stainless() nut(screw_type);
      }
      translate([i * -plate_width/(outer_screws + 1), outer_screw_offset, screw_height_offset]) {
        stainless() screw(screw_name);
        translate([0, 0, -screw_spacer_thickness]) screw_spacer();
        translate([0, 0, -screw_length]) rotate([180, 0, 90]) stainless() nut(screw_type);
      }
      // right screws, nuts and spacers
      translate([i * plate_width/(outer_screws + 1), -outer_screw_offset, screw_height_offset]) {
        stainless() screw(screw_name);
        translate([0, 0, -screw_spacer_thickness]) screw_spacer();
        translate([0, 0, -screw_length]) rotate([180, 0, 90]) stainless() nut(screw_type);
      }
      translate([i * -plate_width/(outer_screws + 1), -outer_screw_offset, screw_height_offset]) {
        stainless() screw(screw_name);
        translate([0, 0, -screw_spacer_thickness]) screw_spacer();
        translate([0, 0, -screw_length]) rotate([180, 0, 90]) stainless() nut(screw_type);
      }
    }
    for (i = [1 : inner_screws/2]) {
      // middle screws, nuts and spacers
      translate([i * plate_width/(outer_screws + 1), 0, screw_height_offset]) {
        stainless() screw(screw_name);
        translate([0, 0, -screw_spacer_thickness]) screw_spacer();
        translate([0, 0, -screw_length]) rotate([180, 0, 90]) stainless() nut(screw_type);
      }
      translate([i * -plate_width/(outer_screws + 1), 0, screw_height_offset]) {
        stainless() screw(screw_name);
        translate([0, 0, -screw_spacer_thickness]) screw_spacer();
        translate([0, 0, -screw_length]) rotate([180, 0, 90]) stainless() nut(screw_type);
      }
    }
  }
}


module inner_bracket() {
  width = screw_length - plate_thickness - wall_thickness;
  height = bearing_large[h_pos] + plane_thickness + screw_nut_height;
  length = plate_width;
  screw_offset = width/3;
  screw_offset_side = height/2;
  orientation = 0;
  
  translate([-width, -length/2, 0]) difference() {
    cube([width, length, height]);
    for (i = [0 : bracket_holes - 1]) {
      translate([0, i * length/bracket_holes + length/(2 * bracket_holes), 0]) {
        if (i % 2 == orientation) {
          translate([width - screw_offset, 0, -e]) cylinder(h=height + 2 * e, d=screw_diameter);
          translate([width - screw_offset, 0, height + e]) rotate([0, 0, 90])
            nutcatch_parallel(screw_type, l=screw_nut_height + e, clk=sliding_clearance);
        }
        else {
          translate([-e, 0, screw_offset_side]) rotate ([0, 90, 0]) 
            cylinder(h=width + 2 * e, d=screw_diameter);
          translate([-e, 0, screw_offset_side]) rotate ([0, 90, 180]) rotate([0, 0, 90])
            nutcatch_parallel(screw_type, l=screw_nut_height + e, clk=sliding_clearance);
        }
      }
    }
  }
  
  // screws and nuts
  if (assembled) stainless() {
    for (i = [0 : bracket_holes - 1]) {
      translate([0, i * length/bracket_holes + length/(2 * bracket_holes) - length/2, 0]) {
        if (i % 2 == bracket_orientation) {
          translate([-screw_offset, 0, height]) rotate([0, 0, 90]) nut(screw_type);
          translate([-screw_offset, 0, height - screw_length]) rotate([180, 0, 0]) screw(screw_name);
        }
        else {
          translate([-width, 0, height/2]) rotate ([0, 270, 0]) rotate([0, 0, 90]) nut(screw_type);
          translate([screw_length - width, 0, height/2]) rotate([0, 90, 0]) screw(screw_name);
        }
      }
    }
  }
}


module outer_bracket() {
  length = screw_length - wall_thickness;
  width = screw_length - bearing_large[h_pos] - plane_thickness - screw_nut_height - plate_thickness;
  height = plate_width;
  lid_length = width + bearing_large[h_pos] + plane_thickness + screw_nut_height + plate_thickness;
  screw_offset = plate_thickness + (bearing_large[h_pos] + plane_thickness + screw_nut_height)/2;
  screw_offset_side = plate_thickness + (screw_length - plate_thickness - wall_thickness)/3;
  
  difference() {
    union() {
      cube([width, length, height]);
      translate([-plate_thickness, 0, 0]) cube([plate_thickness, plate_thickness, height]);
      translate([-lid_length + width, -wall_thickness, 0]) cube([lid_length, wall_thickness, height]);
    }
    // chamfer
    translate([width - chamfer_depth, -wall_thickness, -e]) rotate([0, 0, -45]) 
      cube([chamfer_depth * sqrt(2), chamfer_depth * sqrt(2), height + 2 * e]);
    // mounting holes
    for (i = [0 : bracket_holes - 1]) {
      translate([0, 0, i * height/bracket_holes + height/(2 * bracket_holes)]) {
        if (i % 2 == bracket_orientation) {
          translate([-e, screw_offset_side, 0]) rotate([0, 90, 0]) 
            cylinder(h=width + 2 * e, d=screw_diameter);
        }
        else {
          translate([-screw_offset, e, 0]) rotate([90, 0, 0]) 
            cylinder(h=wall_thickness + 2 * e, d=screw_diameter);
        }
      }
    }
  }
}


module mounting_bracket_side() {
  height = spur_teeth_width + 2 * object_clearance;
  width = plate_width;
  length = width;
  offset = stepper_hole_offset * sqrt(2) + plate_clearance;
  lid_thickness = plane_thickness/2;
  slot_height = height + lid_thickness + plate_thickness + stepper_plate_thickness + screw_nut_height
    - screw_length;
  screw_offset = spur_teeth_width/2 + object_clearance + lid_thickness;
  nut_offset = screw_length - plate_thickness - screw_spacer_thickness;
  
  difference() {
    translate([-length/2, -offset, 0]) cube([width, length, height + lid_thickness]);
    translate([0, 0, lid_thickness]) cylinder(h=height + 2 * e, r=spur_pinion_radius + gear_clearance);
    translate([0, spur_pinion_radius + spur_wheel_radius, lid_thickness]) 
      cylinder(h=height + 2 * e, r=spur_wheel_radius + gear_clearance);
    translate([0, spur_pinion_radius + spur_wheel_radius, -e]) 
      cylinder(h=lid_thickness + 2 * e, r=spur_wheel_radius - gear_clearance);
    
    for (i = [0 : stepper_holes - 2]) {
      rotate([0, 0, i * 360/stepper_holes]) translate([-stepper_hole_offset * sqrt(2), 0, -e]) {
        cylinder(h=height + lid_thickness + 2 * e, d=screw_diameter); 
        rotate([0, 0, 90]) nutcatch_overhang(screw_type, screw_diameter, slot_height + e);
      }
    }
    
    // screw holes and nutcaches
    for (i = [1 : outer_screws/2]) {
      translate([i * plate_width/(outer_screws + 1), -offset + nut_offset, screw_offset]) {
        rotate([0, 0, 270]) cylinder_overhang(h=nut_offset + e, d=screw_diameter);
        rotate([270, 90, 0]) nutcatch_sidecut(screw_type, l=screw_offset + e, clk=sliding_clearance, 
          clh=sliding_clearance, clsl=sliding_clearance);
      }
      translate([i * -plate_width/(outer_screws + 1), -offset + nut_offset, screw_offset]) {
        rotate([0, 0, 270]) cylinder_overhang(h=nut_offset + e, d=screw_diameter);
        rotate([270, 90, 0]) nutcatch_sidecut(screw_type, l=screw_offset + e, clk=sliding_clearance, 
          clh=sliding_clearance, clsl=sliding_clearance);
      }
    }
  }
}


module mounting_bracket_middle() {
  cable_diameter = 7;
  stepper_width = 65;
  height = bracket_width;
  width = plate_width;
  offset = stepper_hole_offset * sqrt(2) + plate_clearance;
  bracket_thickness = (width/sqrt(2) - stepper_size)/2;
  nut_offset = screw_length - plate_thickness - screw_spacer_thickness;
  
  difference() {
    union() {
      intersection() {
        translate([0, -width/2, 0]) rotate([0, 0, 45]) cube([width/sqrt(2), width/sqrt(2), height]);
        translate([-width/2, -offset, 0]) 
          cube([width, offset + stepper_width/2 + bracket_thickness, height]);
      }
      translate([-width/2, -offset, 0]) cube([width, offset, height]);
    }
    intersection() {
      translate([0, -sqrt(2) * stepper_size/2, -e]) rotate([0, 0, 45]) 
        cube([stepper_size, stepper_size, height + 2 * e]);
      translate([-stepper_width/2, -stepper_width/2, -e]) 
        cube([stepper_width, stepper_width, height + 2 * e]);
    }
    translate([-stepper_size/(2 * sqrt(2)), -stepper_size/(2 * sqrt(2)), -e]) 
      cylinder(h=height + 2 * e, d=cable_diameter);
    
    // screw holes and nutcaches
    for (i = [1 : inner_screws/2]) {
      translate([i * plate_width/(inner_screws + 1), -offset + nut_offset, height/2]) {
        rotate([0, 0, 270]) cylinder_overhang(h=nut_offset + e, d=screw_diameter);
        rotate([270, 270, 0]) nutcatch_sidecut(screw_type, l=height/2 + e, clk=sliding_clearance, 
          clh=sliding_clearance, clsl=sliding_clearance);
      }
      translate([i * -plate_width/(inner_screws + 1), -offset + nut_offset, height/2]) {
        rotate([0, 0, 270]) cylinder_overhang(h=nut_offset + e, d=screw_diameter);
        rotate([270, 270, 0]) nutcatch_sidecut(screw_type, l=height/2 + e, clk=sliding_clearance, 
          clh=sliding_clearance, clsl=sliding_clearance);
      }
    }
  }
}
