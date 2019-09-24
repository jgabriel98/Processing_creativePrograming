/**
 * Reposition Canvas (v1.01)
 * by GoToLoop (2014/Apr)
 *
 * forum.processing.org/two/discussion/4712/window-location
 */
import processing.opengl.*;
 
//static final int WINDOW_X = 500, WINDOW_Y = 500;
static final int FPS = 60, FREQ = (1<<5) - 1;
static final String RENDERER = P2D;

int last_locationX;
int last_locationY;
 
void setup() {
  size(800, 600, RENDERER);
  surface.setTitle("minha janela");
  surface.setResizable(true);
  frameRate(FPS);
  smooth(4);
  
 
  //thread("repositionCanvas");
}
 
void draw() {
  print("\nX - Y = " + get_sketch_location_x() + " - " + get_sketch_location_y()+"\t");
  surface.setLocation(get_sketch_location_x(), get_sketch_location_y());
  /*
  if(mouseX <= 1 && get_sketch_location_x() > 0){
    int newX = get_sketch_location_x()-1;
    int newY = get_sketch_location_y();
    surface.setLocation(newX, newY);
    print("MOving windows to left-> x,y = "+newX+","+newY); //<>// //<>//
  }*/
}



int get_sketch_location_x() {
  if(get_renderer() != P3D && get_renderer() != P2D) {
    return getJFrame(getSurface()).getX();
  } else {
    return get_rectangle(surface).getX();
  }
}

int get_sketch_location_y() {
  if(get_renderer() != P3D && get_renderer() != P2D) {
    return getJFrame(getSurface()).getY();
  } else {
    return get_rectangle(surface).getY();
  }
}


com.jogamp.nativewindow.util.Rectangle get_rectangle(PSurface surface) {
  com.jogamp.newt.opengl.GLWindow window = (com.jogamp.newt.opengl.GLWindow) surface.getNative();
  com.jogamp.nativewindow.util.Rectangle rectangle = window.getBounds();
  return rectangle;
}


static final javax.swing.JFrame getJFrame(final PSurface surface) {
  return (javax.swing.JFrame)
  (
    (processing.awt.PSurfaceAWT.SmoothCanvas) surface.getNative()
  ).getFrame();
}

String get_renderer(){
  return RENDERER;
}

