include <settings.scad>



module ring(od, id, h, center=false) {
  difference () {
    cylinder(h=h, d=od, center=center);
    translate([0, 0, center ? 0 : -e]) cylinder(h=h + 2 * e, d=id, center=center);
  }
}


module spacer(thickness=spacer_thickness) {
  color("orange") ring(spacer_diameter, thread_diameter, thickness);
}


module special_spacer() {
  spacer(special_spacers[0]);
}


module nutcatch_overhang(name, diameter, height, clearance=sliding_clearance) {
  difference () {
    translate([0, 0, -e]) rotate([180, 0, 0]) nutcatch_parallel(name, 
      height + 2 * layer_height + e, clearance);
    translate([-diameter, diameter/2, height]) 
      cube([2 * diameter, diameter/2, 2 * layer_height + e]);
    translate([-diameter, - diameter, height]) 
      cube([2 * diameter, diameter/2, 2 * layer_height + e]);
    translate([diameter/2, -diameter, height + layer_height]) 
      cube([diameter/2, 2 * diameter, layer_height + e]);
    translate([-diameter, -diameter, height + layer_height]) 
      cube([diameter/2, 2 * diameter, layer_height + e]);
  }
}


module cylinder_overhang(h, d, overhang_angle=30) {
  rotate([0, 90, 0]) cylinder(h=h, d=d);
  translate([0, -tan(overhang_angle/2) * d/2, 0]) cube([h, tan(overhang_angle/2) * d, d/2]);
  rotate([overhang_angle, 0, 0]) cube([h, tan(overhang_angle/2) * d/2, d/2]);
  rotate([-overhang_angle, 0, 0]) translate([0, -tan(overhang_angle/2) * d/2, 0]) 
    cube([h, tan(overhang_angle/2) * d/2, d/2]);
}
