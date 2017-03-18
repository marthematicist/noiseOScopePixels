float centerH = 0;
float widthH = 0.7;

float minS = 0.0;
float maxS = 1.0;
float minB = 0.3;
float maxB = 1.0;
float alpha = 0.03;
float transStart = 0.45;
float transWidth = 0.02;

float ah = 0.005;
float as = 0.055;
float ab = 0.055;
float af = 0.012;
float ag = 1;

float th = 0.060;
float ts = 0.030;
float tb = 0.010;
float tf = 0.005;
float tc = 0.003;
float tA = 0.4;

int numSpokes = 12;
float ang;
int w = 1;

float[] px;
float[] py;

color[] P;

float xRes;
float yRes;
void setup() {
  size( 800 , 480 );
  xRes = float(width);
  yRes = float(height);
  centerH = random(0, 1);
  noStroke();
  background(0);
  ang = 2*PI/float(numSpokes);
  println( ang );

  
  P = new color[(width/2)*(height/2)];
  for ( int x = 0; x < width/2; x++ ) {
    for ( int y = 0; y < height/2; y++ ) {
      P[x+y*width/2] = color(0,0,0);
    }
  }
  
  px = new float[(width/2)*(height/2)];
  py = new float[(width/2)*(height/2)];
  for ( int x = 0; x < width/2; x++ ) {
    for ( int y = 0; y < height/2; y++ ) {
      float x2 = float(x) + 0.5;
      float y2 = float(y) + 0.5;
      PVector v = new PVector( x2, y2 );
      float a = (v.heading() + PI)%ang;
      if ( a > 0.5*ang ) { 
        a = ang - a;
      }
      float r = v.mag();
      px[x+y*width/2] = r*cos(a);
      py[x+y*width/2] = r*sin(a);
    }
  }
}

void draw() {
  float t = tA*float(frameCount);
  loadPixels();
  for ( int x = 0; x < width/2; x++ ) {
    for ( int y = 0; y<=x && y<height/2; y++ ) {
      float x2 = px[x+y*width/2];
      float y2 = py[x+y*width/2];

      float f = noise( ag*af*(30*xRes + x2), ag*af*(30*yRes + y2), tf*t ) ;
      color c;
      if ( f > transStart && f < transStart+transWidth ) {
        c = lerpColor( P[x+y*width/2], color(255, 255, 255), alpha );
      } else if ( f >= transStart+transWidth ) {
        float h = (frameCount*tc*tA + centerH + widthH*noise( ag*ah*(0*xRes + x2), ag*ah*y2, th*t ) )%1;
        float s = lerp( minS, maxS, noise( ag*as*(10*xRes + x2), ag*as*(10*yRes + y2), ts*t ) );
        float b = lerp( minB, maxB, noise( ag*ab*(20*xRes + x2), ag*ab*(20*yRes + y2), tb*t ) );
        c = lerpColor( P[x+y*width/2], hsbColor(h*360, s, b), alpha );
      } else {
        c = lerpColor( P[x+y*width/2], color(0, 0, 0), alpha );
      }
      P[x+y*width/2] = c;
      pixels[ (width/2+x) + (height/2+y)*width ] = c;
      pixels[ (width/2+x) + (height/2-y)*width ] = c;
      pixels[ (width/2-x) + (height/2+y)*width ] = c;
      pixels[ (width/2-x) + (height/2-y)*width ] = c;
      if( x < height/2 ) {
        pixels[ (width/2+y) + (height/2+x)*width ] = c;
        pixels[ (width/2+y) + (height/2-x)*width ] = c;
        pixels[ (width/2-y) + (height/2+x)*width ] = c;
        pixels[ (width/2-y) + (height/2-x)*width ] = c;
      }
    }
  }
  
  for( int x = 0 ; x < width/2 ; x++ ) {
    for( int y = 0 ; y <= x ; y++ ) {
      
    }
  }
  updatePixels();


  println(frameRate);
}



void mouseMoved() {
}
void mouseDragged() {
}

color hsbColor( float h, float s, float b ) {
  float c = b*s;
  float x = c*( 1 - abs( (h/60) % 2 - 1 ) );
  float m = b - c;
  float rp = 0;
  float gp = 0;
  float bp = 0;
  if ( 0 <= h && h < 60 ) {
    rp = c;  gp = x;  bp = 0;
  }
  if ( 60 <= h && h < 120 ) {
    rp = x;  gp = c;  bp = 0;
  }
  if ( 120 <= h && h < 180 ) {
    rp = 0;  gp = c;  bp = x;
  }
  if ( 180 <= h && h < 240 ) {
    rp = 0;  gp = x;  bp = c;
  }
  if ( 240 <= h && h < 300 ) {
    rp = x;  gp = 0;  bp = c;
  }
  if ( 300 <= h && h < 360 ) {
    rp = c;  gp = 0;  bp = x;
  }
  return color( (rp+m)*255, (gp+m)*255, (bp+m)*255 );
}