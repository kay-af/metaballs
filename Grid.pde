class Grid {
  float[][] points;
  int squareSize = 2;
  
  Grid() {
    int columns = ceil((float)width / squareSize) + 1;
    int rows = ceil((float)height / squareSize) + 1;
    points = new float[columns][rows];
  }
  
  int computeType(float va, float vb, float vc, float vd) {
    int a = va >= 1.0f ? 1 : 0;
    int b = vb >= 1.0f ? 2 : 0;
    int c = vc >= 1.0f ? 4 : 0;
    int d = vd >= 1.0f ? 8 : 0;
    
    return a | b | c | d;
  }
  
  float calculateFactor(float v1, float v2) {
    return (1 - v1) / (v2 - v1);
  }
  
  float[] interpolate(float x1, float y1, float x2, float y2, float factor) {
    float[] point = new float[2];
    point[0] = lerp(x1, x2, factor);
    point[1] = lerp(y1, y2, factor);
    return point;
  }
  
  void drawContour(float[] p1, float[] p2) {
    float x1 = p1[0];
    float y1 = p1[1];
    float x2 = p2[0];
    float y2 = p2[1];
    
    line(x1, y1, x2, y2);
  }
  
  void draw() {
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
    
    for(int x=0; x<this.points.length-1; x++) {
      for(int y=0; y<this.points[0].length-1; y++) {
        int xa = x;
        int ya = (y+1);
        int xb = (x+1);
        int yb = (y+1);
        int xc = (x+1);
        int yc = y;
        int xd = x;
        int yd = y;
        
        float pxa = xa * squareSize;
        float pya = ya * squareSize;
        float pxb = xb * squareSize;
        float pyb = yb * squareSize;
        float pxc = xc * squareSize;
        float pyc = yc * squareSize;
        float pxd = xd * squareSize;
        float pyd = yd * squareSize;
        
        float va = this.points[xa][ya];
        float vb = this.points[xb][yb];
        float vc = this.points[xc][yc];
        float vd = this.points[xd][yd];
        
        int type = computeType(va, vb, vc, vd);
        
        float fab = calculateFactor(va, vb);
        float fad = calculateFactor(va, vd);
        float fba = 1 - fab;
        float fbc = calculateFactor(vb, vc);
        float fcb = 1 - fbc;
        float fcd = calculateFactor(vc, vd);
        
        float[] p1 = null, p2 = null, p3 = null, p4 = null;
        
        switch(type) {
           case 1:
           case 14:
             p1 = interpolate(pxa, pya, pxb, pyb, fab);
             p2 = interpolate(pxa, pya, pxd, pyd, fad);
             break;
           case 2:
           case 13:
             p1 = interpolate(pxb, pyb, pxc, pyc, fbc);
             p2 = interpolate(pxb, pyb, pxa, pya, fba);
             break;
           case 3:
           case 12:
             p1 = interpolate(pxa, pya, pxd, pyd, fad);
             p2 = interpolate(pxb, pyb, pxc, pyc, fbc);
             break;
           case 4:
           case 11:
             p1 = interpolate(pxc, pyc, pxd, pyd, fcd);
             p2 = interpolate(pxc, pyc, pxb, pyb, fcb);
             break;
           case 5:
             p1 = interpolate(pxc, pyc, pxd, pyd, fcd);
             p2 = interpolate(pxa, pya, pxd, pyd, fad);
             p3 = interpolate(pxb, pyb, pxc, pyc, fbc);
             p4 = interpolate(pxb, pyb, pxa, pya, fba);
             break;
           case 6:
           case 9:
             p1 = interpolate(pxc, pyc, pxd, pyd, fcd);
             p2 = interpolate(pxb, pyb, pxa, pya, fba);
             break;
           case 7:
           case 8:
             p1 = interpolate(pxc, pyc, pxd, pyd, fcd);
             p2 = interpolate(pxa, pya, pxd, pyd, fad);
             break;
           case 10:
             p1 = interpolate(pxc, pyc, pxd, pyd, fcd);
             p2 = interpolate(pxb, pyb, pxc, pyc, fbc);
             p3 = interpolate(pxa, pya, pxd, pyd, fad);
             p4 = interpolate(pxa, pya, pxb, pyb, fab);
             break;
           default:
            break;
        }
        
        stroke(255, 255 * xa / points.length, 255 * ya / points[0].length);
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
