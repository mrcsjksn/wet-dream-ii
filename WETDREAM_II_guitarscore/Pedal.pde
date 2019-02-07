class Pedal{
  int x, y, w, h;
  float val = 0;
  color off = color(255, 255, 255); 
  color on = color(0, 0, 0);
  String name;
  
  //constructor
  Pedal(int _x, int _y, int _w, int _h, String _name){
    x = _x;
    y = _y; 
    w = _w; 
    h = _h;
    name = _name;
  }
  
  void display(float _val){
    pushMatrix();
    translate(x, height);
    rotate(-HALF_PI);
    textAlign(LEFT, BOTTOM);
    textSize(20);
    fill(0);
    text(name, 0, 0);
    popMatrix();
    //pushMatrix();
    val = _val;
    
    fill(on);
    rect(x, y, w, h);
    
    fill(off);
    rect(x, y, w, h-map(val, 0, 100, 0, h));
    //popMatrix();
  }
  
  
}