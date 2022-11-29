// A Grid defines the squares for the marching square algorithm
class Grid {
  float[][] points;
  
  // Polygon buffer
  float[][] polygon = new float[6][2];
  
  // Size of each marching square
  float squareSize = 8;
  
  Grid() {
    // The number of points required to roughly cover the screen width
    int columns = ceil((float)width / squareSize) + 1;
    
    // The number of points required to roughly cover the screen height
    int rows = ceil((float)height / squareSize) + 1;
    
    points = new float[columns][rows];
    polygon = new float[6][2];
  }
  
  // Get the type of the square being inspected
  int computeType(float va, float vb, float vc, float vd) {
    
    int a = (va > 1) ? 1 : 0;
    int b = (vb > 1) ? 2 : 0;
    int c = (vc > 1) ? 4 : 0;
    int d = (vd > 1) ? 8 : 0;
    
    return a | b | c | d;
  }
  
  // Inverse lerp to calculate x,y where f(x,y) = 1
  // Given f(x1,y1) = v1 and f(x2,y2) = v2 and x,y lie between x1,y1 and x2,y2
  float calculateFactor(float v1, float v2) {
    return (1 - v1) / (v2 - v1);
  }
  
  // Lerp function for two points
  float[] interpolate(float x1, float y1, float x2, float y2, float factor) {
    float[] point = new float[2];
    point[0] = lerp(x1, x2, factor);
    point[1] = lerp(y1, y2, factor);
    return point;
  }
  
  // Given two points, draw a contour
  void drawPolygon() {
    
    if (polygon[0] == null) return;
    
    noStroke();
    fill(0,0,255);
    
    beginShape();
    int i = 0;
    while (i<6 && polygon[i] != null) {
      float[] point = polygon[i];
      vertex(point[0], point[1]);
      i++;
    }
    endShape(CLOSE);
  }
  
  
  // Update and draw the metaball simulation using the marching squares algorithm.
  void update() {
    
    // Calculating the contribution of each blob on a point.
    for(int x=0; x<this.points.length; x++) {
      for(int y=0; y<this.points[0].length; y++) {
        float px = x * squareSize;
        float py = y * squareSize;
        
        this.points[x][y] = 0;

        for(int i=0; i<N; i++) {
          Blob blob = blobs[i];
          
          float a = px - blob.position.x;
          float b = py - blob.position.y;
          
          this.points[x][y] += (blob.radius * blob.radius) / ((a * a) + (b * b));
        }
      }
    }
    
    // March over each square formed by the grid.
    for(int x=0; x<this.points.length-1; x++) {
      for(int y=0; y<this.points[0].length-1; y++) {
        
        // Corners of the square.
        int xa = x;
        int ya = (y+1);
        int xb = (x+1);
        int yb = (y+1);
        int xc = (x+1);
        int yc = y;
        int xd = x;
        int yd = y;
        
        // Positions of the corner points in the screen space.
        float pxa = xa * squareSize;
        float pya = ya * squareSize;
        float pxb = xb * squareSize;
        float pyb = yb * squareSize;
        float pxc = xc * squareSize;
        float pyc = yc * squareSize;
        float pxd = xd * squareSize;
        float pyd = yd * squareSize;
        
        float[] pa = new float[] { pxa, pya };
        float[] pb = new float[] { pxb, pyb };
        float[] pc = new float[] { pxc, pyc };
        float[] pd = new float[] { pxd, pyd };
        
        // Values of the points
        float va = this.points[xa][ya];
        float vb = this.points[xb][yb];
        float vc = this.points[xc][yc];
        float vd = this.points[xd][yd];
        
        // Find the type of the square.
        int type = computeType(va, vb, vc, vd);
        
        // Calculate the lerp factor using the inverse lerp function to estimate the position of the points
        // that form the line segment to be drawn.
        float fab = calculateFactor(va, vb);
        float fbc = calculateFactor(vb, vc);
        float fcd = calculateFactor(vc, vd);
        float fda = calculateFactor(vd, va);
        
        float[] bottom = interpolate(pxa, pya, pxb, pyb, fab);
        float[] right = interpolate(pxb, pyb, pxc, pyc, fbc);
        float[] top = interpolate(pxc, pyc, pxd, pyd, fcd);
        float[] left = interpolate(pxd, pyd, pxa, pya, fda);
        
        for(int i=0; i<6; i++) polygon[i] = null;
        
        //for(int i=0; i<points.length; i++) {
        //  println(points[i]);
        //}
        
        // Calculating the line segment points using linear interpolation to smooth out the edges.
        switch(type) {
           case 1:
             polygon[0] = left;
             polygon[1] = bottom;
             polygon[2] = pa;
             break;
           case 14:
             polygon[0] = left;
             polygon[1] = pd;
             polygon[2] = pc;
             polygon[3] = pb;
             polygon[4] = bottom;
             break;
             
           case 2:
             polygon[0] = right;
             polygon[1] = bottom;
             polygon[2] = pb;
             break;
           case 13:
             polygon[0] = right;
             polygon[1] = pc;
             polygon[2] = pd;
             polygon[3] = pa;
             polygon[4] = bottom;
             break;
             
           case 3:
             polygon[0] = left;
             polygon[1] = right;
             polygon[2] = pb;
             polygon[3] = pa;
             break;
           case 12:
             polygon[0] = left;
             polygon[1] = right;
             polygon[2] = pc;
             polygon[3] = pd;
             break;
           
           case 4:
             polygon[0] = top;
             polygon[1] = right;
             polygon[2] = pc;
             break;
           case 11:
             polygon[0] = top;
             polygon[1] = right;
             polygon[2] = pb;
             polygon[3] = pa;
             polygon[4] = pd;
             break;
           
           case 5:
             polygon[0] = top;
             polygon[1] = pc;
             polygon[2] = right;
             polygon[3] = bottom;
             polygon[4] = pa;
             polygon[5] = left;
             break;
           
           case 6:
             polygon[0] = top;
             polygon[1] = pc;
             polygon[2] = pb;
             polygon[3] = bottom;
             break;
           case 9:
             polygon[0] = top;
             polygon[1] = pd;
             polygon[2] = pa;
             polygon[3] = bottom;
             break;
           
           case 7:
             polygon[0] = top;
             polygon[1] = pc;
             polygon[2] = pb;
             polygon[3] = pa;
             polygon[4] = left;
             break;
           case 8:
             polygon[0] = top;
             polygon[1] = pd;
             polygon[2] = left;
             break;
           
           case 10:
             polygon[0] = top;
             polygon[1] = right;
             polygon[2] = pb;
             polygon[3] = bottom;
             polygon[4] = left;
             polygon[5] = pd;
             break;
           
           case 15:
             polygon[0] = pa;
             polygon[1] = pb;
             polygon[2] = pc;
             polygon[3] = pd;
             break;
        }
        
        // Draw the contours if the points are available.
        drawPolygon();
      }
    }
  }
}
