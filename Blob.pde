// A blob defines a metaball
class Blob {
  PVector position;
  PVector velocity;
  float radius;
  
  Blob() {
    
    // Random radius
    this.radius = random(30, 50);
    
    // Place at a random valid position
    float x = random(this.radius, width - this.radius);
    float y = random(this.radius, height - this.radius);
    this.position = new PVector(x, y);
    
    // Generate a random angle to specify the direction of movement
    float angle = random(0, 2 * PI);
    float velX = cos(angle);
    float velY = sin(angle);
    
    // Randomize speed to calculate velocity.
    float speed = random(1, 2.5);
    this.velocity = new PVector(velX, velY);
    this.velocity.mult(speed);
  }
  
  void update() {
    
    // Bounce-off the edges of the screen.
    
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
    
    // Update the position
    this.position.add(this.velocity);
  }
}
