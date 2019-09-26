public class Casa extends Figura{

  public color corTelhado = #953838;
  public int alturaTelhado = 0;
  public color corCasa;
  public int largura = 80;
  public int altura = 80;
  static final int janelas = 2;



  public Casa(){}
  public Casa(Point position){
    this(position.x, position.y);
  }
  public Casa(int x, int y){
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
    int yTeto = y - altura/2;
    strokeJoin(ROUND);
    strokeWeight(2);
    stroke(0);
    fill(corCasa);
    rectMode(CENTER);
    rect(x, yBase, largura, altura);
    fill(corTelhado);
    triangle(x - (largura/2), yTeto, 
             x              , yTeto - alturaTelhado,
             x + (largura/2), yTeto);
     
     
     
  }

  
};
