$fn=60;
h = 6;
h_stopper = 8;
r = 15/2;
r_stopper = r + 3;

plate_thickness = 3;
plate_x = 130;
plate_y = 60;


button_space=10;

cable_channel_x = 5;
cable_channel_y= 5;

cable_channel_z_h = h + h_stopper/2;
cable_channel_x_h = r_stopper;

// reserved
// shoulder -> reload
// trigger -> shoot
// bottom_trigger -> ads


buttons = ["w", "a", "s", "d", "f", "e", "1", "]", "q","x","", "", ""];



for (i = [0:4]){
        translate([i * 40,0,0]){
            if (buttons[i] == "]"){
                top(letter=buttons[i],
                letter_rotate=[0,0,-90],
                letter_offset=[0,-1,0]
               );
            }
            else{
                top(letter=buttons[i]);
            }
        }
}

for (i = [5:8]){
        translate([i * 40 - (5*40),-60,0]){
            if (buttons[i] == "]"){
                top(letter=buttons[i],
                letter_rotate=[0,0,-90],
                letter_offset=[0,-1,0]
               );
            }
            else{
                top(letter=buttons[i]);
            }
        }
}

for (i = [9:12]){
        translate([i * 40 - (9*40),-120,0]){
            if (buttons[i] == "]"){
                top(letter=buttons[i],
                letter_rotate=[0,0,-90],
                letter_offset=[0,-1,0]
               );
            }
            else{
                top(letter=buttons[i]);
            }
        }
}

translate([40 * 4,-60,0])
tracing_tool();

//translate([0,0,0])
//plate_l();
//
//translate([0,70,0])
//plate_r();
//
//translate([-10,0,0])
//rotate([0,0,90])
//plate();

module test(){
    translate([60,90.5,0])
    top("w");
    
    //plate test
    difference(){
        translate([0,20,0])
        plate_test();
        
        translate([40/2,20 + 40/2,0])
        cylinder(r=r +0.5, h=h);
    }
    
    translate([0,80,0])
    plate_test();
}

module plate_test(){
    screw_r = 2.75/2;

    difference(){
        cube([40,40,plate_thickness]);
        
        translate([40/2,40/2,0])
        rotate([0,0,45])
        for(i = [0:90:360]){
            echo(i);
            translate([cos(i)* 20, sin(i)*20,0])
            cylinder(r=screw_r, h=h);
        }
    }
}

module plate_l(){
    
    difference(){
        plate();

        translate([40,plate_y/2,0]){
            for (i = [0:90:360]){
                translate([cos(i) * (r_stopper + button_space/2) ,sin(i) * (r_stopper + button_space/2), 0])
                cylinder(r=r + 0.5 , h=h);
            }
        }
    }
}

module plate_r(){
    bottom_offset = 25;
    top_offset = (bottom_offset *2) -3;
    horizontal_spacing = 4;
    
    difference(){
        plate();
        
        translate([-r,bottom_offset,0])
        for (i = [1:6]){
            translate([(r_stopper * 2 + horizontal_spacing) * i, 0, 0])
            cylinder(r=r + 0.5 , h=h);
        }
        
        translate([0,top_offset,0])
        for (i = [1:4]){
            translate([(r_stopper * 2 + horizontal_spacing) * i, 0, 0])
            cylinder(r=r + 0.5 , h=h);
        }
    }
}

module plate(){
    screw_r = 2.75/2;
    corner_padding = 10;

    difference(){
        cube([plate_x, plate_y, plate_thickness]);
        
        color("gold"){
            translate([corner_padding, corner_padding])
            cylinder(r=screw_r, h=plate_thickness);
        
            translate([plate_x - corner_padding,
                       corner_padding
                     ])
            cylinder(r=screw_r, h=plate_thickness);
            
            translate([corner_padding,
                       plate_y - corner_padding])
            cylinder(r=screw_r, h=plate_thickness);
        
            translate([plate_x - corner_padding,
                       plate_y - corner_padding
                     ])
            cylinder(r=screw_r, h=plate_thickness);
        }
    }
}

module top(letter,
           letter_rotate=[0,0,0],
           letter_offset=[0,0,0]){
               
        h_stopper = 3;

        color("pink")
        translate(letter_offset)
        translate([0,0,h_stopper + h])
        rotate(letter_rotate)
        linear_extrude(0.5)
        text(letter,
             halign="center",
             valign="center",
             font="LEMON MILK:style=Bold",
             size=7);
        
        color("green")
        translate([0,0,h_stopper])
        cylinder(r=r, h=h);
        
        difference(){
            color("red")
            translate([0,0,0])
            cylinder(r=r_stopper, h=h_stopper);
            
            translate([0,0,h_stopper/2 + cable_channel_x/2])
            rotate([0,180,0])
            cable_channel();
        }
    translate([0,-30, 0])
    bottom();
}

module bottom(){
    difference(){
        union(){
            color("green")
            translate([0,0,h_stopper])
            cylinder(r=r, h=h);
            
            color("red")
            translate([0,0,0])
            cylinder(r=r_stopper, h=h_stopper);
        }
        translate([0,0,h_stopper/2 - cable_channel_x/2])
        cable_channel();
    }
}

module tracing_tool(){
    
    difference(){
        color("gold")
        translate([0,0,0])
        cylinder(r=r_stopper, h=h_stopper);
        
        cylinder(r=r, h=h_stopper);
    }
}

module cable_channel(){
        translate([0,
                   0,
                   cable_channel_z_h/2 + cable_channel_x])
        cube([cable_channel_x,
              cable_channel_y,
              cable_channel_z_h,
            ], true
            );
        
        translate([0,
                   -cable_channel_x_h/2,
                   cable_channel_x/2])
        rotate([90,0,0])
        cube([cable_channel_x,
              cable_channel_y,
              cable_channel_x_h + cable_channel_x,
            ], true
            );
}