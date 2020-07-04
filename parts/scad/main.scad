include <settings.scad>
use <hand.scad>
use <elbow.scad>
use <shoulder.scad>
use <plates.scad>
use <utility.scad>



/*******************************************************************************
 *                                  MODULES                                    *
 *******************************************************************************/
 
module threaded_rods() {
  outer_rod_length = upper_arm_length - shoulder_gear_radius - 2 * object_clearance 
    - plane_thickness - plate_thickness - upper_arm_rod_offset - screw_nut_height 
    - bearing_large[h_pos] - screw_head_height;
  inner_rod_length = upper_arm_length - shoulder_gear_radius + stepper_offset - get_axle_length()
    - wheel_radius + teeth_width;
  elbow_rod_length = 2 * pinion_radius + nut_diameter + 2 * wall_thickness + bearing_small[h_pos] 
    + 2 * nut_height + 2 * spacer_thickness + 2 * object_clearance;
  forearm_rod_length = forearm_length - thread_diameter/2;
  
  echo();
  echo("\tThreaded rod lengths");
  echo(str("\tOuter rods (2x):\t", outer_rod_length/10, "cm"));
  echo(str("\tInner rod (1x):\t", inner_rod_length/10, "cm"));
  echo(str("\tElbow rod  (1x):\t", elbow_rod_length/10, "cm"));
  echo(str("\tForearm rods (2x):\t", forearm_rod_length/10, "cm"));
  echo();
  
  if (assembled) {
    // upper arm
    rotate([0, elbow_angle, 0]) {
      translate([-wheel_radius + teeth_width, 0, 0]) rotate([0, 270, 0])
        cylinder(h=inner_rod_length, d=thread_diameter);
      translate([-bearing_small[od_pos]/2 - wall_thickness, upper_arm_rod_offset, 0]) 
        rotate([0, 270, 0]) cylinder(h=outer_rod_length, d=thread_diameter);
      translate([-bearing_small[od_pos]/2 - wall_thickness, -upper_arm_rod_offset, 0]) 
        rotate([0, 270, 0]) cylinder(h=outer_rod_length, d=thread_diameter);
    }
    
    // elbow joint
    translate ([0, elbow_rod_length/2, 0]) rotate([90, 0, 0]) 
      cylinder(h=elbow_rod_length, d=thread_diameter);
    
    // forearm
    translate([thread_diameter / 2, pinion_radius - thread_diameter / 2 - wall_thickness]) 
      rotate ([0, 90, 0]) cylinder(h=forearm_rod_length, d=thread_diameter);
    translate([thread_diameter / 2, -pinion_radius + thread_diameter / 2 + wall_thickness]) 
      rotate ([0, 90, 0]) cylinder(h=forearm_rod_length, d=thread_diameter);
  }
  else rotate([0, 90, 0]) {
    // upper arm
    translate(rod_pos(3)) cylinder(h=inner_rod_length, d=thread_diameter);
    translate(rod_pos(1)) cylinder(h=outer_rod_length, d=thread_diameter);
    translate(rod_pos(2)) cylinder(h=outer_rod_length, d=thread_diameter);
    
    // elbow joint
    translate (rod_pos(0)) cylinder(h=elbow_rod_length, d=thread_diameter);
    
    // forearm
    translate(rod_pos(4)) cylinder(h=forearm_rod_length, d=thread_diameter);
    translate(rod_pos(5)) cylinder(h=forearm_rod_length, d=thread_diameter);
  }
}


module foil() {
  offset = forearm_length + thread_diameter/2 + hand_shaft_offset - nut_height;
  translate(assembled ? [offset + get_guard_thickness() - get_shaft_length(), 0, 0] : blade_pos)
    foil_blade();
  translate(assembled ? [offset + get_guard_thickness(), 0, 0] : guard_pos) 
    rotate(assembled ? [0, 90, 0] : [0, 0, 0]) foil_guard();
}


module shoulder_module_joint() {
  // wheel
  shoulder_wheel();
  
  // bearing holder
  translate([0, 0, -object_clearance]) rotate([0, 180, 180]) bearing_holder_large();
  
  // bearing_clamp
  rotate([0, 180, 180]) bearing_clamp_large();
  
  // connector
  connector_offset = 15 + plane_thickness + screw_nut_height + bearing_large[h_pos] 
    + nut_height + spacer_thickness + plate_thickness + screw_head_height + 2 * object_clearance;
  translate([0, 0, -connector_offset]) shoulder_connector();
    
  // coupler
  translate([0, 0, stepper_offset - get_axle_length() - coupler_height/2]) coupler();
  
  // plate
  translate([0, 0, -screw_nut_height - object_clearance - plate_thickness 
    - bearing_large[h_pos] - pressfit_clearance - plane_thickness]) front_plate();
}


module shoulder_module_side(dir=1) {
  bearing_holder_height = screw_nut_height + plane_thickness + bearing_medium[h_pos];
  offset = stepper_plate_offset - shoulder_gear_radius + plate_thickness;
  pinion_offset = spur_pinion_radius + spur_wheel_radius;
  clamp_offset = offset/2 + object_clearance/2;
  
  // bevel gear pinion
  shoulder_pinion();
  
  // bearing holder
  translate([0, 0, bearing_holder_height - object_clearance]) 
    rotate([0, 180, 180]) bearing_holder_wide();
    
  // bearing clamp
  translate([0, 0, -clamp_offset]) bearing_clamp_halve();
  translate([0, 0, -clamp_offset]) rotate([180, 0, 180]) bearing_clamp_halve();
  
  // shoulder spur wheel
  translate([0, 0, -offset - object_clearance - spur_teeth_width]) shoulder_spur_wheel();
  
  rotate([0, 0, dir * shoulder_angle]) {
    // bearing holder
    translate([0, 0, -offset - bearing_holder_height]) bearing_holder();

    // shoulder spur pinion
    translate([0, -pinion_offset, -spur_teeth_width - offset - object_clearance]) 
      rotate([0, 0, dir * shoulder_angle * spur_wheel_teeth/spur_pinion_teeth]) shoulder_spur_pinion();
    
    // stepper plate
    translate([0, 0, -offset]) stepper_plate();
    
    // wall mounting bracket
    translate([0, -pinion_offset, -offset - spur_teeth_width - 2 * object_clearance - plane_thickness/2]) 
      mounting_bracket_side();
  }
  
  // side plate
  translate([0, 0, -plate_thickness - object_clearance]) side_plate();
  
  bracket_offset = shoulder_gear_radius + screw_nut_height + plane_thickness + bearing_large[h_pos] 
    + object_clearance;
  
  // plate mounting bracket
  translate([0, bracket_offset, -object_clearance]) rotate([0, 90, 270]) inner_bracket();
  translate([-plate_width/2, bracket_offset + plate_thickness, -object_clearance - plate_thickness]) 
    rotate([90, 0, 90]) outer_bracket();
}


module shoulder_module() {
  clearance = 10;
  stepper_offset = shoulder_modulus * (spur_pinion_teeth + spur_wheel_teeth)/2;
  plate_offset = stepper_offset + sqrt(2) * get_hole_distance()/2 + clearance;
  
  if (assembled) {
    rotate([0, elbow_angle, 0]) translate([-upper_arm_length + shoulder_gear_radius, 0, 0]) 
      rotate([0, 270, 0]) {
        // shoulder joint
        shoulder_module_joint();
        
        // sides
        translate([0, shoulder_gear_radius, shoulder_gear_radius]) rotate([90, 180, 0]) 
          shoulder_module_side(1);
        translate([0, -shoulder_gear_radius, shoulder_gear_radius]) rotate([270, 0, 0]) 
          shoulder_module_side(-1);
        
        // wall mounting
        translate([0, 0, shoulder_gear_radius]) 
          rotate([0, -shoulder_angle, 0]) {
            // wall mounting plate
            translate([0, 0, plate_offset]) mounting_plate();
          
            // wall mounting bracket
            translate([0, -bracket_width/2, stepper_offset]) rotate([270, 0, 0]) mounting_bracket_middle();
          }
        
    }
  }
  else {
    // wheel
    translate(shoulder_wheel_pos) shoulder_wheel();
    
    // bearing holder
    translate(bearing_holder_pos) bearing_holder();
    
    // bearing_clamp
    translate(bearing_clamp_pos) bearing_clamp_large();
    
    // connector
    translate(shoulder_connector_pos) shoulder_connector();
      
    // coupler
    translate(coupler_pos) coupler();
    
    // plate
    translate(plate_pos) front_plate();
  }
}


module elbow_module() {
  if (assembled) {
    // wheel
    translate ([0, pinion_radius, 0]) rotate([90, 0, 0]) elbow_wheel();
    
    
    rotate([0, elbow_angle, 0]) {
      // pinion
      translate ([-wheel_radius, 0, 0]) rotate([0, 90, 0]) 
        rotate([0, 0, - elbow_angle * teeth_wheel/teeth_pinion]) elbow_pinion();
      
      // side connector
      translate([0, -pinion_radius, 0]) rotate([90, 0, 0]) elbow_connector();
      translate([0, pinion_radius, 0]) rotate([270, 0, 0]) elbow_connector();
      
      // cross connector
      translate([-wheel_radius - spacer_thickness - bearing_small[h_pos] - plane_thickness, 
        0, 0]) rotate([0, 90, 0]) elbow_pinion_connector(dual_nuts=false);
    }
  }
  else {
    // wheel
    translate(wheel_pos) elbow_wheel();
    
    // pinion
    translate (pinion_pos) elbow_pinion();
      
    // side connector
    offset = part_distance + pinion_radius + bearing_small[od_pos]/2 + wall_thickness 
      + pressfit_clearance;
    translate(pinion_pos + [0, -offset, 0]) elbow_connector();
    translate(pinion_pos + [0, offset, 0]) elbow_connector();
    
    // cross connector
    translate(elbow_pinion_connector_pos) elbow_pinion_connector(dual_nuts=false);
  }
}


module hand_module() {
  if (assembled) {
    translate ([forearm_length + thread_diameter/2 - hand_shaft_length + hand_shaft_offset - 
      nut_height - spacer_thickness, 0, 0]) rotate([0, 90, 0]) hand_connector();
  }
  else {
    translate (hand_pos) hand_connector();
  }
}


/*******************************************************************************
 *                                    MAIN                                     *
 *******************************************************************************/

module main() {
  // hand
  hand_module();
  
  // elbow
  elbow_module();
  
  // shoulder
  shoulder_module();
  
  // threaded rods and foil
  if (show_all) {
    stainless() threaded_rods();
    foil();
  }
  
  // spacer, nut and bearing arrangements for non assembled version
  if (!assembled) {
    for (i = [0 : len(special_spacers) - 1]) {
      translate(spacer_pos(i)) spacer(special_spacers[i]);
    }
    for (i = [0 : total_spacers - 1]) {
      translate(spacer_pos(i + len(special_spacers))) spacer();
    }
    if (show_all) {
      for (i = [0 : total_nuts - 1]) {
        translate(nut_pos(i)) stainless() nut(thread_name);
      }
      for (i = [0 : total_screws - 1]) {
        translate(screw_nut_pos(i)) stainless() nut(screw_type);
      }
      for (i = [0 : total_screws - 1]) {
        translate(screw_pos(i, (i < total_long_screws) ? 50 : screw_length)) 
          rotate([90, 0, 0]) stainless() screw((i < total_long_screws) ? screw_name_long : screw_name);
      }
      for (i = [0 : total_bearings - 1]) steel() {
        translate(bearing_pos(i)) bearing(bearing_small);
      }
    }
  }
}


main();
