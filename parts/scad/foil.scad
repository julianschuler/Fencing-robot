// blade settings
blade_length = 900;
blade_tip_width = 4;
blade_tip_height = 3.2;
blade_bottom_width = 12;
blade_bottom_height = 8;
shaft_square_length = 40;
shaft_square_size = 6;
shaft_taper_length = 20;
shaft_thread_length = 32;
shaft_thread_diameter = 6;

// guard settings
guard_diameter = 100;
guard_thickness = 1.2;
guard_height = 18;
guard_plate_diameter = 33.5;
guard_plate_thickness = 1.4;
guard_square_size = 7;



function get_shaft_length() = shaft_square_length + shaft_thread_length;
function get_blade_height() = blade_bottom_height;
function get_blade_width() = blade_bottom_width;

function get_guard_height() = guard_height + guard_plate_thickness;
function get_guard_diameter() = guard_diameter;
function get_guard_thickness() = guard_thickness + guard_plate_thickness;


module foil_blade() {
  color("#808080") rotate([0, 90, 0]) union() {
    // shaft section
    cylinder(h=shaft_thread_length, d=shaft_thread_diameter);
    intersection() {
      translate([-shaft_square_size/2, -shaft_square_size/2, shaft_thread_length])
        cube([shaft_square_size, shaft_square_size, shaft_square_length]);
      translate([0, 0, shaft_thread_length]) cylinder(h=shaft_square_length, d1=shaft_thread_diameter, 
        d2=shaft_square_size * sqrt(2) * shaft_square_length/shaft_taper_length);
    }
    
    // blade section
    translate([0, 0, get_shaft_length()]) linear_extrude(height=blade_length,
      scale=[blade_tip_height/blade_bottom_height, blade_tip_width/blade_bottom_width]) 
        square([blade_bottom_height, blade_bottom_width], center=true);
  }
}


module foil_guard() {
  sphere_diameter = guard_height + (guard_diameter * guard_diameter)/(4 * guard_height);
  color("#808080") translate ([0, 0, -sphere_diameter/2 - guard_plate_thickness]) difference() {
    union() {
      intersection() {
        sphere(d=sphere_diameter);
        translate([0, 0, sphere_diameter/2 - guard_height]) cylinder(h=guard_height, d=guard_diameter);
      }
      intersection() {
        sphere(d=sphere_diameter + 2 * guard_plate_thickness);
        cylinder(h=sphere_diameter + guard_plate_thickness, d=guard_plate_diameter);
      }
    }
    sphere(d=sphere_diameter - guard_thickness);
    translate([-guard_square_size/2, -guard_square_size/2, 0]) 
      cube([guard_square_size, guard_square_size, sphere_diameter]);
  }
}
