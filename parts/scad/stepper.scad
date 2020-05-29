include <libraries/MCAD/stepper.scad>



Nema23Custom = [
    [NemaModel, 23],
    [NemaLengthShort, 39*mm],
    [NemaLengthMedium, 54*mm],
    [NemaLengthLong, 83.5*mm],
    [NemaSideSize, 56.4*mm], 
    [NemaDistanceBetweenMountingHoles, 47.14*mm], 
    [NemaMountingHoleDiameter, 4.75*mm], 
    [NemaMountingHoleDepth, 5.05*mm], 
    [NemaMountingHoleLip, 5*mm], 
    [NemaMountingHoleCutoutRadius, 9.5*mm], 
    [NemaEdgeRoundingRadius, 2.5*mm], 
    [NemaRoundExtrusionDiameter, 38.10*mm], 
    [NemaRoundExtrusionHeight, 1.52*mm], 
    [NemaAxleDiameter, 8*mm], 
    [NemaFrontAxleLength, 18.80*mm], 
    [NemaBackAxleLength, 15.60*mm],
    [NemaAxleFlatDepth, 0.5*mm],
    [NemaAxleFlatLengthFront, 16*mm],
    [NemaAxleFlatLengthBack, 14*mm]
];


function get_axle_length() = lookup(NemaBackAxleLength, Nema23Custom);
function get_side_size() = lookup(NemaSideSize, Nema23Custom);
function get_hole_count() = 4;
function get_hole_distance() = lookup(NemaDistanceBetweenMountingHoles, Nema23Custom);
function get_plate_thickness() = lookup(NemaMountingHoleLip, Nema23Custom);
function get_extrusion_diameter() = lookup(NemaRoundExtrusionDiameter, Nema23Custom);
function get_extrusion_thickness() = lookup(NemaRoundExtrusionHeight, Nema23Custom);


module stepper() {
  translate([0, 0, -get_extrusion_thickness()]) motor(Nema23Custom, NemaLong);
}
