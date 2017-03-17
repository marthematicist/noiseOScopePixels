float centerH = 0.2;
float widthH = 0.75;


float minS = 0.05;
float maxS = 0.99;
float minB = 1.0;
float maxB = 0.35;
float alpha = 0.035;
float transStart = 0.4;
float transWidth = 0.02;

float ah = 0.020;
float as = 0.015;
float ab = 0.03;
float ag =1;

float bp = 2;
float th = 0.15;
float ts = 0.15;
float tb = 0.02;
float tA = 0.2;

int N = 8;
float ang;
float slope;
float w = 1;

float[] x1;
float[] y1;

PGraphics pg;
float xRes = 800;
float yRes = 480;
void setup() {
  size( 800 , 480 );
  //colorMode( HSB , 1 , 1 , 1 , 1 );
  pg = createGraphics( 800 , 480 );
  
  pg.beginDraw();
  pg.colorMode( HSB , 1 , 1 , 1 , 1 );
  pg.clear();
  pg.noStroke();
  pg.endDraw();
  noStroke();
  ang = 2*PI/float(N);
  slope = tan( 0.5*ang );
  println( ang );
  centerH = random(0,1);
  
  x1 = new float[width*height];
  y1 = new float[width*height];
  for( int x = 0 ; x < width ; x++ ) {
    for( int y = 0 ; y < height ; y++ ) {
      float x2 = float(x) - 0.5*xRes;
      float y2 = float(y) - 0.5*yRes;
      PVector v = new PVector( x2 , y2 );
      float a = (v.heading() + PI)%ang;
      if( a > 0.5*ang ) { a = ang - a; }
      float r = v.mag();
      x1[x+y*width] = r*cos(a);
      y1[x+y*width] = r*sin(a);
    }
  }
}

void draw() {
  float t = tA*float(frameCount);
  //minH = (centerH - 0.5*widthH ) % 1;
  //maxH = (centerH + 0.5*widthH ) % 1;
  
  loadPixels();
  for( int x = 0 ; x < width/2 ; x++ ) {
    for( int y = 0 ; y < height/2 ; y++ ) {
      if( true ) {
        float x2 = x1[x+y*width];
        float y2 = y1[x+y*width];
        float ang = noise( ah*(0*xRes + x2) , ah*y2 , th*t );
        //float a = 0.5 - 0.5*cos(TWO_PI*ang);
        float a = ang;
        float h = (frameCount*0.001 + centerH + widthH*a )%1;
        float s = lerp( minS , maxS , noise( as*(10*xRes + x2) , as*(10*yRes +y2) , ts*t ) );
        s = -pow( -(s-1) , 1 ) +1;
        float b = noise( ab*(20*xRes + x2) , ab*(20*yRes+y2) , tb*t );
        if( b < transStart ) {
          b = 0;
        } else if( b < transStart+transWidth ) {
          b = lerp( 0 , minB , (b-transStart)/transWidth );
        } else {
          b = lerp( minB , maxB , (b-transStart-transWidth)/(1-transStart-transWidth) );
        }
        //println(pg.pixels.length);
        color c = lerpColor( pixels[x+y*width] , hsbColor(h*360,s,b) , alpha );
        pixels[x+y*width] = c;
        pixels[(x)+(height-1-y)*width] = c;
        pixels[(width-1-x)+(y)*width] = c;
        pixels[(width-1-x)+(height-1-y)*width] = c;
        //pg.pixels[x+(-y+height/2)*width] = color( h , s , b , alpha );
      }
    }
  }
  updatePixels();
  
  
  println(frameRate);
}
/*
void mouseMoved() {
  centerH = mouseX / xRes;
  ah = lerp( 0.02 , 0.09 , mouseY / yRes );
}

void mouseDragged() {
  centerH = mouseX / xRes;
  ah = lerp( 0.02 , 0.09 , mouseY / yRes );
}
*/

color hsbColor( float h , float s , float b ) {
  float c = b*s;
  float x = c*( 1 - abs( (h/60) % 2 - 1 ) );
  float m = b - c;
  float rp = 0;
  float gp = 0;
  float bp = 0;
  if( 0 <= h && h < 60 ) {
    rp = c;  gp = x ; bp = 0;
  }
  if( 60 <= h && h < 120 ) {
    rp = x;  gp = c ; bp = 0;
  }
  if( 120 <= h && h < 180 ) {
    rp = 0;  gp = c ; bp = x;
  }
  if( 180 <= h && h < 240 ) {
    rp = 0;  gp = x ; bp = c;
  }
  if( 240 <= h && h < 300 ) {
    rp = x;  gp = 0 ; bp = c;
  }
  if( 300 <= h && h < 360 ) {
    rp = c;  gp = 0 ; bp = x;
  }
  return color( (rp+m)*255 , (gp+m)*255 , (bp+m)*255 );
}