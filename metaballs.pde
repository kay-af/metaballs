// Number of metaballs
int N = 14;

Blob blobs[];
Grid grid;

void setup() {
  size(800, 640);
  
  blobs = new Blob[N];
  for(int i=0; i<N; i++) {
    Blob blob = new Blob();
    blobs[i] = blob;
  }
  
  grid = new Grid();
}

void draw() {
  background(255);
  
  for (int i=0; i<N; i++) {
    Blob blob = blobs[i];
    blob.update();
  }
  
  grid.update();
}
