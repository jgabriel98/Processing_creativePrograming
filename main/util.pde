public class Util{
  
  public void setGradient(int x, int y, float w, float h, color c1, color c2, char axis ) {
    noFill();

    if (Character.toLowerCase(axis) == 'y') {  // Top to bottom gradient
      for (int i = y; i <= y+h; i++) {
        float inter = map(i, y, y+h, 0, 1);
        inter = inter * (0.8 + random(1)/5.0);
        color c = lerpColor(c1, c2, inter);
        stroke(c);
        line(x, i, x+w, i);
      }
    }  
    else {  // Left to right gradient
      for (int i = x; i <= x+w; i++) {
        float inter = map(i, x, x+w, 0, 1);
        color c = lerpColor(c1, c2, inter);
        stroke(c);
        line(i, y, i, y+h);
      }
    }
  }

  public Casa createRandomCasa(){
    Casa casa = new Casa();
    casa.corCasa = color(random(100,200));
    casa.altura = (int)random(casa.altura*0.7, casa.altura*1.3);
    casa.largura = (int)random(casa.largura*0.7, casa.largura*1.3);
    casa.alturaTelhado = (int)(random(0,1) < 0.5? 0 : random(casa.altura*0.2, casa.altura*0.8));  //50% chance de ter telhado
    
    
    return casa;
  }

  public Predio createRandomPredio(){
    Predio predio = new Predio();
    predio.corCasa = color(random(100,200));
    predio.altura = (int)random(predio.altura*0.7, predio.altura*2.0);
    predio.largura = (int)random(predio.largura*0.7, predio.largura*1.3);
    
    
    return predio;
  }
  
}
