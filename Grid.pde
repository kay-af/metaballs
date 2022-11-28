// A Grid defines the squares for the marching square algorithm
class Grid {
  float[][] points;
   
  // Size of each marching square
  float squareSize = 8;
  
  Grid() {
    // The number of points required to roughly cover the screen width
    int columns = ceil((float)width / squareSize) + 1;
    
    // The number of points required to roughly cover the screen height
    int rows = ceil((float)height / squareSize) + 1;
    
    points = new float[columns][rows];
  }
  
  // Get the type of the square being inspected
  int computeType(float va, float vb, float vc, float vd) {
    
    int a = va >= 1 ? 1 : 0;
    int b = vb >= 1 ? 2 : 0;
    int c = vc >= 1 ? 4 : 0;
    int d = vd >= 1 ? 8 : 0;
    
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
  void drawContour(float[] p1, float[] p2) {
    float x1 = p1[0];
    float y1 = p1[1];
    float x2 = p2[0];
    float y2 = p2[1];
    
    line(x1, y1, x2, y2);
  }
  
  
  // Update and draw the metaball simulation using the marching squares algorithm.
  void draw() {
    
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
        float fad = calculateFactor(va, vd);
        float fcb = calculateFactor(vc, vb);
        float fcd = calculateFactor(vc, vd);
        
        float[] p1 = null, p2 = null, p3 = null, p4 = null;
        
        // Calculating the line segment points using linear interpolation to smooth out the edges.
        switch(type) {
           case 1:
           case 14:
             p1 = interpolate(pxa, pya, pxb, pyb, fab);
             p2 = interpolate(pxa, pya, pxd, pyd, fad);
             break;
           case 2:
           case 13:
             p1 = interpolate(pxc, pyc, pxb, pyb, fcb);
             p2 = interpolate(pxa, pya, pxb, pyb, fab);
             break;
           case 3:
           case 12:
             p1 = interpolate(pxa, pya, pxd, pyd, fad);
             p2 = interpolate(pxc, pyc, pxb, pyb, fcb);
             break;
           case 4:
           case 11:
             p1 = interpolate(pxc, pyc, pxd, pyd, fcd);
             p2 = interpolate(pxc, pyc, pxb, pyb, fcb);
             break;
           case 5:
             p1 = interpolate(pxc, pyc, pxd, pyd, fcd);
             p2 = interpolate(pxa, pya, pxd, pyd, fad);
             p3 = interpolate(pxc, pyc, pxb, pyb, fcb);
             p4 = interpolate(pxa, pya, pxb, pyb, fab);
             break;
           case 6:
           case 9:
             p1 = interpolate(pxc, pyc, pxd, pyd, fcd);
             p2 = interpolate(pxa, pya, pxb, pyb, fab);
             break;
           case 7:
           case 8:
             p1 = interpolate(pxc, pyc, pxd, pyd, fcd);
             p2 = interpolate(pxa, pya, pxd, pyd, fad);
             break;
           case 10:
             p1 = interpolate(pxc, pyc, pxd, pyd, fcd);
             p2 = interpolate(pxc, pyc, pxb, pyb, fcb);
             p3 = interpolate(pxa, pya, pxd, pyd, fad);
             p4 = interpolate(pxa, pya, pxb, pyb, fab);
             break;
        }
        
        // Set the color of the line segments based on position before drawing the contours.
        stroke(255, 255 * xa / points.length, 255 * ya / points[0].length);
        
        // Draw the contours if the points are available.
        if (p1 != null) {
          drawContour(p1, p2);
        }
        
        if (p3 != null) {
          drawContour(p3, p4);
        }
      }
    }
    
  }
}
