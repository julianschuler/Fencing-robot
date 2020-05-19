include <settings.scad>
use <hand.scad>
use <elbow.scad>
use <shoulder.scad>
use <utility.scad>



module export_part(part_name) {
  if (part_name == "hand_connector") {
    hand_connector();
  }
  else if (part_name == "elbow_wheel") {
    elbow_wheel();
  }
  else {
    echo(str("Error: Couldn't find ", part_name));
  }
}


if (!is_undef(part)) {
  export_part(part);
}
