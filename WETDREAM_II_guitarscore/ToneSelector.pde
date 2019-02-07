class ToneSelector {
  float tsxPos, tsyPos;
  int numSwitches;
  float size;
  int modeNum;

  ToneSelector(float _tsxPos, float _tsyPos, int _numSwitches) {
    tsxPos = _tsxPos;
    tsyPos = _tsyPos;
    numSwitches = _numSwitches;
    size = 16;
  }

  void display(int _modeNum) {
    modeNum = _modeNum;
    fill(100);
    rect(tsxPos, tsyPos, numSwitches*size+10, size+4);
    for (int i = 0; i < numSwitches; i++) {
      if (i == modeNum) {
        fill(onPed);
        rect((tsxPos+2)*(i+1), tsyPos+2, size, size);
      } else{
        fill(offPed);
        rect((tsxPos+2)*(i+1), tsyPos+2, size, size);
      }
    }
  }
}