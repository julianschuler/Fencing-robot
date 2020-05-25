include <settings.scad>
use <hand.scad>
use <elbow.scad>
use <shoulder.scad>
use <utility.scad>



/*******************************************************************************
 *                                  MODULES                                    *
 *******************************************************************************/
 
module threaded_rods() {
  outer_rod_length = upper_arm_length - shoulder_wheel_radius - 2 * object_clearance 
    - plane_thickness - plate_thickness - upper_arm_rod_offset - screw_nut_height 
    - bearing_large[h_pos] - screw_head_height;
  inner_rod_length = upper_arm_length - shoulder_wheel_radius + stepper_offset - get_axle_length()
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


module shoulder_module() {
  if (assembled) {
    rotate([0, elbow_angle, 0]) translate([-upper_arm_length + shoulder_wheel_radius, 0, 0]) 
      rotate([0, 270, 0]) {
        // wheel
        shoulder_wheel();
        
        // side gears
        translate([0, get_wheel_radius(shoulder_modulus, shoulder_teeth, shoulder_teeth) + teeth_width, 
          get_wheel_radius(shoulder_modulus, shoulder_teeth, shoulder_teeth)]) 
            rotate([90, 180, 0]) shoulder_gear();
        
        // bearing holder
        translate([0, 0, -object_clearance]) rotate([0, 180, 180]) bearing_holder();
        
        // bearing_clamp
        rotate([0, 180, 180]) bearing_clamp();
        
        // connector
        connector_offset = 15 + plane_thickness + screw_nut_height + bearing_large[h_pos] 
          + nut_height + spacer_thickness + plate_thickness + screw_head_height + 2 * object_clearance;
        translate([0, 0, -connector_offset]) shoulder_connector();
          
        // coupler
        translate([0, 0, stepper_offset - get_axle_length() - coupler_height/2]) coupler();
        
        // plate
        translate([0, 0, -screw_nut_height - object_clearance - plate_thickness/2 
          - bearing_large[h_pos] - pressfit_clearance - plane_thickness]) plate();
    }
  }
  else {
    // wheel
    translate(shoulder_wheel_pos) shoulder_wheel();
    
    // bearing holder
    translate(bearing_holder_pos) bearing_holder();
    
    // bearing_clamp
    translate(bearing_clamp_pos) bearing_clamp();
    
    // connector
    translate(shoulder_connector_pos) shoulder_connector();
      
    // coupler
    translate(coupler_pos) coupler();
    
    // plate
    translate(plate_pos) plate();
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
      for (i = [0 : total_bearings - 1]) steel() {
        translate(bearing_pos(i)) bearing(bearing_small);
      }
    }
  }
}


main();
