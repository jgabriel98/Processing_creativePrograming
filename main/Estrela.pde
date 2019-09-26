//inspirado em https://processing.org/examples/animatedsprite.html
public class Estrela extends Figura{
  PImage[] frames;
  static final int totalFrames = 8 ;
  int frame = 0;
  static final String filePrefix = "data/start blinking-";
  
  public Estrela(int frameStart){
    this();
    frame = frameStart;
  }
  public Estrela(){
    frames = new PImage[totalFrames];
    for (int i = 0; i < totalFrames; i++) {
      String filename = filePrefix + nf(i+1, 1) + ".png";
      frames[i] = loadImage(filename);
    } //<>//
  }

  
  public void draw(){
    if(frameCount % (FPS/frames.length) == 0)
      frame = ++frame % frames.length;
    image(frames[frame], getX(), getY());
  }
  
}
