/***************************************
*  Process data tab,  Wheetrometer_823
*   Copied from WheeTrometer_Teensy1_1
*   Work on 8/9/2023 on laptop in hospital (Patsy knee replacement)
*     source file lost!
      buttons copied from WheeTrometer_2020 sketch
      working methods: 
        ref()  - set reference spectrum
        dark - set dark spectrum
      Plan to do smoothing and constant subtraction on raw data prior to abs calc
      need methods for
        convert()
        trim()
        smooth()
****************************************/

void setupProcess(){
 // int loadX = 260;
  int deltaX = 60;
  int viewX = 400;
   int buttonC = #E3CA85;
  
  cp5Process = new ControlP5(this);   // view processing options
  cp5Pick = new ControlP5(this);      // button used to  pick background and refference scans
  cp5Convert = new ControlP5(this);   // button that launches conversion to abs
  cp5ExpSetup = new ControlP5(this);  // button that allows customization of conversion parameters
//  cp5Params = new ControlP5(this); 
  cp5Custom = new ControlP5(this);     // buttons and textfields for modifying parameters

   cp5Custom.addButton("smoothButton")
    .setColorBackground(buttonC)//#FFFEFC 
        .setColorCaptionLabel(#030302) //#030302
          .setColorForeground(buttonC)  
          .setPosition(viewX+0, 100)
            .setSize(50, 18)
                .setLabel("smooth")
                  .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)  
                    ;
 cp5Custom.addButton("backSubtract")
    .setColorBackground(buttonC)//#FFFEFC 
        .setColorCaptionLabel(#030302) //#030302
          .setColorForeground(buttonC)  
          .setPosition(viewX+0, 120)
            .setSize(50, 18)
                .setLabel("bkgnd")
                  .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)  
                    ;
  cp5Custom.addButton("zeroAbs")
    .setColorBackground(buttonC)//#FFFEFC 
        .setColorCaptionLabel(#030302) //#030302
          .setColorForeground(buttonC)  
          .setPosition(viewX+0, 140)
            .setSize(50, 18)
                .setLabel("Z-abs")
                  .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)  
                    ;
  zAbs = cp5Custom.addTextfield("zAbs")
    .setColor(#030302) 
      .setColorBackground(#CEC6C6)//(#FFFEFC) 
        .setColorForeground(#AA8A16) 
          .setPosition(580, 140)               // new
            .setSize(28, 16)
              .setFont(font)
              .setLabel("")
       //         .setFocus(false)               
                    .setText(sZeroAbs);
 tSmooth = cp5Custom.addTextfield("tSmooth")
    .setColor(#030302) 
      .setColorBackground(#CEC6C6)//(#FFFEFC) 
        .setColorForeground(#AA8A16) 
          .setPosition(580, 100)               // new
            .setSize(28, 16)
              .setFont(font)
              .setLabel("")
       //         .setFocus(false)               
                    .setText(sPixAv);
                    
 cp5Custom.addButton("xTrim")
    .setColorBackground(buttonC)//#FFFEFC 
        .setColorCaptionLabel(#030302) //#030302
          .setColorForeground(buttonC)  
          .setPosition(viewX+0, 160)
            .setSize(50, 18)
                .setLabel("trim")
                  .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)  
                    ;
 min = cp5Custom.addTextfield("min")
    .setColor(#030302) 
      .setColorBackground(#CEC6C6)//(#FFFEFC) 
        .setColorForeground(#AA8A16) 
          .setPosition(610, 180)               // new
            .setSize(35, 16)
              .setFont(font)
              .setLabel("")
       //         .setFocus(false)               
                    .setText(sTrim[0]);
   max = cp5Custom.addTextfield("max")
    .setColor(#030302) 
      .setColorBackground(#CEC6C6)//(#FFFEFC) 
        .setColorForeground(#AA8A16) 
          .setPosition(610, 200)               // new
            .setSize(35, 16)
              .setFont(font)
              .setLabel("")
       //         .setFocus(false)               
                    .setText(sTrim[1]);
                    
  cp5Custom.addButton("pSave")
    .setColorBackground(buttonC)//#FFFEFC 
        .setColorCaptionLabel(#030302) //#030302
          .setColorForeground(buttonC)  
          .setPosition(viewX+0, 220)
            .setSize(50, 18)
                .setLabel("save")
                  .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)  
                    ;
  
   cp5Process.addButton("next")
    .setColorBackground(buttonC)//#FFFEFC 
        .setColorCaptionLabel(#030302) //#030302
          .setColorForeground(buttonC)  
          .setPosition(viewX+220, 40)
            .setSize(30, 18)
                .setLabel("next")
                  .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)  
                    ;
                    
   cp5Pick.addButton("pickSpec")
   .setColorBackground(buttonC)//#FFFEFC 
        .setColorCaptionLabel(#030302) //#030302
          .setColorForeground(buttonC)  
          .setPosition(viewX-20, 65)
            .setSize(30, 18)
                .setLabel("pick")
                 .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)  
                    ;
  
       cp5Convert.addButton("convert")
    .setColorBackground(buttonC)//#FFFEFC 
        .setColorCaptionLabel(#030302) //#030302
          .setColorForeground(buttonC)  
          .setPosition(2*deltaX+viewX, 95)
            .setSize(50, 20)
                .setLabel("convert")
                  .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)  //.setLabel("Start_Run")
                    ;
                    
    cp5ExpSetup.addButton("custom")
     .setColorBackground(buttonC)//#FFFEFC 
        .setColorCaptionLabel(#030302) //#030302
          .setColorForeground(buttonC)  
          .setPosition(viewX, 65)
            .setSize(20, 20)
                .setLabel("-")
                  .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)  //.setLabel("Start_Run")
                    ;               
  
}

void processAbs(){       // determines whether process buttons viewed
  bProcess =! bProcess;  
iProcTxt = 0;
 }
 
 void next(){   // show next processing screen
 iProcTxt ++;  
 iProcTxt = iProcTxt%3;
 }
 
 void pickSpec(){
 if(iProcTxt == 0){  // pick background scan
 dark();
 } else if(iProcTxt == 1){ // pick reference scan
 ref();
 } else{}
 iProcTxt++;         // increment screen
 }
 
 void custom(){
   iCustom ++;
   iCustom = iCustom%2;
   if(iCustom == 1) iProcTxt = 3;
   else iProcTxt = 2;
     
 }
 
 void xTrim(){   // button method for changing trimFlag, sets x min and max for trim
   trimFlag =! trimFlag;
   println("trimFlag "+trimFlag);
   if(trimFlag){

 /******************************************************************************
 *  Find wavelengths and pixel numbers
 *    Only needs to happen once unless min or max changed
 **************************************************************************/

   xMin[1] = float(cp5Custom.get(Textfield.class, "min").getText());
   xMax[1] = float(cp5Custom.get(Textfield.class, "max").getText());

    pixLimit[0] = findPixel(int(xMin[1]))-1;
    pixLimit[1] = findPixel(int(xMax[1]));
    
    xMin[2] = xMin[1];
    xMax[2] = xMax[1];
    
     
    println("Minimum wavelength: "+xMin[1]+" at pixel "+pixLimit[0]);
    println("Maximum wavelength: "+xMax[1]+" at pixel "+pixLimit[1]);

  //  }
  }  // end of if trimFlag loop
}

 void zeroAbs(){  // button labled z-abs
   bZAbs =! bZAbs;
 }
 
 void setZeroAbs(int spec){
   /*************************************************
   *  method subtracts minimum value from absorbance data
   **************************************************/   
     float fMin, value;
   println("zeroing absorbance: "+bZAbs);
  // for(int h = 0; h<spectra; h++){  // for each spectrum
   fMin = yMinCalc[spec];              // I think this is correct but it might be yMinProc[h]
   GPointsArray array = AbsList.get(spec);
   int pts = array.getNPoints();
   for(int j = 0; j<pts; j++){
     value = array.getY(j);
     value -= fMin;
     array.setY(j,value);
   }  // end of j loop
   yMinProc[spec] = 0;      // min value of abs should be zero at this point
          // set boolean to indicate spectrum zero'd
//   }  // end of h loop
   }  // end of if zero absorbance method
 
void ref(){  // set reference scan

  ref_scan = select();
  if(ref_scan > 20){  //|| ref_scan == 0){
  errorFlag = true;
  iError = 1;
  } else {

    selectSpec[ref_scan] = false;
    refFlag = true;
    processFlag = false;
    // set refArray
     // refArray = RawSpecList.get(ref_scan); // does this work?
      println("reference scan: "+ref_scan);
}
}  // end of ref

void dark(){  // set dark scan

bkground_scan = select();
if(bkground_scan > 20){  //||bkground_scan == 0){
errorFlag = true;
iError = 6;
}else {
  println("background scan: "+bkground_scan);
  selectSpec[bkground_scan] = false;  // is this screwing  us up?
  // set backArray
  backFlag = true;
}
}  // end of dark

int select(){
 boolean gotOne = false;
 int specNo = 0;
 for (int i = 0; i<spectra; i++){
  if(selectSpec[i] == true){
  specNo = i;
  gotOne = true;
  }
 }
 if(gotOne == false){
   println("no spectrum selected"); 
  }
 return specNo;
}  // end of select

void convert(){   // convert button method
  yMin[1] = 0;
  yMax[1] = 0;
  viewVal = 1;    // Absorbance data
  iView = 1;  // display absorbance
//  if(trimFlag) trim();
  println("convert data");
    if(spectra == 0){
    println("no spectra to process");  // should show error flag / message
  } else if (refFlag == false){        // no reference spectrum selected
    errorFlag = true;
    iError = 1;
  } 
  
  
  else {
//   if(processFlag == false){          // if spectra have not been processed previously
    for(int g = 0; g< spectra; g++){                  // for each spectrum
    
/**************************************
*  fill ProcIntList 
*    smooth data
*    and do background subtraction
*************************************/
  smooth(g); 
    }  // need to smooth all data sets before processing or else there is nothing in ref
    for(int j = 0; j< spectra; j++){ 
  if(j != bkground_scan && j != ref_scan){
 try{  
    process(j);
      noProcSpec++;
      println("processed scan "+j);
    } catch (Exception e){
      println("problem in process "+j);
    }  // end of try / catch
  }     // end of what to do if scan is neither backgound or ref
    }  // end of j loop

//    }  // end of if processFlag false
    println("Absorbance min: "+yMin[1]+", Abs max: "+yMax[1]);
  processFlag = true;
} 
/************************************************
*   set y limits for abs and processed data
*      TODO: make this its own method, check for selectBox
*************************************************/
yMin[2] = 100000;
yMax[2] = 0;
yMin[1] = 100000;
yMax[1] = 0;
for(int b = 0; b< spectra; b++){
  if(yMinProc[b] < yMin[2]) yMin[2] = yMinProc[b];
  if(yMaxProc[b] > yMax[2]) yMax[2] = yMaxProc[b];
  if(yMinCalc[b] < yMin[1]) yMin[1] = yMinCalc[b];
  if(yMaxCalc[b] > yMax[1]) yMax[1] = yMaxCalc[b];
}
 bProcess = false;   // quit displaying processing buttons
}  // end of convert



void process(int spec){   // do data processing for abs spectra
println("processing spectrum "+spec);   // gets to here 

  float calcVal = 0;
  float refVal = 0;
  float backVal = 0;
  
//  float xVal = 0;
  yMinCalc[spec] = 100000;
  yMaxCalc[spec] = 0;

    println("load array "+spec);
    
    GPointsArray array2 = ProcIntList.get(spec); 
    GPointsArray refArray = ProcIntList.get(ref_scan);
    GPointsArray output = AbsList.get(spec);
   
//    println("absorbance list loaded");
   
    if(backFlag == true){
  try{
     GPointsArray backArray = ProcIntList.get(bkground_scan);   // get background array
    }catch (Exception e){
     println("problem getting dark scan: "+bkground_scan); 
    }
    }  
    
 // if background scan selected, do background subtraction
 int size = array2.getNPoints();
 int refSize = refArray.getNPoints();
 println("array size "+size+", ref array size "+refSize);
 

 for(int h = 0; h<size; h++){

try{
      calcVal = array2.getY(h);
} catch(Exception e){
 println("problem getting calcVal");
}
   try{
   refVal = refArray.getY(h);    
   } catch(Exception e){
     println("problem retrieving refVal");
   }
   
   try{
      backVal = backArray.getY(h);
    } catch (Exception e){
//      println("problem getting backVal");
    }
//   backVal = backArray.getY(h);
  
 if(backFlag == true){  // && spec!= bkground_scan){
//   println("subtracting scan "+bkground_scan);  // gets to here
   try{
     GPointsArray backArray = ProcIntList.get(bkground_scan);   // get background array
     float f = backArray.getY(h);
   
   calcVal = calcVal-f;
   refVal = refVal-f;
   if(calcVal <= 0){
     calcVal = 0.0001;
   }
   } catch (Exception e){
     println("problem in backArray");
   }
/*   if(h==100){
     println("for 100th pix, calcVal = "+calcVal);
   }  */
 }  // end of backflag is true
 

 
 ///////// calculate Abs /////////
 try{
   if(calcVal == 0) calcVal = 0.001;
   if(calcVal > refVal) {
     calcVal = 0;
   } else {
 calcVal = refVal/calcVal;
 calcVal = log(calcVal);
 float b = log(10);
 calcVal /= b;  
 if(calcVal > 3) calcVal = 3;  // truncate large values
 }
/* if(h%100 == 0){
  println("Abs at pixel "+h+": "+ calcVal); 
 }  */
 } catch(Exception e){
  println("problem in calculation of absorbance"); 
 }
// calcVal = 1;
   
 /////////////////////////////////
 yLimitCheck(calcVal,spec);   
   output.add(array2.getX(h),calcVal);   // dont add
}  // end of h
// }  // end of else (scan not ref or background
if(bZAbs){ setZeroAbs(spec); }   // if the zero absorbance flag is true, subtract minimum value
}  // end of process() method

void yLimitCheck(float calcVal, int spec){
   if (calcVal > yMaxCalc[spec]){          // check if calcVal is above current max 
   yMaxCalc[spec] = calcVal;
 }
 if (calcVal < yMin[1]){
   yMinCalc[spec] = calcVal;
 }
/*    if (calcVal > yMaxCalc[spec]){   // check if calcVal is max for this spec
   yMaxCalc[spec] = calcVal;
 }
 if (calcVal < yMinCalc[spec]){
   yMinCalc[spec] = calcVal;
 }  */
  
}  // end of yLimitCheck

  /*****************************************
  *   data averaging by pixAv
  *     creates Absorbance list data
  *****************************************/
  void smooth(int j){
    GPointsArray data = RawSpecList.get(j);
    GPointsArray output = ProcIntList.get(j);
    int size = data.getNPoints();
    int start;
    int finish;
    float value;
    float subVal;
    int s = pixAv/2;
    float minVal =100000;
    float maxVal = 0;
    
    if(bSmooth){
    for (int i = 0; i<size; i++){  // for each  data point
      
      /****************************************************
      *   determine where to start and finish averaging
      ****************************************************/
    if(i<s){   // initial points
    start = 0;
    finish = i+s;
    } else if (i>s-1 && i< size -s){  // most points
      start = i - s;
      finish = i+s;
    } else {                          // last points
      start = i-s;
      finish = size;
    }
    
    value = 0;
    for(int k = start; k<finish; k++){
      value += data.getY(k);
    }
    value /= (finish - start);
    output.add(data.getX(i),value);
   
    }  // end of for each data point
    }   // end of bSmooth loop
    
   
   
    /****************************************
    *   if not smoothing, copy data file to output file
    *******************************************/
    else {   //   if not smoothing,
      for (int h = 0; h<size; h++){
        output.add(data.getX(h),data.getY(h));  // put data into output
      }   // end of h
    }     // end of if not smoothing
    
       
    if(bSubtract){
    /********************************************************
    * find min and max y values and do subtraction of min
    *   if trimFlag set, only consider values between pixLimits
    ********************************************************/
    int begin = 0;
    int end = size;
    if(trimFlag){
     begin = pixLimit[0];
     end = pixLimit[1];
    }
    for (int z = begin; z< end; z++){
      value = output.getY(z);
    if(value < minVal && z > 10) {
      minVal = value;
    }
    if(value > maxVal && z > 10){
      maxVal = value;
    }
    }
     println("minimum value: "+minVal);
     for( int y = 0; y<size; y++){
       subVal = output.getY(y);
       subVal -= minVal;
       output.setY(y,subVal);
     }
     maxVal -= minVal;
     minVal = 0;
    }
    
    
    
    int u = output.getNPoints();
    println("data set "+j+", "+u+" points");
    if(trimFlag) println("trimmed data: "+(pixLimit[1]-pixLimit[0])+"points");
    
    
    yMinProc[j] = minVal;
    yMaxProc[j] = maxVal;
    if(yMin[2] > minVal) yMin[2] = minVal;
    if(yMax[2] < maxVal) yMax[2] = maxVal;
  } // end of smooth method
  
/********************
note: set button, min and max textfields removed
**********************/
void set(){
 println("setting x lims");
 String s0 = cp5.get(Textfield.class, "min").getText();
 String s1 = cp5.get(Textfield.class,"max").getText();
// textBoxInfo[5] = s0;
// textBoxInfo[6] = s1;
 float f0 = float(s0);
 float f1 = float(s1);
 println("x min: "+f0+", x Max: "+f1);
 for (int h = 0; h<4; h++){
   xMin[h] = f0;
   xMax[h] = f1;
 }
}

public void pSave(){
  selectOutput("Select a file:", "saveParams");
}

public void saveParams(File selection){
   file2 = selection.getAbsolutePath();
  String[] params = new String[7];
  params[0] = file2;
  params[1] = String.valueOf(ABC[0]) +"," + String.valueOf(ABC[1]) +","+ String.valueOf(ABC[2]) +", baseline parameters";
  params[2] = String.valueOf(msInt) +", ms integration time";
  params[3] = String.valueOf(sPixAv) + ","+ String.valueOf(bSmooth)+", pixels to average";
  params[4] = String.valueOf(backFlag)+", subtract background";
  params[5] = sZeroAbs +","+ String.valueOf(bZAbs)+", zero absorbance at wavelength";
  params[6] = String.valueOf(sTrim[0])+","+ String.valueOf(sTrim[1])+ String.valueOf(trimFlag)+", x limits (nm)";

saveStrings(file2,params); 
}
