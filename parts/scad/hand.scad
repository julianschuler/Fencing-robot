include <settings.scad>
use <utility.scad>



module hand_connector() {
  difference() {
    union() {
      translate([0, -pinion_radius + wall_thickness + thread_diameter / 2, 0]) 
        cylinder(h=hand_shaft_length - hand_shaft_offset, d=thread_diameter + 2 * wall_thickness);
      translate([0, pinion_radius - wall_thickness - thread_diameter / 2, 0]) 
        cylinder(h=hand_shaft_length - hand_shaft_offset, d=thread_diameter + 2 * wall_thickness);
      translate([-wall_thickness - thread_diameter/2, 
        -pinion_radius + wall_thickness + thread_diameter/2, 0])
          cube([thread_diameter + 2 * wall_thickness, 2 * pinion_radius - 2 * wall_thickness - 
            thread_diameter, hand_shaft_length - hand_shaft_offset]);
      translate ([-wall_thickness - thread_diameter/2, 
        -pinion_radius + thread_diameter + 2 * wall_thickness, 0]) 
          cube([thread_diameter + 2 * wall_thickness, 
            2 * pinion_radius - 2 * thread_diameter - 4 * wall_thickness, hand_shaft_length]);
    }
    translate([0, -pinion_radius + wall_thickness + thread_diameter / 2, -e]) 
      cylinder(h=hand_shaft_length - hand_shaft_offset + 2 * e, d=thread_diameter);
    translate([0, pinion_radius - wall_thickness - thread_diameter / 2, -e]) 
      cylinder(h=hand_shaft_length - hand_shaft_offset + 2 * e, d=thread_diameter);
    translate ([0, 0, -e]) 
      cylinder(h=hand_shaft_length + 2 * e, d=hand_shaft_diameter);
    translate([-hand_square_size / 2, -hand_square_size / 2, hand_shaft_length - hand_square_length]) 
      cube ([hand_square_size + sliding_clearance, hand_square_size + sliding_clearance, 
        hand_square_length + e]);
  }
  
  // special spacer
  translate(assembled ? [0, 0, hand_shaft_length] : 
    [0, -pinion_radius - part_distance -hand_spacer_diameter/2, 0]) color("orange") difference() {
    cylinder(h=spacer_thickness, d=hand_spacer_diameter);
    translate([-hand_square_size/2 -sliding_clearance/2, -hand_square_size/2 - sliding_clearance/2,
     -e]) cube([hand_square_size + sliding_clearance, hand_square_size + sliding_clearance,
        spacer_thickness + 2 * e]);
  }
  
  if (assembled) {
    // spacers
    translate([0, -pinion_radius + wall_thickness + thread_diameter / 2, -spacer_thickness]) spacer();
    translate([0, +pinion_radius - wall_thickness - thread_diameter / 2, -spacer_thickness]) spacer();
    translate([0, -pinion_radius + wall_thickness + thread_diameter / 2, 
      hand_shaft_length - hand_shaft_offset]) spacer();
    translate([0, +pinion_radius - wall_thickness - thread_diameter / 2, 
      hand_shaft_length - hand_shaft_offset]) spacer();
    
    if (show_all) {
      // nuts
    translate([0, -pinion_radius + wall_thickness + thread_diameter / 2, -spacer_thickness]) 
      stainless() nut(thread_name);
    translate([0, +pinion_radius - wall_thickness - thread_diameter / 2, -spacer_thickness])
      stainless() nut(thread_name);
    translate([0, -pinion_radius + wall_thickness + thread_diameter / 2, hand_shaft_length -
      hand_shaft_offset + spacer_thickness + nut_height]) stainless() nut(thread_name);
    translate([0, +pinion_radius - wall_thickness - thread_diameter / 2, hand_shaft_length -
      hand_shaft_offset + spacer_thickness + nut_height]) stainless() nut(thread_name);
    }
  }
}
