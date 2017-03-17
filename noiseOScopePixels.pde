float centerH = 0.2;
float widthH = 0.75;

float minH = 0.5;
float maxH = 0.9;
float minS = 0.55;
float maxS = 0.99;
float minB = 1.0;
float maxB = 0.25;
float alpha = 0.03;
float transStart = 0.4;
float transWidth = 0.05;

float ah = 0.020;
float as = 0.015;
float ab = 0.02;
float ag =1;

float bp = 2;
float th = 0.50;
float ts = 0.50;
float tb = 0.017;
float tA = 0.2;

int N = 6;
float ang;
float slope;
float w = 1;

PGraphics pg;
float xRes = 800;
float yRes = 480;
void setup() {
  size( 800 , 480 );
  colorMode( HSB , 1 , 1 , 1 , 1 );
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
}

void draw() {
  float t = tA*float(frameCount);
  //minH = (centerH - 0.5*widthH ) % 1;
  //maxH = (centerH + 0.5*widthH ) % 1;
  
  loadPixels();
  for( int x = 0 ; x < width/2 ; x++ ) {
    for( int y = 0 ; y < height/2 ; y++ ) {
      if( true ) {
        float ang = noise( ah*(0*xRes + x) , ah*y , th*t );
        //float a = 0.5 - 0.5*cos(TWO_PI*ang);
        float a = ang;
        float h = (frameCount*0.001 + centerH + widthH*a )%1;
        float s = lerp( minS , maxS , noise( as*(10*xRes + x) , as*(10*yRes +y) , ts*t ) );
        s = -pow( -(s-1) , 1 ) +1;
        float b = noise( ab*(20*xRes + x) , ab*(20*yRes+y) , tb*t );
        if( b < transStart ) {
          b = 0;
        } else if( b < transStart+transWidth ) {
          b = lerp( 0 , minB , (b-transStart)/transWidth );
        } else {
          b = lerp( minB , maxB , (b-transStart-transWidth)/(1-transStart-transWidth) );
        }
        //println(pg.pixels.length);
        pixels[x+y*width] = color( h , s , b );
        pixels[(x)+(height-1-y)*width] = color( h , s , b );
        pixels[(width-1-x)+(y)*width] = color( h , s , b );
        pixels[(width-1-x)+(height-1-y)*width] = color( h , s , b );
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