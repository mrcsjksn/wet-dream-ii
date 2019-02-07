class Fingering{

  PVector location;
  PVector velocity;
  //PVector acceleration;
  float lifespan;

  //constructor
  Fingering(PVector _location){
    velocity = new PVector(random(-1, 1), 0);
    location = _location.copy();
    lifespan = random(200, 500);
  }
  
  void run(){
    update();
    display();
  }
  
  void update(){
     //velocity.add(acceleration);
    //location.add(velocity);
    //acceleration.mult(0); //if not, why not?
    lifespan -= 20.0;
  }
  
  void display(){
    stroke(0);
    strokeWeight(0.1);
    fill(lPressure);
    ellipse(location.x, location.y, 20, 20);
    
  }
  

  boolean  isDead(){
    if(lifespan < 0.0){
      return true;
    }
    else{
      return false;
    }
  }
}