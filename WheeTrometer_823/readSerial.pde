// readSerial tab in WheeTrometer_Teensy1 sketch
// methods: serialEvent
//      convertData  puts data in rawData file
//  signals from spectrometer:
//         $ - parameters recieved
//         % - end of data packet
//         ! - end of spectrum
//         DatEr - data read error
//  Signal to spectrometer:
//         # - data packet recieved, ready for more


void serialEvent(Serial p) {

  if (Comselected == false) {
  } else {  // if comSelected is true
    
    buffer = null;
    buffer = p.readStringUntil(LINE_FEED);
    if (buffer == null) {}
    else{
      /////// look for special characters ///////////////////////////////////
   //   int j = buffer.indexOf("$");      // parameters recieved by ucontroller
      int k = buffer.indexOf("!!!");      // end signal  was !
      int y = buffer.indexOf("B");        // signals baseline values in line
      int x = buffer.indexOf('/');      // comment from firmware

      if (k!=-1) {
        running = false;
//        reading = false; // need to move this to end of calculation?
        println("! signal received");
        strData[counter] = buffer;
        println("end string "+counter+": "+buffer);
        convertData();
      } 
      else if((y!= -1)&&(gotABC == false)){  // get baseline values
       println("getting baseline values");
    try{
    String[] tokenABC = split(buffer,",");
    ABC[0] = float(tokenABC[0].substring(1,7));
    ABC[1] = float(tokenABC[1]);
    ABC[2] = float(tokenABC[2]);
    gotABC = true;
    println(" got baseline values: "+ABC[0]+", "+ABC[1]+", "+ABC[2] );
      wavelengthCalc();  // method in  graph data tab,
      newXVals();
    }
    catch(Exception e){
    println("  problem reading ABC values");
    gotABC = false;
    }
      }

      else if (x!=-1) { }     // dont do anything if it is a comment
      
   /*********************************************
    *  Collect spectral data
    ***************************************/

      else if (running == true) {
       strData[counter] = buffer;
        counter++;
        
      } else {        // if running is false
      println("buffer: "+buffer);

      }
      }  // end of if buffer not null loop
    } // end of com selected is true loop
  } // end of serial event
  
/***********************************************
*  Convert data from strings
*   and put data into GPoints array
*********************************************/
  void  convertData(){
    println("in convert data");
    boolean yMinSet = false;
    println("line 103");
    //yMin[spectra -1] = 0.0;
    
    println("line 105");
   // yMax[spectra -1] = 0.0;
    /************************************
    *  Generate new arrays if necessary
    *************************************/
/*    overWriteData = false;
    if(iMode == 0 && firstSpectrum == false) {overWriteData = true;}
  
 if(overWriteData == false){      // problem: if we mode is one shot and we already have data, then we need to remove original data
    RawSpecList.add(new GPointsArray());
    ProcIntList.add(new GPointsArray());
    AbsList.add(new GPointsArray()); 
    println("new arrays added to lists");
  }  */
  println("just before get array");
    GPointsArray rawArray = RawSpecList.get(spectra-1);
 println("after get array");
    pixelNo = 0;
    println("in convertData loop");
    println("data strings: "+counter);
    
    for (int h = 1; h<=counter-5; h++) {  // for each pixel loop 
    
    /************************************************
    *  check for end of data signal 
    ************************************************/
 //     char check;
      int value0 = 0;
 //      check = strData[h].charAt(0);

        try {
          // split into strings at ','
          String[] tokenDat = split(strData[h], ",");
          value0 = Integer.parseInt(trim(tokenDat[1]));    // first intensity value
          
          if(yMinSet == false && value0>0){
            yMinRaw[spectra-1] = value0;
            yMaxRaw[spectra-1] = value0;  // added 7/20/2023
            yMinSet = true;
            println("yMinRaw set: "+value0);
          }
         }
        catch(Exception e) {
          println("problem parsing data at line "+h);
          println("string in question: "+strData[h]);
        }
 //     }   // end of else from line 93
//  adjust Y min and max 

      if (value0<yMinRaw[spectra-1]) {
        yMinRaw[spectra-1] = float(value0);
      }
      if (value0>yMaxRaw[spectra-1]) {
        yMaxRaw[spectra-1] = float(value0);
      }
      
      pixelNo++;
      if(pixelNo%100 ==0){
      println("pixel: "+pixelNo+", wavelength: "+wavelength[pixelNo]+", value: "+value0);
      }
      rawArray.add(wavelength[pixelNo], value0);   // adding data
    }  // end of for each pixel loop


println("reading set false, newData true");
newData = true;
 reading = false; 
}  // end of convert data, began line 99





void setMin(int j){
 // if(subConst[j] == false){  // moved to MinSub method
 //   if(ProcessBox[0] == false){         // if data not already smoothed
  GPointsArray array = RawSpecList.get(j);
     
  GPointsArray array2 = ProcIntList.get(j);
  float value = 0;
  float xVal = 0;
  int size = array.getNPoints();
  float min = yMinRaw[j];
  yMinProc[j] = 0;
  yMaxProc[j] = yMaxRaw[j] - min;
  if(yMax[2]<yMaxProc[j]) { yMax[2]=yMaxProc[j]; }
  yMin[2] = 0;
  
  if(ProcessBox[0]){
  for(int p = 0; p<size; p++){
    value = array2.getY(p)-min;
//  xVal = array.getX(p);
    array2.setY(p, value);
  }
  } else {
  println("subtracting "+min+" from spectrum "+j);
  for(int p = 0; p<size; p++){  
    value = array.getY(p)-min;
    xVal = array.getX(p);
    if(ProcessBox[0]){
    array2.setY(p,value);
    } else {
    array2.add(xVal, value);   // add data
    }
  }
  }
  subConst[j] = true;
 // }
  println("data subtraction for intensity on spectrum "+j+" complete");
  println("iView value: "+iView);
}
