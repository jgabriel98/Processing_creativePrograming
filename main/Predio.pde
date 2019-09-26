public class Predio extends Figura{

  public color corCasa;
  public int largura = 80;
  public int altura = 180;
  static final int janelasPorAndar = 2;


  public Predio(){}
  public Predio(Point position){
    this(position.x, position.y);
  }
  public Predio(int x, int y){
    setX(x);
    setY(y);
  }
  
  public void draw(int x, int y){
    setX(x); setY(y);
    draw();
  }
  
  public void draw(){
    int x = position.x + super.origem.x;
    int y = position.y + super.origem.y;
    int yBase = y - altura/2;
    strokeJoin(ROUND);
    strokeWeight(2);
    stroke(0);
    fill(corCasa);
    rectMode(CENTER);
    rect(x, yBase, largura, altura);

     
    
  }

  
};
