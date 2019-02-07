class Slap extends Fingering{
  float x3;
  
  //constructor
  Slap(PVector l){
    super(l);
     x3 = 20*sin(45);
  }
  
  void display(){
    stroke(0);
    strokeWeight(1);
    fill(0, 242, 66);
    triangle(location.x, location.y-10, location.x, location.y+10, location.x+x3, location.y);
  }
  void update(){
     //velocity.add(acceleration);
    location.add(velocity);
    //acceleration.mult(0); //if not, why not?
    lifespan -= 70.0;
  }
}