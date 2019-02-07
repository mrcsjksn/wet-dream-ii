class Tremolo extends Fingering{
  float x3;
  
  //constructor
  Tremolo(PVector l){
    super(l);
  }
  
  void display(){
    stroke(0);
    strokeWeight(1);
    shape(trem, location.x, location.y-10, 20, 20);
  }
  void update(){
     //velocity.add(acceleration);
    //location.add(velocity);
    //acceleration.mult(0); //if not, why not?
    lifespan -= 10.0;
  }
}