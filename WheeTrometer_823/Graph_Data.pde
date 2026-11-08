// Graph_Data tab, WheeTrometer_Teensy1
// wavelengthCalc() called in serial read, after ABC values read
// newXVals() method called on line 21 graph_data method
// graph_data() method called on line ~397 main tab, original method
//

void wavelengthCalc(){
  /*ABC[0] =242;
  ABC[1] =0.146952;
  ABC[2] = 0;  //32.470;
  */
      print("wavelengths ");
      try{
        // data size should be 3648
// int xDataSize = 3646;                // setup assumes no pixel averaging. 
//  wavelength = new float[xDataSize];
  wavelength = new float[3646];
  float f =0;
for (int h = 0; h<3646; h++){
  f = sin(PI*h/3646);
   // wavelength[h] = ABC[0]+h*ABC[1]+ABC[2]*f;
   wavelength[h] = ABC[0]+(ABC[1]*h)+(ABC[2]*f);
    }
    println("calculated xMax: "+xMax[0]);
    for(int h = 0; h<3; h++){
//    xMin[h] = 0;
 //   xMax[h] = 3660;
    xMin[h] = wavelength[0];
    xMax[h] = wavelength[3645];
    xLimBase[0] = wavelength[0];
    xLimBase[1] = wavelength[3633];
}
    println("calculated xMax: "+xMax[0]+", "+xMax[1]+", "+xMax[2]);
}
catch(Exception e){
  println("baseline calc fuddkup");
}}

void newXVals(){
 /* 
  xData = new float[wavelength.length];
  for(int p = 0; p<xData.length; p++){
    
    xData[p] = 0;
    for(int j = 0; j< pixAv; j++){
      xData[p] += wavelength[p*pixAv+j];
      }
    xData[p] = xData[p]/pixAv;
  }
  oldAv = pixAv;
  xDataAvail = true;
  */
//  println("new x data available");
}


void getYLims(){
  println("in getYLims method");
//  yMin[iView] = 0;
//  yMax[iView] = 0;
  for(int a = 0; a<3; a++){
    yMin[a] = 0;
    yMax[a] = 0;
  }
  for(int r = 0; r<spectra; r++){
    if(selectBox[r]){
      if(yMinRaw[r]<yMin[0]){  // calc raw limits
       yMin[0] = yMinRaw[r];
      }
      if(yMaxRaw[r]>yMax[0]){
       yMax[0] = yMaxRaw[r];
      }
      if(yMinCalc[r]<yMin[1]){  // calc Abs limits
       yMin[1] = yMinCalc[r];
      }
      if(yMaxCalc[r]>yMax[1]){
       yMax[1] = yMaxCalc[r];
      }
      if(yMinProc[r]<yMin[2]){  // calc proc limits
       yMin[2] = yMinProc[r];
      }
      if(yMaxProc[r]>yMax[2]){
       yMax[2] = yMaxProc[r];
      }
      
    } // end of selectBox loop
  } // end of r loop
  
/*  if (iView == 1){  // absorbance
     for(int r = 0; r<spectra; r++){
   if(selectBox[r] == true){
   if(yMinCalc[r]<yMin[1]){
    yMin[1] = yMinCalc[r];
  }
    if(yMaxCalc[r]>yMax[1]){
    yMax[1] = yMaxCalc[r];
  }
 }
 }
  }  // end of iView = 1
  
//  if(iView == 0){
 //   int a = 0;
 else {
 for(int r = 0; r<spectra; r++){
   if(selectBox[r] == true){
   if(yMinRaw[r]<yMin[0]){
    yMin[0] = yMinRaw[r];
  }
    if(yMaxRaw[r]>yMax[0]){
    yMax[0] = yMaxRaw[r];
  }
 }
 }
 println("spectra: "+spectra+", view value: "+iView+", y maximum: "+yMax[iView]);
  }   */
println("spectra: "+spectra+", view value: "+iView+", y maximum: "+yMax[iView]+", x maximum: "+xMax[iView]);
}
/*  // reset X vals not used.
void resetXVals(int n){  // reset x values for GPointsArray[n]  // 09/03/2019
 GPointsArray array1 = RawSpecList.get(n);
int j = array1.getNPoints();    // find the number of pixels
}
*/
