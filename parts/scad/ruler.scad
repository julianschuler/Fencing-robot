length = 200;
width = 20;
arcs = [1, 1.5, 2, 2.5, 3, 3.5, 4, 4.5, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 25];
holes = [2.5, 3, 3.5, 4, 4.5, 5, 5.5, 6, 6.5, 7, 7.5, 8, 8.5, 9];
angles = [45, 50, 55, 60, 65, 70, 75, 80, 85, 90, 95, 100, 105, 110, 115, 120, 125, 130, 135];


d = 0.5;
angle_depth = 7.5;
hole_distance = 2.9;
fillet_radius = 3;
hole_start_offset = 2.5;

arc_pos = [for (i = 0, x = arcs[i]/(2 * sqrt(2)); i < len(arcs); i = i+1, 
  x = x + (arcs[i] + arcs[i-1])/(2 * sqrt(2)) + d) x];
hole_pos = [for (i = 0, x = holes[i]/2; i < len(holes); i = i+1, 
  x = x + (holes[i] + holes[i-1]) + hole_distance) x];
angle_pos = [for (i = 0, x = sin(angles[i]/2) * angle_depth; i < len(angles) - 1; i = i+1, 
  x = x + (sin(angles[i]/2) + sin(angles[i-1]/2)) * angle_depth + d) x];
arc_length = arc_pos[len(arc_pos) - 1] + arcs[len(arcs) - 1]/(2 * sqrt(2));
arc_offset = length/2 - arc_length/2;
hole_length = hole_pos[len(hole_pos) - 1] + holes[len(holes) - 1]/2;
hole_offset = length/2 - hole_length/2;
angle_length = angle_pos[len(angle_pos) - 1] + sin(angles[len(angles) - 1]/2) * angle_depth;
angle_offset = length/2 - angle_length/2;

$fn = 120;
e = 0.01;


module ruler() {
  difference() {
    union() {
      translate([0, d/sqrt(2) - d/2]) square([length, width - d/sqrt(2) + d/2]);
      translate([0, 0]) square([length/2 - arc_length/2 - d/2, d]);
      translate([length/2 + arc_length/2 + d/2, 0]) square([length/2 - arc_length/2 - d/2, d]);
      translate([arc_offset - d/2, d/sqrt(2)]) circle(d=d * sqrt(2));
      for (i = [0 : len(arcs) - 1]) {
        translate([arc_offset + arc_pos[i] + arcs[i]/(2 * sqrt(2)) + d/2, d/sqrt(2)]) circle(d=d * sqrt(2));
      }
    }
    for (i = [0 : len(arcs) - 1]) {
      translate([arc_offset + arc_pos[i], -arcs[i]/(2 * sqrt(2)) + d/sqrt(2) - d/2]) circle(d=arcs[i]);
    }
    for (i = [0 : len(holes) - 1]) {
      translate([hole_offset + hole_pos[i], (len(holes) - 1 - i) * -hole_start_offset/(len(holes) - 1) + width/2]) 
        circle(d=holes[i]);
    }
    for (i = [0 : len(angles) - 1]) {
      translate([angle_offset + angle_pos[i], width]) triangle(angles[i]);
    }
    for (pos = [[[0, 0], 0], [[length, 0], 90], [[length, width], 180], [[0, width], 270]]) {
      translate(pos[0]) fillet(fillet_radius, pos[1]);
    }
  }
}


module triangle(a = 90) {
  b = 90 - a/2;
  r = d/(2 * tan(b/2));
  c = angle_depth;
  offset = sin(a/2) * c + d/2;
  
  l_arc = [for (i = 0; i <= $fn * b / 360; i = i + 1)
    [sin(i * 360 / $fn) * r - offset, cos(i * 360 / $fn) * r - r]];
  r_arc = [for (i = $fn * b / 360; i >= 0; i = i - 1)
    [-sin(i * 360 / $fn) * r + offset, cos(i * 360 / $fn) * r - r]];
  
  polygon(concat([[sin(a/2) * c + d/2, e], [-sin(a/2) * c - d/2, e]], l_arc, [[0, -cos(a/2) * c]], r_arc), convexity=4);
}


module fillet(r = 5, orientation = 0, angle = 90) {
  arc = [for (i = 0; i <= $fn * angle / 360; i = i + 1)
    [r * (1 - sin(i * 360 / $fn)), r * (1 - cos(i * 360 / $fn))]];
  rotate([0, 0, orientation]) polygon(concat(arc, [[-e, r * (1 - cos(angle))], [-e, -e], [r, -e]]));
}

ruler();
