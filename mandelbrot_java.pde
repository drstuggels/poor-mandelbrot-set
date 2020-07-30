import java.lang.*;

int colorOffset = 100;

int maxIterations = 40;

float zoomX[] = {-2.5, 1.0};
float zoomY[] = {-1.0, 1.0};
float zoomRatio = 1.0;

void setup() {
  fullScreen(P2D);

  background(0);
  stroke(255);
  strokeWeight(1);

  colorMode(HSB);

  drawFractal();
}

void draw() {
}

void drawFractal() {
  background(0);

  float zoomXval[] = {zoomX[0]*zoomRatio, zoomX[1]*zoomRatio};
  float zoomYval[] = {zoomY[0]*zoomRatio, zoomY[1]*zoomRatio};

  loadPixels();
  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {

      float relativeX = map((float)x, 0.0, width, zoomXval[0], zoomXval[1]);
      float relativeY = map((float)y, 0.0, height, zoomYval[0], zoomYval[1]);

      float c[] = {relativeX, relativeY};

      int iterations = (int)mandelbrot(c);

      int hue = (int(255*iterations/maxIterations)+colorOffset)%255;
      int saturation = 255;
      int value = iterations < maxIterations ? 255 : 0;

      pixels[y*int(width)+x] = color(hue,saturation,value);
    }
  }
  updatePixels();
}

double mandelbrot(float c[]) {
  double x = 0;
  double y = 0;

  int n = 0;
  while (x*x+y*y<=2*2 && n < maxIterations) {
    double xtemp = x*x-y*y+c[0];
    y = 2*x*y+c[1];
    x = xtemp;
    n++;
  }

  if (n == maxIterations) {
    return maxIterations;
  }
  double loglol = Math.log(Math.log(2)*x*x+y*y);
  return n + 1 - loglol;
}


void mouseWheel(MouseEvent event) {
  float amount = event.getCount();
  zoomRatio *= amount > 0 ? 2 : 0.5;
  drawFractal();
}

void keyPressed() {
  switch(keyCode) {
  case UP:
    zoomY[0] -= 0.25;
    zoomY[1] -= 0.25;
    break;
  case DOWN:
    zoomY[0] += 0.25;
    zoomY[1] += 0.25;
    break;
  case LEFT:
    zoomX[0] -= 0.25;
    zoomX[1] -= 0.25;
    break;
  case RIGHT:
    zoomX[0] += 0.25;
    zoomX[1] += 0.25;
    break;
  case TAB:
    maxIterations += 1000;
    break;
  case BACKSPACE:
    maxIterations -= 1000;
    break;
  default:
    return;
  }
  println(maxIterations);
  drawFractal();
}

void mouseClicked() {
  colorOffset += 10;
  drawFractal();
}
