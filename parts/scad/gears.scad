include <libraries/Getriebe.scad>
include <libraries/nutsnbolts/cyl_head_bolt.scad>



function get_pinion_radius(modulus, teeth_pinion, teeth_wheel) = 
  let(delta = atan(teeth_wheel / teeth_pinion))
  let(rg = modulus * teeth_wheel / (2 * sin(delta)))
  rg * cos(delta - (210 * modulus) / (pi * rg));


function get_wheel_radius(modulus, teeth_pinion, teeth_wheel) = 
  let(delta = atan(teeth_pinion / teeth_wheel))
  let(rg = modulus * teeth_pinion / (2 * sin(delta)))
  rg * cos(delta - (210 * modulus) / (pi * rg));



module bevel_gear_pinion(modulus, teeth_pinion, teeth_wheel, teeth_width, hole_diameter, helix_angle=0,   
  pressure_angle=20) {
    pfeilkegelrad(modulus, teeth_pinion, atan(teeth_pinion/teeth_wheel), teeth_width, hole_diameter,
      pressure_angle, -helix_angle);
}


module bevel_gear_wheel(modulus, teeth_pinion, teeth_wheel, teeth_width, hole_diameter, helix_angle=0, 
  pressure_angle=20) {
    rotate([0, 0, 180 * (1) / teeth_wheel * ((teeth_pinion % 2 == 0) ? 1 : 0)])
      pfeilkegelrad(modulus, teeth_wheel, atan(teeth_wheel/teeth_pinion), teeth_width, hole_diameter, 
        pressure_angle, helix_angle);
}


module spur_gear(modulus, teeth, teeth_width, hole_diameter, helix_angle=0, pressure_angle=20) {
  pfeilrad(modulus, teeth, teeth_width, hole_diameter, pressure_angle, helix_angle, optimiert=false);
}
