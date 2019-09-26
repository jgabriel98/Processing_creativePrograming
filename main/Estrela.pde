//inspirado em https://processing.org/examples/animatedsprite.html

private static final int estrelaTotalFrames = 8;
private static final ArrayList<PImage> estrelaFrames = new ArrayList<PImage>();

public class Estrela extends Figura{
  private int width=0, height=0;
  static final String filePrefix = "data/start blinking-";
  static public final int totalFrames = estrelaTotalFrames ;
  final ArrayList<PImage> frames = estrelaFrames;
  int frame = 0;

  
  public Estrela(int frameStart){
    this();
    frame = frameStart;
  }
  public Estrela(){
    if(frames.isEmpty() == false) return;
    for (int i = 0; i < totalFrames; i++) {
      String filename = filePrefix + nf(i+1, 1) + ".png";
      frames.add(loadImage(filename));
      width = Math.max(width,frames.get(i).width);
      height = Math.max(height,frames.get(i).height);
    } //<>//
  }

  
  public void draw(){
    if(frameCount % (FPS/frames.size()) == 0)
      frame = ++frame % frames.size();
    image(frames.get(frame), super.origem.x + getX(), super.origem.y + getY());
  }
  
  public int getWidth(){ return this.width; }
  public int getHeight(){ return this.height; }
  
}
