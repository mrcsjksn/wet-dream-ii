class HarmonicFingering extends Fingering{
  float x3;
  
  //constructor
  HarmonicFingering(PVector l){
    super(l);
  }
  
  void display(){
    stroke(0);
    strokeWeight(1);
    fill(255);
    quad(location.x-9, location.y, location.x, location.y-10, location.x+9, location.y, location.x, location.y+10);
  }
}