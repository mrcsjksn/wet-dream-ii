class Pick extends Fingering{
  
  float fillC = 0;
  //constructor
  Pick(PVector l){
    super(l);
  }
  
  void display(){
    stroke(0);
    fill(255, fillC, fillC);
    triangle(location.x-10, location.y-10, location.x+10, location.y-10, location.x, location.y+10);
  }
  
  void update(){
     //velocity.add(acceleration);
    //location.add(velocity);
    //acceleration.mult(0); //if not, why not?
    lifespan -= 30.0;
    fillC += 25;
  }
}