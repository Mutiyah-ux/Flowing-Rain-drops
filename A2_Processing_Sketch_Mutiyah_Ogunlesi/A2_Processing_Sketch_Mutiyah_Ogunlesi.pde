/**
 * Processing Sketch
 * Assignment 2
 * by: Mutiyah Ogunlesi
 * Created: October 2022
 *
 * Sea wave with bubble drops
 *
 * An implementation of Bubble drops
 * reacting to mouse reaction to fill
 * the sea wave-like pattern
 *
 * Click the mouse to add new bubble.
 */

ArrayList<Flocker> flock = new ArrayList<Flocker>();
float yoff = 0.0;

void setup() {
  size(1024, 768);
  noStroke();
}

void draw() {
  background(#A1C7E0);
  fill(#C7FFED);
  beginShape();

// Perlin Noise for sea wave
  float xoff = 0;
  for (float x = 0; x <= width; x += 10) {
    float y = map(noise(xoff, yoff), 0, 1, 600, 300);
    vertex(x, y);
    xoff += 0.05;
  }
  // increment y dimension for noise
  yoff += 0.02;
  vertex(width, height);
  vertex(0, height);
  endShape(CLOSE);

  // Flocker for Bubble drops
  for (Flocker f : flock) {
    f.step();
    f.draw();
  }
}

void mouseDragged() {
  flock.add(new Flocker(mouseX, mouseY));
}

class Flocker {

  float x;
  float y;
  float heading = random(TWO_PI);
  float speed = random(1, 3);
  float radius = random(10, 10);

  public Flocker(float x, float y) {
    this.x = x;
    this.y = y;
  }

  void step() {


    if (flock.size() > 1) {

      float closestDistance = 100000;
      Flocker closestFlocker = null;
      for (Flocker f : flock) {

        if (f != this) {
          float distance = dist(x, y, f.x, f.y);
          if (distance < closestDistance) {
            closestDistance = distance;
            closestFlocker = f;
          }
        }
      }

      float angleToClosest = atan2(closestFlocker.y-y, closestFlocker.x-x);

      if (heading-angleToClosest > PI) {
        angleToClosest += TWO_PI;
      } else if (angleToClosest-heading > PI) {
        angleToClosest -= TWO_PI;
      }

      if (heading < angleToClosest) {
        heading+=PI/40;
      } else {
        heading-=PI/40;
      }

      //moving in direction
      x += cos(heading)*speed;
      y += sin(heading)*speed;

      //wrap around edges
      if (x < 0) {
        x = width;
      }
      if (x > width) {
        x = 0;
      }

      if (y < 0) {
        y = height;
      }
      if (y > height) {
        y = 0;
      }
    }
  }

  void draw() {
    ellipse(x, y, radius, radius);
  }
}
