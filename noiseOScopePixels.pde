float centerH = 0;
float widthH = 0.5;

float minS = 0.3;
float maxS = 1.0;
float minB = 0.5;
float maxB = 1.0;
float alpha = 0.03;
float transStart = 0.5;
float transWidth = 0.02;

float ah = 0.020;
float as = 0.035;
float ab = 0.035;
float af = 0.012;

float th = 0.060;
float ts = 0.030;
float tb = 0.010;
float tc = 0.003;
float tA = 0.4;

int N = 12;
float ang;

float[] x1;
float[] y1;

float xRes = 800;
float yRes = 480;
void setup() {
  size( 800 , 480 );
  //colorMode( HSB , 1 , 1 , 1 , 1 );
  centerH = random(0,1);
  

  noStroke();
  background(0);
  ang = 2*PI/float(N);
  println( ang );
  
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
  
  loadPixels();
  for( int x = 0 ; x < width/2 ; x++ ) {
    for( int y = 0 ; y < height/2 ; y++ ) {
      if( true ) {
        float x2 = x1[x+y*width];
        float y2 = y1[x+y*width];
        
        float f = noise( af*(30*xRes + x2) , af*(30*yRes + y2) , tb*t ) ;
        color c;
        if( f > transStart && f < transStart+transWidth ) {
          c = lerpColor( pixels[x+y*width] , color(255,255,255) , alpha );
        } else if( f >= transStart+transWidth ) {
          float h = (frameCount*tc*tA + centerH + widthH*noise( ah*(0*xRes + x2) , ah*y2 , th*t ) )%1;
          float s = lerp( minS , maxS , noise( as*(10*xRes + x2) , as*(10*yRes + y2) , ts*t ) );
          float b = lerp( minB , maxB , noise( ab*(20*xRes + x2) , ab*(20*yRes + y2) , tb*t ) );
          c = lerpColor( pixels[x+y*width] , hsbColor(h*360,s,b) , alpha );
        } else{
          c = lerpColor( pixels[x+y*width] , color(0,0,0) , alpha );
        }

        pixels[x+y*width] = c;
        pixels[(x)+(height-1-y)*width] = c;
        pixels[(width-1-x)+(y)*width] = c;
        pixels[(width-1-x)+(height-1-y)*width] = c;
      }
    }
  }
  updatePixels();
  
  
  println(frameRate);
}

void mouseMoved() {

}
void mouseDragged() {
  
}

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
