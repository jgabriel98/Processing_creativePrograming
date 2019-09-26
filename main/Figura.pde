public abstract class Figura{
    Point origem = null;
    Point position = new Point();
  
    public abstract void draw();
    
    public Point getPontoOrigem(){ return new Point(origem); }
    public void setPontoOrigem(Point origem){ this.origem = origem; }
    
    public void setX(int x){ position.x = x; }
  
    public void setY(int y){ position.y = y; }

    public int getX(){ return position.x; }
  
    public int getY(){ return position.y; }
  
}
