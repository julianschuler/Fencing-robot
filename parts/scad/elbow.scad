include <settings.scad>
use <utility.scad>



module elbow_pinion() {
  difference() {
    // actual gear
    bevel_gear_pinion(modulus, teeth_pinion, teeth_wheel, teeth_width, thread_diameter, 
      helix_angle=helix_angle);
    
    // nutcatch
    translate([0, 0, teeth_width]) 
      nutcatch_parallel(thread_name, nut_height, pressfit_clearance);
  }
  
  if (assembled) {
    // spacer
    translate([0, 0, -spacer_thickness]) spacer();
    
    // nut
    if (show_all) {
      translate([0, 0, teeth_width]) stainless() nut(thread_name);
    }
  }
}


module elbow_wheel() {
  difference() {
    union() {
      // actual gear
      bevel_gear_wheel(modulus, teeth_pinion, teeth_wheel, teeth_width, 0, helix_angle=helix_angle);
      
      // rod mount
      translate ([0, -thread_diameter/2 - wall_thickness]) 
        cube ([wheel_radius, thread_diameter + 2 * wall_thickness, 2 * pinion_radius]);
      cylinder(h=2 * pinion_radius, d=thread_diameter + 2 * wall_thickness);
    }
    // rod mount
    translate([0, 0, -e]) cylinder(h=2 * pinion_radius + 2 * e, d=thread_diameter);
    translate([0, 0, thread_diameter/2 + wall_thickness]) rotate ([0, 90, 0])
      cylinder(h=wheel_radius + e, d=thread_diameter);
    translate([0, 0, 2 * pinion_radius - thread_diameter/2 - wall_thickness]) rotate ([0, 90, 0])
      cylinder(h=wheel_radius + e, d=thread_diameter);
    
    // nutcatches
    translate([thread_diameter/2 + wall_thickness, 0, thread_diameter/2 + wall_thickness]) 
      rotate([0, 90, 180]) nutcatch_sidecut(thread_name, l=2 * thread_diameter, clk=sliding_clearance,
        clsl=sliding_clearance);
    translate([thread_diameter/2 + wall_thickness, 0, 2 * pinion_radius - thread_diameter/2 -
      wall_thickness]) rotate([0, 270, 0]) nutcatch_sidecut(thread_name, l=2 * thread_diameter, 
        clk=sliding_clearance, clsl=sliding_clearance);
  }
  
  if (assembled) {
    // spacers
    translate([wheel_radius, 0, thread_diameter / 2 + wall_thickness]) rotate([0, 90, 0]) spacer();
    translate([wheel_radius, 0, 2 * pinion_radius - thread_diameter / 2 - wall_thickness]) 
      rotate([0, 90, 0]) spacer();

    if (show_all) {
      // nuts
      translate([thread_diameter/2 + wall_thickness, 0, thread_diameter/2 + wall_thickness]) 
        rotate([0, 270, 0]) stainless() nut(thread_name);
      translate([thread_diameter/2 + wall_thickness, 0, 
        2 * pinion_radius - thread_diameter/2 - wall_thickness]) rotate([0, 270, 0]) 
          stainless() nut(thread_name);
      translate([wheel_radius + spacer_thickness, 0, thread_diameter/2 + wall_thickness]) 
        rotate([0, 270, 0]) stainless() nut(thread_name);
      translate([wheel_radius + spacer_thickness, 0, 
        2 * pinion_radius - thread_diameter/2 - wall_thickness]) 
          rotate([0, 270, 0]) stainless() nut(thread_name);
    }
  }
}


module elbow_connector() {
  dia = bearing_val(bearing_type_small)[od] + 2 * pressfit_clearance;
  height = nut_diameter + 2 * wall_thickness;
  
  translate([0, 0, object_clearance]) {
    difference() {
      union() {
        cylinder(h=height, d=dia + 2 * wall_thickness);
        translate([0, height/2, 0]) rotate([0, 0, 180]) 
          cube([wheel_radius + spacer_thickness, height, height/2]);
        translate([0, 0, height/2]) rotate([0, 270, 0]) 
          cylinder(h=wheel_radius + spacer_thickness, d=height);
      }
      translate([0, 0, height/2 - bearing_val(bearing_type_small)[h]/2]) 
        cylinder(h=height/2 + bearing_val(bearing_type_small)[h]/2 + e, d=dia);
      translate([0, 0, -e]) 
        cylinder(h=height/2 - bearing_val(bearing_type_small)[h]/2 + 2 * e, 
          d=spacer_diameter + 2 * object_clearance);
      translate([-dia/2 - wall_thickness, 0, height/2]) rotate([0, 270, 0]) 
        cylinder(h=wheel_radius -dia/2 - wall_thickness + spacer_thickness + e, d=thread_diameter);
      translate([-dia/2 - wall_thickness, 0, height/2]) rotate([0, 270, 180]) 
        nutcatch_sidecut(thread_name, l=2 * thread_diameter, clk=sliding_clearance, clh=sliding_clearance, 
          clsl=sliding_clearance);
      
    }
    
    if (assembled) {
      // spacers
      translate([0, 0, height/2 + bearing_val(bearing_type_small)[h]/2]) spacer();
      translate([0, 0, -object_clearance]) 
        spacer(height/2 - bearing_val(bearing_type_small)[h]/2 + object_clearance);
      
      if (show_all) {
        // nuts
        translate([-dia/2 - wall_thickness - pressfit_clearance, 0, height/2]) rotate([0, 90, 0]) 
          stainless() nut(thread_name);
        translate([0, 0, height/2 + bearing_val(bearing_type_small)[h]/2 + spacer_thickness + nut_height]) 
          stainless() nut(thread_name);
        
        // bearings
        bearing(pos=[0, 0, height/2 - bearing_val(bearing_type_small)[h]/2], model=bearing_type_small);
      }
    }
  }
}


module elbow_pinion_connector(dual_nuts=true) {
  shoulder_teeth_width = nut_diameter + 2 * wall_thickness;
  length = 2 * upper_arm_rod_offset;
  height = bearing_val(bearing_type_small)[h] + plane_thickness;
  
  difference() {
    union() {
      translate([0, 0, height/2]) cube([shoulder_teeth_width, length, height], center=true);
      cylinder(h=height, d=bearing_val(bearing_type_small)[od] + 2 * wall_thickness 
        + 2 * pressfit_clearance);
      translate([0, length/2, 0]) cylinder(h=height, d=shoulder_teeth_width);
      translate([0, -length/2, 0]) cylinder(h=height, d=shoulder_teeth_width);
    }
    translate([0, 0, -e]) cylinder(h=plane_thickness + 2 * e, d=spacer_diameter + 2 * object_clearance);
    translate([0, 0, plane_thickness]) 
      cylinder(h=bearing_val(bearing_type_small)[h] + pressfit_clearance + e, 
        d=bearing_val(bearing_type_small)[od] + 2 * pressfit_clearance);
    translate([0, length/2, -e]) cylinder(h=height + 2 * e, d=thread_diameter);
    translate([0, -length/2, -e]) cylinder(h=height + 2 * e, d=thread_diameter);
  }
  
  if (assembled) {
    // spacers
    translate([0, 0, wall_thickness + pressfit_clearance - spacer_thickness]) spacer();
    translate([0, length/2, -spacer_thickness]) spacer();
    translate([0, -length/2, -spacer_thickness]) spacer();
    if (dual_nuts) {
      translate([0, 0, height]) spacer();
      translate([0, length/2, height]) spacer();
      translate([0, -length/2, height]) spacer();
    }
    
    if (show_all) {
      // nuts
      translate([0, 0, wall_thickness + pressfit_clearance]) stainless() nut(thread_name);
      translate([0, length/2, -spacer_thickness]) stainless() nut(thread_name);
      translate([0, -length/2, -spacer_thickness]) stainless() nut(thread_name);
      if (dual_nuts) {
        translate([0, 0, height + spacer_thickness + nut_height]) stainless() nut(thread_name);
        translate([0, length/2, height + nut_height]) stainless() nut(thread_name);
        translate([0, -length/2, height + nut_height]) stainless() nut(thread_name);
      }
      
      //bearing
      bearing(pos=[0, 0, plane_thickness], model=bearing_type_small);
    }
  }
}