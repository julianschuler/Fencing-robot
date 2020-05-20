use <libraries/nutsnbolts/cyl_head_bolt.scad>
use <libraries/nutsnbolts/materials.scad>
use <libraries/MCAD/bearing.scad>
use <gears.scad>
use <foil.scad>
use <stepper.scad>



/*******************************************************************************
 *                                  SETTINGS                                   *
 *******************************************************************************/

// set true to show assembled version
previewAssembly = true;

// angle at the elbow joint when assembled
elbow_angle = 80;

// general settings
upper_arm_length = 350;
forearm_length = 400;
thread_name = "M8";
thread_diameter = 8;
nut_height = 6.8;
nut_diameter = 13;
wall_thickness = 2.5;
plane_thickness = 2;

// screw seetings
screw_type = "M5";
screw_name = "M5x25";
screw_diameter = 5;
screw_length = 25;
screw_head_height = 5;
screw_nut_height = 4.7;

// bearing_settings
bearing_type_small = 608;
bearing_type_big = 6808;

// spacer_settings
spacer_diameter= 15;
spacer_thickness = 0.6;

// hand settings
hand_shaft_diameter = 6;
hand_shaft_length = 55;
hand_shaft_offset = 10;
hand_square_length = 40;
hand_square_size = 6;
hand_spacer_diameter = 25;

// shoulder settings
shoulder_modulus = 3;
shoulder_teeth = 45;
shoulder_teeth_width = 35;
plate_thickness = 5;
coupler_diameter = 20;
coupler_height = 25;
axle_holes = 6;
bearing_holes = 10;

// gear settings
modulus=2; 
teeth_pinion=20;
teeth_wheel=60;
teeth_width=20;
helix_angle=20;

// minimum distance between parts when disassembled
part_distance = 10;

// print layer height
layer_height = 0.2;

// clearances
pressfit_clearance = 0;
sliding_clearance = 0.1;
object_clearance = 0.5;

// total amounts
total_spacers = 16;
total_nuts = 20; 
total_bearings = 3;

// other settings
e = 0.05;
$fa = $preview ? 20 : 6;
$fs = $preview ? 1 : 0.2;

// constants
od = 0;
id = 1;
h = 2;


/*******************************************************************************
 *                               DERIVED VALUES                                *
 *******************************************************************************/

show_all = $preview;
assembled = $preview ? previewAssembly : false;

stepper_size = get_side_size() + 2 * sliding_clearance;
stepper_holes = get_hole_count();
stepper_offset = screw_length - get_plate_thickness();
stepper_thickness = get_extrusion_thickness();
stepper_diameter = get_extrusion_diameter();

wheel_radius = get_wheel_radius(modulus, teeth_pinion, teeth_wheel);
pinion_radius = get_pinion_radius(modulus, teeth_pinion, teeth_wheel);

shoulder_wheel_radius = get_wheel_radius(shoulder_modulus, shoulder_teeth, shoulder_teeth);

upper_arm_rod_offset = pinion_radius + nut_diameter/2 + wall_thickness + object_clearance;
rod_offset = max(thread_diameter/2 + wall_thickness, nut_diameter/(2 * cos(30)));


pinion_pos = [294, wheel_radius + part_distance + spacer_diameter/2, 0];
wheel_pos = pinion_pos + [wheel_radius + pinion_radius + part_distance, 0, 0];
hand_pos = wheel_pos + [wheel_radius + part_distance + thread_diameter/2 + wall_thickness, 0, 0];

elbow_pinion_connector_pos = pinion_pos - [wheel_radius + spacer_thickness + nut_diameter/2 + wall_thickness 
                    + part_distance, 0, 0];

shoulder_connector_pos = elbow_pinion_connector_pos - [bearing_val(bearing_type_big)[od]/4 
                    + bearing_val(bearing_type_big)[id]/4 + wall_thickness 
                    + bearing_val(bearing_type_small)[od]/2 + part_distance, 0, 0];

bearing_clamp_pos = shoulder_connector_pos - [bearing_val(bearing_type_big)[od]/2 
                    + bearing_val(bearing_type_big)[id]/2 + part_distance, 0, 0];

bearing_holder_pos = bearing_clamp_pos - [3 * bearing_val(bearing_type_big)[od]/4 
                    + bearing_val(bearing_type_big)[id]/4 + 2 * wall_thickness 
                    + screw_diameter + part_distance, 0, 0];

shoulder_wheel_pos = bearing_holder_pos -[shoulder_wheel_radius + bearing_val(bearing_type_big)[od]/2 
                    + 2 * wall_thickness + screw_diameter + part_distance, 0, 0];

coupler_pos = [coupler_diameter/2, bearing_pos(0)[1], 0];


plate_pos = shoulder_wheel_pos - [0, 150, 0];


blade_pos = [0, rod_pos(5)[1] - part_distance - thread_diameter/2 - get_blade_width()/2, 
              get_blade_height()/2];
                        
guard_pos = [get_guard_diameter()/2, blade_pos[1] - part_distance - get_blade_width()/2 -
              get_guard_diameter()/2, get_guard_height()];


special_spacers = [nut_diameter/2 + wall_thickness - bearing_val(bearing_type_small)[h]/2 + object_clearance,
                nut_diameter/2 + wall_thickness - bearing_val(bearing_type_small)[h]/2 + object_clearance];



function spacer_pos(i) = [spacer_diameter/2 + i * (spacer_diameter + part_distance), 0, 0];

function nut_pos(i) = [nut_diameter/(2 * cos(30)) + i * (nut_diameter/cos(30) + part_distance), 
                        spacer_pos(0)[1] - part_distance - spacer_diameter/2 - nut_diameter/2, nut_height];

function bearing_pos(i) = [bearing_val(bearing_type_small)[od]/2 + coupler_diameter + part_distance 
                          + i * (bearing_val(bearing_type_small)[od] + part_distance), nut_pos(0)[1]
                          - part_distance - nut_diameter/2 - bearing_val(bearing_type_small)[od]/2, 0];

function rod_pos(i) = [-thread_diameter/2, bearing_pos(0)[1] - part_distance 
                        - bearing_val(bearing_type_small)[od]/2 - thread_diameter/2 
                        - i * (part_distance + thread_diameter), 0];

function bearing_val(type) = [bearingOuterDiameter(type), bearingInnerDiameter(type), bearingWidth(type)];
