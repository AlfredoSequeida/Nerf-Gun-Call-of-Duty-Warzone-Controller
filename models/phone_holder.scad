// phone holder

padding = 1;

x = 70 + padding;
y = 138 + padding;

phone_h = 13 + padding;

base_h = 3;

top_holder_y = 20;

difference(){
    color("gold")
    cube([x,y,base_h]);

    translate([x/4,0,0])
    cube([x/2,y,base_h]);
    
    translate([0,y/4,0])
    cube([x,y/2,base_h]);
}

color("red")
translate([-base_h,0,0])
cube([base_h,y,phone_h]);

color("red")
translate([x,0,0])
cube([base_h,y,phone_h]);


difference(){
    union(){
translate([-base_h,
           0,
           phone_h])
cube([x + base_h *2,
      top_holder_y,
      base_h]);

translate([-base_h,
           y - top_holder_y,
           phone_h])
cube([x + base_h *2,
      top_holder_y,
      base_h]);
    }
        translate([x/4,0,0])
    cube([x/2,y,20]);
    }