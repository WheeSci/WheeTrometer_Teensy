// params tab, WheeTrometer_2020


public void params() {                 // get parameters from text box
  stTime = cp5.get(Textfield.class, "Integration_Time").getText();
  iIntTime = round(float(stTime)*1000);
  IntTime = nf(iIntTime, 6);   // make ScanR have 3 digits. pad with zero if no digits
  println("integration: "+IntTime+" microseconds");
 // sLoops = cp5.get(Textfield.class, "Loops").getText();
 // sAvg = cp5.get(Textfield.class, "data_Av").getText();
 // pixAv = int(sAvg);
//  AmpVal[expNo] = int(cp5Cal.get(Textfield.class, "amp").getText());
//  Offset[expNo] = int(cp5Cal.get(Textfield.class, "offset").getText());

  stMin = cp5.get(Textfield.class, "min").getText();
  stMax = cp5.get(Textfield.class, "max").getText();
  try{
  sMin[expNo] = stMin;
  xMin[0] = float(sMin[expNo]);
  sMax[expNo] = stMax;
  xMax[0] = float(sMax[expNo]);
//  boolean bMin = false;
  //boolean bMax = false;
  int counter = 0;
  while (wavelength[counter] < xMin[0]){  // not sure what is going on here
  
  counter++;

  }
  pixMin = counter-1;  // a pix + b + c*sin((pix-p0)/(p1-p0))
  while (wavelength[counter] <= xMax[0]){  // not sure about this either
  counter++;
  }
  pixMax = counter;
} catch(Exception e){
  }
println("through params loop");
}
