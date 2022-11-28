class Blob {
  PVector position;
  PVector velocity;
  float radius;
  
  Blob() {
    this.radius = random(25, 100);
    
    float x = random(this.radius, width - this.radius);
    float y = random(this.radius, height - this.radius);
    this.position = new PVector(x, y);
    
    float angle = random(0, 2 * PI);
    float velX = cos(angle);
    float velY = sin(angle);
    float speed = random(0.5, 2.5);
    this.velocity = new PVector(velX, velY);
    this.velocity.mult(speed);
  }
  
  void draw() {
    
    if (this.position.x - this.radius <= 0) {
      this.velocity.x = abs(this.velocity.x);
    }
    
    if (this.position.x + this.radius >= width) {
      this.velocity.x = -abs(this.velocity.x);
    }
    
    if (this.position.y - this.radius <= 0) {
      this.velocity.y = abs(this.velocity.y);
    }
    
    if (this.position.y + this.radius >= height) {
      this.velocity.y = -abs(this.velocity.y);
    }
    
    this.position.add(this.velocity);
  }
}
