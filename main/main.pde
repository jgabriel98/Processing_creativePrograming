/**
 * Reposition Canvas (v1.01)
 * by GoToLoop (2014/Apr)
 *
 * forum.processing.org/two/discussion/4712/window-location
 */
import processing.opengl.*;
import java.awt.Point;  //https://forum.processing.org/one/topic/global-mouse.html
import java.awt.MouseInfo;
import java.awt.Frame;
import javafx.scene.canvas.Canvas;

static final String RENDERER = P2D;  //FX2D, JAVA2D, P2D ou P3D (only p2d/p3d working correctly)
 
static final int WINDOW_WIDTH = 800, WINDOW_HEIGHT = 600;
static final int FPS = 20, FREQ = (1<<5) - 1;
static final double WINDOW_SPEED = 10.0;  //pixels per frame


Point myMouse = new Point();


void setup(){
  surface.setTitle("minha janela");
  surface.setResizable(false);
  frameRate(FPS);
  noStroke();
  colorMode(RGB, 255);
}

 
void settings() {
  size(WINDOW_WIDTH, WINDOW_HEIGHT, RENDERER);
  smooth(8);
  

  //thread("repositionCanvas");
}
int i=0;
void draw() {
  background(0);
  updateMyMouse();
  
  print("\nX - Y = " + get_sketch_location_x() + " - " + get_sketch_location_y()+"\tline "+(i++));
  println("mouse pos: "+myMouse.x+", "+myMouse.y);
  repositionWindow();
  
  Point[] star = new Point[5];
  for(int i=0; i<star.length; i++){
    if(i>0) star[i] = star[i-1]; //<>//
    int shineLayers = 3;
    for(int k=0; k < shineLayers; k++){
      fill(255, 255, 0, (255*0.3)/(k+1));
      int size = (int)( ( (double)(50*(k+1) ) * ( (double)i/star.length) ) );
      ellipse(myMouse.x, myMouse.y, size, size);
    }
    
  }
  star[0] = new Point(myMouse);
  
}

void repositionWindow(){
  
  int topBar=0;
  if(RENDERER.equals(JAVA2D))topBar = getJFrame(getSurface()).getInsets().top;
  if(RENDERER.equals(FX2D))  topBar = (int) ( getFxWindow(getSurface()).getHeight() - ((Canvas) surface.getNative()).getScene().getHeight() );
  
  int newX = get_sketch_location_x(), newY = get_sketch_location_y();
  boolean moveWindow=false;
  
  if(myMouse.x <= 0){
    newX -= WINDOW_SPEED;
    moveWindow=true;
  }else if(myMouse.x >= WINDOW_WIDTH){
    newX += WINDOW_SPEED;
    moveWindow = true;
  }
  
  if(myMouse.y -topBar <= 0){
    newY -= WINDOW_SPEED;
    moveWindow=true;
  }else if(myMouse.y -topBar >= WINDOW_HEIGHT){
    newY += WINDOW_SPEED;
    moveWindow = true;
  }
  
  if(moveWindow){
    if(RENDERER.equals(P2D))   get_window(surface).setPosition(newX, newY);
    if(RENDERER.equals(JAVA2D))getJFrame(getSurface()).setLocation(newX, newY);  //para JAVA2D
    if(RENDERER.equals(FX2D)){ getFxWindow(getSurface()).setX(newX); getFxWindow(getSurface()).setY(newY); }  //para JAVA2D
    
    println("\tmoving window to: "+newX+" , "+newY); 
  }
}


void updateMyMouse(){
  Point loc = MouseInfo.getPointerInfo().getLocation();
  myMouse.y = loc.y - get_sketch_location_y();
  myMouse.x = loc.x - get_sketch_location_x();
}



int get_sketch_location_x() {
  String renderer = RENDERER;
  if(renderer == P3D || renderer == P2D) {
    return get_window(surface).getX();
  } if(renderer == FX2D){
    return (int)getFxWindow(getSurface()).getX();
  } else {
    return getJFrame(getSurface()).getX();
  }
}

int get_sketch_location_y() {
  String renderer = RENDERER;
  if(renderer == P3D || renderer == P2D) {
    return get_window(surface).getY();
  } if(renderer == FX2D){
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
