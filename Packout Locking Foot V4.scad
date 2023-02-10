/************** BEST VIEWED IN A CODE EDITOR 80 COLUMNS WIDE *******************
*
* Milwaukee Locking Packout Foot
* Benjamen Johnson <workshop.electronsmith.com>
* 20200212
* Version 4
* openSCAD Version: 2019.05 
* Licesnse: Creative Commons - Attribution - Share Alike
*           https://creativecommons.org/licenses/by-sa/4.0/
*
**** For the gears I use the folloing module ****
*
* Public Domain Parametric Involute Spur Gear (and involute helical gear and involute rack)
* version 1.1
* by Leemon Baird, 2011, Leemon@Leemon.com
* http://www.thingiverse.com/thing:5505
*
* Scroll down to the module to see the complete license and instructions
*******************************************************************************/

/*[Hidden]*/
bottom_widths=[72,174];

/*[Edit Me!]*/
// What part do you want to see?
part = 5;//[0:Foot, 1:Lock, 2:Gear, 3:Gear Meshing, 4:Complete Model, 5:Print Model]

// Which type of foot (standard or big)?
foot_type = 0;//[0:Normal Foot,1:Big Foot]

// Adjust how tightly the gear shaft fits into the foot
shaft_tolerance = 0.97;//[0.90:0.005:1.10]

// Adjust how tightly the dovetail fits
dovetail_tolerance = 0.97;//[0.90:0.005:1.10]

/*[gear parameters]*/
/*******************************************************************************
* Gear Stuff
*******************************************************************************/
// How tall is the connector on top of the shaft
connector_height = 2.0;//[1:0.1:8]

// Add a little bit to the shaft length to account for supports
shaft_length_fudge = 0.5;

// Number of teeth on the gear
gear_teeth = 16;

// Number of teeth on the rack
rack_teeth = 9;

// Tooth size
mm_per_tooth = 5;

// Rack height
rack_height = 6;    

// Diameter of the hole for the gear shaft
gear_hole_dia=22;

// Locates the positioning dot for proper locking foot assembly
dot_pos = -130;

// Point to Point size of the nut inside the gear shaft
nut_size = 10; 

// How far up the shaft the nut stops
nut_height = 7;

// Diameter of the hole for the bolt
bolt_dia = 5;

// Diameter of the detent on the gear shaft
detent_dia = 3;

/*[Spring Parameters]*/
// Size of the gap between the spring and body of the foot
spring_gap = 2;

// How thick the spring should be
spring_thickness = 3;

// How long the spring should be in degrees of arc
spring_len = 60; //[40:90]
 
/*[Fine Tuning]*/
/*******************************************************************************
*
*        ----------------------    ----
* hy - /                        \    |
*     |                          |   |
*     |                          |   |
*     |                          |   bottom_y 
*     |                          |   |
*     |                          |   |
*      \                        /    |
*       -----------------------    ----
*     | <------ bottom_x  ------>|
*
*
*******************************************************************************/
// Bottom X dimension
bottom_x=bottom_widths[foot_type];

// Bottom Y dimension
bottom_y=42;

// Length of the hypotenuse (cut off corners)
hy = 8;

// Draft angle of the sides 
draft_angle  = 30;

// Height of the foot to the top of the box
foot_depth = 11;//11.2

// Height of the tabs
tab_depth = 7.5;

// Distance from y-axis for notch cutout
notch_pos=31;

// Diameter of notch cutout
notch_dia = 3.5;

// Length of notch
notch_len = 10;

// How far to cut into the X direction of the foot for the tab
tab_cutout_x = 11.2;

// How far off the X-axis to make the cut for the tab
tab_cutout_y = 1;

// How much to chamfer the top corners (more = less)
top_chamfer=5.5;

// How much to chamfer the edges of the tab cutouts
chamfer = 2;

// How long to make the chamfer on the side of the tab
side_chamfer_len = 34;

// Widest part of the dovetail
dovetail_width_max = 45;

// Narrowest part of the dovetail
dovetail_width_min = 38;

// Height of the dovetail
dovetail_depth = 5;

// How much longer than the foot should the lock be
lock_extension = 30;    

/*[Hidden]*/
// add a tiny amount to cuts to make the model render correctly
render_offset = 0.01;

/*******************************************************************************
* Calculations
*******************************************************************************/
// what indent do we need to get the right hypotenuse length
indent=sqrt(hy*hy/2);

//figure out what scale factors we need to get the proper draft angle
scalex=(bottom_x+2*foot_depth*tan(draft_angle))/bottom_x;
scaley=(bottom_y+2*foot_depth*tan(draft_angle))/bottom_y;

// define the points for the base angle polygon
base = [[indent,0],[bottom_x-indent,0],[bottom_x,indent],
        [bottom_x,bottom_y-indent],[bottom_x-indent,bottom_y],
        [indent,bottom_y],[0,bottom_y-indent],[0,indent]];
        
// define the points of a trapezoid (dovetail)
trapezoid =[[-dovetail_width_max/2,-dovetail_depth/2],
        [dovetail_width_max/2,-dovetail_depth/2],
        [dovetail_width_min/2,dovetail_depth/2],
        [-dovetail_width_min/2,dovetail_depth/2]];        

// figure out the external dimensions for the plane of the tab
tab_x=(bottom_x+2*tab_depth*tan(draft_angle));
tab_y=(bottom_y+2*tab_depth*tan(draft_angle));

// Calculate the gear thickness
gear_thickness = dovetail_depth/2;
  
// Calculate the shaft length  
shaft_length=foot_depth-dovetail_depth+shaft_length_fudge+gear_thickness+connector_height;  

// Calculate the size of the spring cut
spring_cut = foot_depth-dovetail_depth;

// Calculate the position of the spring
spring_offset = dovetail_depth/2+foot_depth/2;

/*******************************************************************************
* Main "program" to make the parts 
*******************************************************************************/
print_part();

/*******************************************************************************
* This module is used by Makerbot Customizer to create different .stl 
* files for each part.
*******************************************************************************/
module print_part(){
    if(part ==0) // make foot
        make_foot();
    else if (part == 1) // make lock
        make_lock();
    else if (part == 2) // make gear
        make_gear();
    else if(part == 3){ //gear meshing
        translate([0,-30,0])make_lock();
        translate([0,0,dovetail_depth/2])make_gear();
    } // end else if
    else if (part == 4){ //make all
        make_foot();
        translate([0,-30,0])make_lock();
        translate([0,0,dovetail_depth/2])make_gear();
    } // end else if
    else{
        make_foot();
        translate([13,-52,-0.5])rotate([0,0,90])make_lock();
        translate([0,44,0])make_gear();
    } // end else
} // end module print_part

/*******************************************************************************
* Module that makes the foot
*******************************************************************************/
module make_foot(){
    union(){    
        difference(){
            // make the general shape
            translate([0,0,foot_depth/2])
            linear_extrude(height=foot_depth, center = true, convexity = 10, scale=[scalex,scaley])
                translate([-bottom_x/2,-bottom_y/2])polygon(points = base);    
        
            // Cut out recess for tabs
            translate([-tab_x/2,15+tab_cutout_y,3*tab_depth/2])
            cube([tab_cutout_x*2,30,tab_depth],center=true);
            
            translate([tab_x/2,15+tab_cutout_y,3*tab_depth/2])
            cube([tab_cutout_x*2,30,tab_depth],center=true);        
            
            translate([-(tab_x/2-tab_cutout_x),tab_cutout_y,tab_depth])
            rotate([0,0,135])
            cube([30,30,foot_depth-tab_depth+render_offset]);
            
            translate([(tab_x/2-tab_cutout_x),tab_cutout_y,tab_depth])
            rotate([0,0,-45])
            cube([30,30,foot_depth-tab_depth+render_offset]);
          
            // Chamfer edges for better fit below tab
            translate([-tab_x/2,(tab_y-side_chamfer_len)/2,tab_depth])
            rotate([0,45,0])
            cube([chamfer,side_chamfer_len,chamfer],center=true);
            
            translate([tab_x/2,(tab_y-side_chamfer_len)/2,tab_depth])
            rotate([0,45,0])
            cube([chamfer,side_chamfer_len,chamfer],center=true);
          
            translate([(-tab_x)/2+indent,(tab_y)/2,tab_depth])
            rotate([0,45,-45])
            cube([chamfer*1.5,20,chamfer*1.5],center=true);
        
            translate([(tab_x)/2-indent,(tab_y)/2,tab_depth])
            rotate([0,45,45])
            cube([chamfer*1.5,20,chamfer*1.5],center=true);
         
            // Notch for part sticking below tab
            translate([-(tab_x/2-tab_cutout_x+notch_dia/2),(tab_y-notch_len)/2,tab_depth])
            rotate([90,0,0])
            cylinder(h=notch_len,d=notch_dia,center=true,$fn=25);
            
            translate([(tab_x/2-tab_cutout_x+notch_dia/2),(tab_y-notch_len)/2,tab_depth])
            rotate([90,0,0])
            cylinder(h=notch_len,d=notch_dia,center=true,$fn=25);
            
            // Notch out front for goober
            translate([-(tab_x/2-tab_cutout_x+notch_dia/2),(tab_y)/2,tab_depth])
            sphere(r=3,$fn=25);
            
            translate([(tab_x/2-tab_cutout_x+notch_dia/2),(tab_y)/2,tab_depth])
            sphere(r=3,$fn=25);
              
            translate([-(tab_x/2-tab_cutout_x+notch_dia/2)-top_chamfer,(tab_y)/2+top_chamfer,tab_depth+5])
            rotate([0,0,45])cube([20,20,10],center=true);
            
            translate([(tab_x/2-tab_cutout_x+notch_dia/2)+top_chamfer,(tab_y)/2+top_chamfer,tab_depth+5])
            rotate([0,0,45])cube([20,20,10],center=true);
                  
            // cut out dovetail lock
            translate([0,0,dovetail_depth/2-render_offset/2])rotate([90,180,0])
            linear_extrude(height = tab_y,center=true)
            polygon(trapezoid);
                
            translate([0,-24,dovetail_depth+4-render_offset])cube([dovetail_width_max, 8,8],center=true);
                    
            // cut hole for gear
            translate([0,0,foot_depth/2])cylinder(d=gear_hole_dia,h=foot_depth+render_offset,center=true,$fn=100);
                        
            //cut out spring
            translate([0,0,dovetail_depth-render_offset])
            rotate([0,0,100-spring_len])
            rotate_extrude(angle = spring_len,convexity = 10,$fn=100)
                translate([gear_hole_dia/2+spring_thickness, 0, 0])
                    square([spring_gap,spring_cut+render_offset*2]);
                    
            rotate([0,0,13])translate([0,gear_hole_dia/2,spring_offset])cube([spring_gap,2*(spring_gap+spring_thickness),spring_cut+render_offset*2],center=true);
            
            // positioning dot
            rotate([0,0,dot_pos])translate([0,gear_hole_dia/2,foot_depth])cylinder(d=detent_dia,h=2,center=true,$fn=50);
        } // end difference
        
        // make the catch for detent on the gear shaft
        translate([0,gear_hole_dia/2,spring_offset])cylinder(d=detent_dia,h=spring_cut,center=true,$fn=50);
    }// end union
} // end module

/*******************************************************************************
* Module to make the lock part
*******************************************************************************/
module make_lock(){
    difference(){
        union(){
            difference(){
                union(){
                // Make sliding lock
                scale([dovetail_tolerance,1,1])
                translate([0,tab_y/2+lock_extension,dovetail_depth/2])rotate([90,180,0])
                linear_extrude(height = tab_y+lock_extension)
                    polygon(points=trapezoid);
                    
                // make tall part
                scale([dovetail_tolerance,1,1])
                translate([0,-24,dovetail_depth+3])
                cube([dovetail_width_max, 8,6],center=true);
                } //end union
                
                // Cut groove for gearing 
                translate([0,30,dovetail_depth*3/4])
                cube([30,100,dovetail_depth/2+render_offset],center=true); 
            } //difference
            
            // make rack gear
            translate([13.6,-12.5,dovetail_depth*3/4])
            rotate([0,0,90])
            rack(mm_per_tooth,rack_teeth+6,gear_thickness,rack_height);
            

        }//end union
        
        // cut off ends at the same angle as the foot
        translate([0,bottom_y/2+lock_extension,0])
        rotate([-draft_angle,0,0])
        translate([-dovetail_width_max/2,0,0])
        cube([dovetail_width_max,10,10]);
        
        translate([1,-bottom_y/2,0])
        rotate([-draft_angle,0,180])
        translate([-dovetail_width_max/2,0,0])
        cube([dovetail_width_max+10,10,20]);
   
        // trim little bit off bottom
        cube([100,200,1],center=true);
    } // end difference
} // end module make_lock()

/*******************************************************************************
* Module to make the gear
*******************************************************************************/
module make_gear(){
    difference(){
        union(){    
            cylinder(d=gear_hole_dia*shaft_tolerance,h=shaft_length,$fn=100);
            
            translate([0,0,gear_thickness/2])
            gear(mm_per_tooth,gear_teeth,gear_thickness,0);
        } //end union
        
    // cut notches on top of gear shaft    
    translate([0,10,shaft_length-connector_height/2])cube([gear_hole_dia,10,connector_height+render_offset],center=true);
    translate([0,-10,shaft_length-connector_height/2])cube([gear_hole_dia ,10,connector_height+render_offset],center=true);
        
    // cut hole for through bolt
    cylinder(d=bolt_dia,h=100,$fn=100,center=true);
    
    // inset nut
    translate([0,0,nut_height/2])
    cylinder(d=nut_size,h=nut_height+render_offset,center=true,$fn=6);
        
    // detents
    translate([0,gear_hole_dia/2,shaft_length/2+gear_thickness])cylinder(d=detent_dia,h=shaft_length,center=true,$fn=50);
    }//end difference
} // end module

//////////////////////////////////////////////////////////////////////////////////////////////
// Public Domain Parametric Involute Spur Gear (and involute helical gear and involute rack)
// version 1.1
// by Leemon Baird, 2011, Leemon@Leemon.com
//http://www.thingiverse.com/thing:5505
//
// This file is public domain.  Use it for any purpose, including commercial
// applications.  Attribution would be nice, but is not required.  There is
// no warranty of any kind, including its correctness, usefulness, or safety.
// 
// This is parameterized involute spur (or helical) gear.  It is much simpler and less powerful than
// others on Thingiverse.  But it is public domain.  I implemented it from scratch from the 
// descriptions and equations on Wikipedia and the web, using Mathematica for calculations and testing,
// and I now release it into the public domain.
//
//		http://en.wikipedia.org/wiki/Involute_gear
//		http://en.wikipedia.org/wiki/Gear
//		http://en.wikipedia.org/wiki/List_of_gear_nomenclature
//		http://gtrebaol.free.fr/doc/catia/spur_gear.html
//		http://www.cs.cmu.edu/~rapidproto/mechanisms/chpt7.html
//
// The module gear() gives an involute spur gear, with reasonable defaults for all the parameters.
// Normally, you should just choose the first 4 parameters, and let the rest be default values.
// The module gear() gives a gear in the XY plane, centered on the origin, with one tooth centered on
// the positive Y axis.  The various functions below it take the same parameters, and return various
// measurements for the gear.  The most important is pitch_radius, which tells how far apart to space
// gears that are meshing, and adendum_radius, which gives the size of the region filled by the gear.
// A gear has a "pitch circle", which is an invisible circle that cuts through the middle of each
// tooth (though not the exact center). In order for two gears to mesh, their pitch circles should 
// just touch.  So the distance between their centers should be pitch_radius() for one, plus pitch_radius() 
// for the other, which gives the radii of their pitch circles.
//
// In order for two gears to mesh, they must have the same mm_per_tooth and pressure_angle parameters.  
// mm_per_tooth gives the number of millimeters of arc around the pitch circle covered by one tooth and one
// space between teeth.  The pitch angle controls how flat or bulged the sides of the teeth are.  Common
// values include 14.5 degrees and 20 degrees, and occasionally 25.  Though I've seen 28 recommended for
// plastic gears. Larger numbers bulge out more, giving stronger teeth, so 28 degrees is the default here.
//
// The ratio of number_of_teeth for two meshing gears gives how many times one will make a full 
// revolution when the the other makes one full revolution.  If the two numbers are coprime (i.e. 
// are not both divisible by the same number greater than 1), then every tooth on one gear
// will meet every tooth on the other, for more even wear.  So coprime numbers of teeth are good.
//
// The module rack() gives a rack, which is a bar with teeth.  A rack can mesh with any
// gear that has the same mm_per_tooth and pressure_angle.
//
// Some terminology: 
// The outline of a gear is a smooth circle (the "pitch circle") which has mountains and valleys
// added so it is toothed.  So there is an inner circle (the "root circle") that touches the 
// base of all the teeth, an outer circle that touches the tips of all the teeth,
// and the invisible pitch circle in between them.  There is also a "base circle", which can be smaller than
// all three of the others, which controls the shape of the teeth.  The side of each tooth lies on the path 
// that the end of a string would follow if it were wrapped tightly around the base circle, then slowly unwound.  
// That shape is an "involute", which gives this type of gear its name.
//
//////////////////////////////////////////////////////////////////////////////////////////////

//An involute spur gear, with reasonable defaults for all the parameters.
//Normally, you should just choose the first 4 parameters, and let the rest be default values.
//Meshing gears must match in mm_per_tooth, pressure_angle, and twist,
//and be separated by the sum of their pitch radii, which can be found with pitch_radius().
module gear (
	mm_per_tooth    = 3,    //this is the "circular pitch", the circumference of the pitch circle divided by the number of teeth
	number_of_teeth = 11,   //total number of teeth around the entire perimeter
	thickness       = 6,    //thickness of gear in mm
	hole_diameter   = 3,    //diameter of the hole in the center, in mm
	twist           = 0,    //teeth rotate this many degrees from bottom of gear to top.  360 makes the gear a screw with each thread going around once
	teeth_to_hide   = 0,    //number of teeth to delete to make this only a fraction of a circle
	pressure_angle  = 28,   //Controls how straight or bulged the tooth sides are. In degrees.
	clearance       = 0.0,  //gap between top of a tooth on one gear and bottom of valley on a meshing gear (in millimeters)
	backlash        = 0.0   //gap between two meshing teeth, in the direction along the circumference of the pitch circle
) {
	pi = 3.1415926;
	p  = mm_per_tooth * number_of_teeth / pi / 2;  //radius of pitch circle
	c  = p + mm_per_tooth / pi - clearance;        //radius of outer circle
	b  = p*cos(pressure_angle);                    //radius of base circle
	r  = p-(c-p)-clearance;                        //radius of root circle
	t  = mm_per_tooth/2-backlash/2;                //tooth thickness at pitch circle
	k  = -iang(b, p) - t/2/p/pi*180; {             //angle to where involute meets base circle on each side of tooth
		difference() {
			for (i = [0:number_of_teeth-teeth_to_hide-1] )
				rotate([0,0,i*360/number_of_teeth])
					linear_extrude(height = thickness, center = true, convexity = 10, twist = twist)
						polygon(
							points=[
								[0, -hole_diameter/10],
								polar(r, -181/number_of_teeth),
								polar(r, r<b ? k : -180/number_of_teeth),
								q7(0/5,r,b,c,k, 1),q7(1/5,r,b,c,k, 1),q7(2/5,r,b,c,k, 1),q7(3/5,r,b,c,k, 1),q7(4/5,r,b,c,k, 1),q7(5/5,r,b,c,k, 1),
								q7(5/5,r,b,c,k,-1),q7(4/5,r,b,c,k,-1),q7(3/5,r,b,c,k,-1),q7(2/5,r,b,c,k,-1),q7(1/5,r,b,c,k,-1),q7(0/5,r,b,c,k,-1),
								polar(r, r<b ? -k : 180/number_of_teeth),
								polar(r, 181/number_of_teeth)
							],
 							paths=[[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16]]
						);
			cylinder(h=2*thickness+1, r=hole_diameter/2, center=true, $fn=20);
		}
	}
};	
//these 4 functions are used by gear
function polar(r,theta)   = r*[sin(theta), cos(theta)];                            //convert polar to cartesian coordinates
function iang(r1,r2)      = sqrt((r2/r1)*(r2/r1) - 1)/3.1415926*180 - acos(r1/r2); //unwind a string this many degrees to go from radius r1 to radius r2
function q7(f,r,b,r2,t,s) = q6(b,s,t,(1-f)*max(b,r)+f*r2);                         //radius a fraction f up the curved side of the tooth 
function q6(b,s,t,d)      = polar(d,s*(iang(b,d)+t));                              //point at radius d on the involute curve

//a rack, which is a straight line with teeth (the same as a segment from a giant gear with a huge number of teeth).
//The "pitch circle" is a line along the X axis.
module rack (
	mm_per_tooth    = 3,    //this is the "circular pitch", the circumference of the pitch circle divided by the number of teeth
	number_of_teeth = 11,   //total number of teeth along the rack
	thickness       = 6,    //thickness of rack in mm (affects each tooth)
	height          = 120,   //height of rack in mm, from tooth top to far side of rack.
	pressure_angle  = 28,   //Controls how straight or bulged the tooth sides are. In degrees.
	backlash        = 0.0   //gap between two meshing teeth, in the direction along the circumference of the pitch circle
) {
	pi = 3.1415926;
	a = mm_per_tooth / pi; //addendum
	t = a*cos(pressure_angle)-1;         //tooth side is tilted so top/bottom corners move this amount
		for (i = [0:number_of_teeth-1] )
			translate([i*mm_per_tooth,0,0])
				linear_extrude(height = thickness, center = true, convexity = 10)
					polygon(
						points=[
							[-mm_per_tooth * 3/4,                 a-height],
							[-mm_per_tooth * 3/4 - backlash,     -a],
							[-mm_per_tooth * 1/4 + backlash - t, -a],
							[-mm_per_tooth * 1/4 + backlash + t,  a],
							[ mm_per_tooth * 1/4 - backlash - t,  a],
							[ mm_per_tooth * 1/4 - backlash + t, -a],
							[ mm_per_tooth * 3/4 + backlash,     -a],
							[ mm_per_tooth * 3/4,                 a-height],
						],
						paths=[[0,1,2,3,4,5,6,7]]
					);
};	

//These 5 functions let the user find the derived dimensions of the gear.
//A gear fits within a circle of radius outer_radius, and two gears should have
//their centers separated by the sum of their pictch_radius.
function circular_pitch  (mm_per_tooth=3) = mm_per_tooth;                     //tooth density expressed as "circular pitch" in millimeters
function diametral_pitch (mm_per_tooth=3) = 3.1415926 / mm_per_tooth;         //tooth density expressed as "diametral pitch" in teeth per millimeter
function module_value    (mm_per_tooth=3) = mm_per_tooth / pi;                //tooth density expressed as "module" or "modulus" in millimeters
function pitch_radius    (mm_per_tooth=3,number_of_teeth=11) = mm_per_tooth * number_of_teeth / 3.1415926 / 2;
function outer_radius    (mm_per_tooth=3,number_of_teeth=11,clearance=0.1)    //The gear fits entirely within a cylinder of this radius.
	= mm_per_tooth*(1+number_of_teeth/2)/3.1415926  - clearance;              

