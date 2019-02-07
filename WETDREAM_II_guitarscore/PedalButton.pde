class PedalButton {
  boolean onOff = false;
  float x;
  float y;
  String name;

  //constructor
  PedalButton(float _xPos, float _yPos, boolean _onOff, String _name) {
    x = _xPos; 
    y = _yPos; 
    onOff = _onOff;
    name = _name;
  }

  void display(float _color) {


    stroke(30);
    strokeWeight(0.06);
    fill(_color);
    rect(x, y, 99, 149);
    pushMatrix();
    translate(x, height);
    rotate(-HALF_PI);
    textAlign(LEFT, TOP);
    textSize(20);
    fill(255, 0, 0);
    text(name, 0, 0);
    popMatrix();
  }
}