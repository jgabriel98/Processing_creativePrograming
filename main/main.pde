import processing.opengl.*;
import java.awt.Point;  //https://forum.processing.org/one/topic/global-mouse.html
import java.awt.MouseInfo;
import java.awt.Frame;
import javafx.scene.canvas.Canvas;

static final String RENDERER = P2D;  //FX2D, JAVA2D, P2D ou P3D (only p2d/p3d working correctly)
static final int WINDOW_WIDTH = 800, WINDOW_HEIGHT = 600;
static final int FPS = 120;
static final double WINDOW_SPEED = Math.pow(1.0/(double)FPS, 1.2);  // per frame
final Util UTIL = new Util();
Point ORIGEM_TELA = new Point(0, 0);


Point myMouse = new Point();
Figura[][] casas = new Figura[5][25];
Estrela[] estrelas = new Estrela[150];
Point[] star = new Point[FPS];
PImage[] sStar = new PImage[7];

PImage fundo = new PImage();


void setup() {
  surface.setTitle("minha janela");
  surface.setResizable(false);
  surface.setLocation(500, 500);
  frameRate(FPS);
  noStroke();
  colorMode(RGB, 255);
  imageMode(CENTER);
  //pixelDensity(1);

  for (int i=0; i< star.length; i++) { 
    star[i] = new Point();
  }
  for (int i = 0; i < sStar.length; i++) {
    String filename = "shooting star-" + nf(i, 1) + ".png";
    sStar[i] = loadImage(filename);
  }
  fundo = loadImage("data/fundoPredios.png");
  for (int i=0; i< estrelas.length; i++) { //<>//
    estrelas[i] = new Estrela((int)random(0,8));
    estrelas[i].setPontoOrigem(ORIGEM_TELA);
    estrelas[i].setX( (int)random(-estrelas[i].getWidth(), displayWidth+estrelas[i].getWidth()) );
    estrelas[i].setY( (int)random(-estrelas[i].getHeight(), displayHeight+estrelas[i].getHeight()) );
  }
  for (int i=0; i < casas.length; i++) {
    int rowMiddle = (displayHeight/casas.length)*(i+1);
    for (int j=0; j < casas[0].length; j++) {
      if(i==0)                     casas[i][j] = UTIL.createRandomCasa();
      else if(i == casas.length-1) casas[i][j] = UTIL.createRandomPredio();
      else casas[i][j] = (random(0,1) < 0.5) ? UTIL.createRandomCasa() : UTIL.createRandomPredio();

      casas[i][j].setPontoOrigem(ORIGEM_TELA);
      casas[i][j].setX((int)random(0, displayWidth+1));
      casas[i][j].setY(rowMiddle + (int)(rowMiddle * 0.1* random(-1, 1)) );  //20% de dispersão
    }
  }
}


void settings() {
  size(WINDOW_WIDTH, WINDOW_HEIGHT, RENDERER);
  smooth(8);
  //thread("repositionCanvas");
}




void draw() {
  if (pWindowX == -1) {
    pWindowX = get_sketch_location_x();
    pWindowY = get_sketch_location_y();
  }
  color bcolor1 = color(8, 10, 41);  //lerpColor(bcolor1, bcolor2, pWindowX)
  color bcolor2 = color(49, 57, 152);  //color(47,52,118);
  UTIL.setGradient(0, 0, WINDOW_WIDTH, WINDOW_HEIGHT, 
    lerpColor(bcolor1, bcolor2, (float)pWindowY/(float)displayHeight), 
    lerpColor(bcolor1, bcolor2, (float)(pWindowY+WINDOW_HEIGHT)/(float)displayHeight), 
    'y');
  
  desenhaPredios();
  

  updateMyMouse();
  repositionWindow();

  //print("\nX - Y = " + get_sketch_location_x() + " - " + get_sketch_location_y());
  //print("############ MOUSE pos: "+myMouse.x+", "+myMouse.y);

  for(Estrela e : estrelas) {
    if(frameCount % (FPS/e.totalFrames) == 0){
      e.setX(e.getX()+(int)random(-5,5));
      e.setY(e.getY()+(int)random(-5,5));
    }

    e.draw();
  }


  for(Figura[] row : casas) {
    for(Figura casa: row){
      //casa.draw();
    }
  }
  
 
  drawShootingStar();


  //cauda da estrela cadente
  noStroke();
  for (int i=0; i<star.length; i++) {

    if(frameCount%2==0){
      if (i+1 < star.length) {
        star[star.length-i-1] = new Point(star[star.length-i-2]);
        star[star.length-i-1].y +=1;  //faz ela cair um pouco por frame
      }
    }

    int shineLayers = 4;
    for (int k=0; k < shineLayers; k++) {
      double satBase = Math.pow(1.0 - ((double)i/(double)star.length), 1.7);
      double sat = satBase*(255*0.2) / (2*(k+1));
      int size = (int)( ( (double)(50*(k+1) ) * ( (double)i/star.length) ) );

      fill(255, 255, 0, (int)sat );
      ellipse(star[i].x, star[i].y, size, size);
    }
  }
  star[0] = myMouse;
}


void desenhaPredios(){
  imageMode(CENTER);
  image(fundo, ORIGEM_TELA.x + displayWidth/2, ORIGEM_TELA.y + displayHeight/2);
}


int pWindowX = -1, pWindowY = -1;

void repositionWindow() {
  boolean moveWindow=false;
  int topBar=0;
  if (RENDERER.equals(JAVA2D))topBar = getJFrame(getSurface()).getInsets().top;
  if (RENDERER.equals(FX2D))  topBar = (int) ( getFxWindow(getSurface()).getHeight() - ((Canvas) surface.getNative()).getScene().getHeight() );

  int oldX, newX, oldY, newY;
  oldX = newX = get_sketch_location_x();
  oldY = newY = get_sketch_location_y();

  double distX = (double)(myMouse.x - WINDOW_WIDTH/2), distY = (double)(myMouse.y - WINDOW_HEIGHT/2);
  distX *=10; distY *=10;


  if (myMouse.x <= 0) {
    moveWindow=true;
  } else if (myMouse.x >= WINDOW_WIDTH) {
    moveWindow = true;
  }

  if (myMouse.y - topBar <= 0 && oldX > 0) {
    moveWindow=true;
  } else if (myMouse.y -topBar >= WINDOW_HEIGHT) {
    moveWindow = true;
  }

  if (moveWindow) {
    newX += distX *WINDOW_SPEED;
    newY += distY *WINDOW_SPEED;
    if (RENDERER.equals(P2D))   get_window(surface).setPosition(newX, newY);
    if (RENDERER.equals(JAVA2D))getJFrame(getSurface()).setLocation(newX, newY);  //para JAVA2D
    if (RENDERER.equals(FX2D)) { 
      getFxWindow(getSurface()).setX(newX); 
      getFxWindow(getSurface()).setY(newY);
    }  //para JAVA2D

    ORIGEM_TELA.x += (pWindowX - get_sketch_location_x());
    ORIGEM_TELA.y += (pWindowY - get_sketch_location_y());
    pWindowX = get_sketch_location_x(); 
    pWindowY = get_sketch_location_y();

    println("\tmoving window to: "+newX+" , "+newY);
  }
}


int frameIdx = 0;
void drawShootingStar(){
  if(frameCount % (FPS/sStar.length) == 0)
    frameIdx = ++frameIdx % sStar.length;
  image(sStar[frameIdx], myMouse.x, myMouse.y);
}



void updateMyMouse() {
  Point loc = MouseInfo.getPointerInfo().getLocation();
  myMouse.y = loc.y - get_sketch_location_y();
  myMouse.x = loc.x - get_sketch_location_x();
}

Point getMouseWithinWindow() {
  int x, y;

  x = Math.min( myMouse.x, WINDOW_WIDTH);
  x = Math.max( x, 0);
  y = Math.min( myMouse.y, WINDOW_HEIGHT);
  y = Math.max( y, 0);

  return new Point(x, y);
}



int get_sketch_location_x() {
  String renderer = RENDERER;
  if (renderer == P3D || renderer == P2D) {
    return get_window(surface).getX();
  } 
  if (renderer == FX2D) {
    return (int)getFxWindow(getSurface()).getX();
  } else {
    return getJFrame(getSurface()).getX();
  }
}

int get_sketch_location_y() {
  String renderer = RENDERER;
  if (renderer == P3D || renderer == P2D) {
    return get_window(surface).getY();
  } 
  if (renderer == FX2D) {
    return (int)getFxWindow(getSurface()).getY();
  } else {
    return getJFrame(getSurface()).getY();
  }
}


com.jogamp.newt.opengl.GLWindow get_window(PSurface surface) {
  com.jogamp.newt.opengl.GLWindow window = (com.jogamp.newt.opengl.GLWindow) surface.getNative();
  return window;
}

//mini buggy (miss Y axis by windowTopBar size in pixels but fixed by gambiarra in code)
static final javax.swing.JFrame getJFrame(final PSurface surface) {
  return (javax.swing.JFrame)((processing.awt.PSurfaceAWT.SmoothCanvas) surface.getNative()).getFrame();
}

//mini buggy
final javafx.stage.Window getFxWindow(final PSurface surface) {
  return ((Canvas) surface.getNative()).getScene().getWindow();
}


//IDEAS: Colocar arvores na cidade, onde elas interagem assim: https://processing.org/examples/tree.html

//RUN PROGRAM ON COMMAND LINE: processing-java --sketch="$(CURRENT_DIRECTORY)" --output="$(CURRENT_DIRECTORY)/output" --force --run
//FONTE: https://forum.processing.org/two/discussion/20681/running-processing-sketch-from-command-line-on-windows
