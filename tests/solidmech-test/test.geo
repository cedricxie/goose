    // Inputs
	squareSide = 1.0; //m
	gridsize = squareSide / 10;
 
        // Geometry
	Point(1) = {-squareSide/2, -squareSide/2, 0, gridsize};
	Point(2) = {squareSide/2, -squareSide/2, 0, gridsize};
	Point(3) = {squareSide/2, squareSide/2, 0, gridsize};
	Point(4) = {-squareSide/2, squareSide/2, 0, gridsize};
	Line(1) = {1, 2};				// bottom line
	Line(2) = {2, 3};				// right line
	Line(3) = {3, 4};				// top line
	Line(4) = {4, 1};				// left line
	Line Loop(5) = {1, 2, 3, 4}; 	
	Plane Surface(6) = {5};

    Transfinite Surface{6};
    Recombine Surface {6};

	Physical Line("bottom") = 1;
	Physical Line("right") = 2;
	Physical Line("left") = 4;
	Physical Line("top") = 3;
	Physical Surface("all") = {6};
	
    /* On my PC, the file must end with a free line to avoid errors
     which might come from different control characters in UNIX, Mac and Windows! 
     Just to be save, insert one line below this comment!*/
     