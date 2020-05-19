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
        rotate([0, 0, 135]) nutcatch_overhang(screw_type, screw_diameter);
      }
    }
    // arm mounting holes
    for (i = [0 : axle_holes - 1]) {
      rotate([0, 0, i * 360/axle_holes]) translate([bearing_val(bearing_type_big)[id]/4 + coupler_diameter/4
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
    for (i = [0 : axle_holes - 1]) {
      rotate([180, 0, i * 360/axle_holes]) translate([bearing_val(bearing_type_big)[id]/4 
        + coupler_diameter/4 + object_clearance/2 - pressfit_clearance, 0, 
          -plane_thickness - screw_nut_height]) 
            rotate([0, 0, 90]) stainless() nut(screw_type);
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
      cylinder(h=total_height, d=bearing_val(bearing_type_big)[od]/2 + bearing_val(bearing_type_big)[id]/2 
        - object_clearance);
      cylinder(h=total_height + bearing_val(bearing_type_big)[h]/2, d=bearing_val(bearing_type_big)[id] 
        - 2 * pressfit_clearance);
      translate([0, 0, height/2]) cube([shoulder_teeth_width, length, height], center=true);
      translate([0, length/2, 0]) cylinder(h=height, d=shoulder_teeth_width);
      translate([0, -length/2, 0]) cylinder(h=height, d=shoulder_teeth_width);
    }
    translate([0, 0, -e]) cylinder(h=total_height + bearing_val(bearing_type_big)[h]/2 + 2 * e, 
      d=thread_diameter + 2 * object_clearance);
    translate([0, length/2, -e]) cylinder(h=height + 2 * e, d=thread_diameter);
    translate([0, -length/2, -e]) cylinder(h=height + 2 * e, d=thread_diameter);
    for (i = [0 : axle_holes - 1]) {
      rotate([0, 0, i * 360/axle_holes])
        translate([bearing_val(bearing_type_big)[id]/4 + coupler_diameter/4 + object_clearance/2 
          - pressfit_clearance, 0, -e]) 
            cylinder(h=total_height + bearing_val(bearing_type_big)[h]/2 + 2 * e, d=screw_diameter);
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
          translate([bearing_val(bearing_type_big)[id]/4 + coupler_diameter/4 + object_clearance/2 
            - pressfit_clearance, 0, 0]) screw(_screw_name);
      }
    }
  }
}


module bearing_holder() {
  _screw_name = "M5x20";
  _screw_length = 19.3;
  
  offset = plane_thickness + screw_nut_height;
  height = bearing_val(bearing_type_big)[h] + offset;
  
  difference() {
    cylinder(h=height, d=bearing_val(bearing_type_big)[od] + 4 * wall_thickness + 2 * screw_diameter);
    translate([0, 0, offset]) 
      cylinder(h=height - offset + e, d=bearing_val(bearing_type_big)[od] + 2 * pressfit_clearance);
    translate([0, 0, -e]) cylinder(h=offset + 2 * e, d=bearing_val(bearing_type_big)[od]/2 
      + bearing_val(bearing_type_big)[id]/2 + object_clearance);
    for (i = [0 : bearing_holes - 1]) {
      rotate([0, 0, i * 360/bearing_holes]) {
        translate([bearing_val(bearing_type_big)[od]/2 + screw_diameter/2 + wall_thickness, 0, -e]) 
          cylinder(h=height + 2 * e, d=screw_diameter);
        translate([bearing_val(bearing_type_big)[od]/2 + screw_diameter/2 + wall_thickness, 0, 0]) 
          rotate([0, 0, 90]) nutcatch_overhang(screw_type, screw_diameter);
      }
    }
  }
  
  if (assembled) {
    // bearing
    translate([0, 0, offset])
      bearing(model=bearing_type_big);
    // nuts and bolts
    for (i = [0 : bearing_holes - 1]) stainless() {
      rotate([0, 0, i * 360/bearing_holes]) {
        translate([bearing_val(bearing_type_big)[od]/2 + screw_diameter/2 + wall_thickness, 0, 
          _screw_length]) screw(_screw_name);
        translate([bearing_val(bearing_type_big)[od]/2 + screw_diameter/2 + wall_thickness, 0, 
          screw_nut_height]) rotate([0, 0, 90]) nut(screw_type);
      }
    }
  }
}


module bearing_clamp() {
  height = plane_thickness + screw_nut_height + object_clearance;
  difference() {
    union() {
      cylinder(h=height, d=bearing_val(bearing_type_big)[od]/2 + bearing_val(bearing_type_big)[id]/2 
        - object_clearance);
      cylinder(h=height + bearing_val(bearing_type_big)[h]/2, d=bearing_val(bearing_type_big)[id] 
        - 2 * pressfit_clearance);
    }
    translate([0, 0, -e]) 
      cylinder(h=height + bearing_val(bearing_type_big)[h]/2 + 2 * e, d=coupler_diameter 
        + 2 * object_clearance);
    for (i = [0 : bearing_holes - 1]) {
      rotate([0, 0, i * 360/bearing_holes])
        translate([bearing_val(bearing_type_big)[id]/4 + coupler_diameter/4 + object_clearance/2 
          - pressfit_clearance, 0, -e]) 
            cylinder(h=height + bearing_val(bearing_type_big)[h]/2 + 2 * e, d=screw_diameter);
    }
  }
}



module coupler() {
  steel() ring(od=coupler_diameter, id=thread_diameter, h=coupler_height);
}



module plate() {
  steel() difference() {
    cube([100, 100, plate_thickness], center=true);
    cylinder(h=plate_thickness + 2 * e, d=bearing_val(bearing_type_big)[od]/2 
      + bearing_val(bearing_type_big)[id]/2 + object_clearance, center=true);
    for (i = [0 : bearing_holes - 1]) {
      rotate([0, 0, i * 360/bearing_holes]) {
        translate([bearing_val(bearing_type_big)[od]/2 + screw_diameter/2 + wall_thickness, 0, 0]) 
          cylinder(h=plate_thickness + 2 * e, d=screw_diameter, center=true);
      }
    }
  }
}


module nutcatch_overhang(name, diameter, clearance=sliding_clearance) {
  difference () {
    translate([0, 0, -e]) rotate([180, 0, 0]) nutcatch_parallel(name, 
      nut_height + 2 * layer_height + e, clearance);
    translate([-diameter, diameter/2, nut_height]) 
      cube([2 * diameter, diameter/2, 2 * layer_height + e]);
    translate([-diameter, - diameter, nut_height]) 
      cube([2 * diameter, diameter/2, 2 * layer_height + e]);
    translate([diameter/2, -diameter, nut_height + layer_height]) 
      cube([diameter/2, 2 * diameter, layer_height + e]);
    translate([-diameter, -diameter, nut_height + layer_height]) 
      cube([diameter/2, 2 * diameter, layer_height + e]);
  }
}


module gears() {
  // gears
  translate([0, get_wheel_radius(shoulder_modulus, shoulder_teeth, shoulder_teeth), 
    get_wheel_radius(shoulder_modulus, shoulder_teeth, shoulder_teeth)]) 
      rotate([90, 180, 0]) {
        bevel_gear_pinion(shoulder_modulus, shoulder_teeth, shoulder_teeth, shoulder_teeth_width, 0,
          helix_angle=helix_angle);
        rotate([0, 180, 0]) 
          bevel_gear_wheel(modulus, teeth_pinion, teeth_wheel, teeth_width, 0, helix_angle=helix_angle);
      }
    
    
  translate([0, -get_wheel_radius(shoulder_modulus, shoulder_teeth, shoulder_teeth), 
    get_wheel_radius(shoulder_modulus, shoulder_teeth, shoulder_teeth)]) 
      rotate([270, 180, 0]) bevel_gear_pinion(shoulder_modulus, shoulder_teeth, shoulder_teeth,
        shoulder_teeth_width, 0, helix_angle=helix_angle);

}
