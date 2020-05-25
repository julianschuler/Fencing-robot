include <settings.scad>
use <utility.scad>



module bearing(model=[22, 8, 7]) {
  // outer dimensions
  h = model[h_pos];
  id = model[id_pos];
  od = model[od_pos];

  // rim and sink dimensions
  ir = id + (od - id) * 0.2;
  or = od - (od - id) * 0.2;
  s = h * 0.1;
  
  difference() {
    ring(od, id, h);
    translate([0, 0, -e]) ring(or, ir, s + e);
    translate([0, 0, h - s]) ring(or, ir, s + e);
  }
}
