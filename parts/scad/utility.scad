include <settings.scad>



module spacer(thickness=spacer_thickness) {
  color("orange") ring(spacer_diameter, thread_diameter, thickness);
}


module ring(od, id, h, center=false) {
  difference () {
    cylinder(h=h, d=od, center=center);
    translate([0, 0, center ? 0 : -e]) cylinder(h=h + 2 * e, d=id, center=center);
  }
}
