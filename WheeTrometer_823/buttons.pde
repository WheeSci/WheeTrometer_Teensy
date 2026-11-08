/* buttons tab, WheeTrometer_Teensy1
  contains code for the following methods:
     start run
     clearArray- removes data from array
     pick - picks the largest y value in view, returns x 
     specSel
*/




public void Start_Run() {  // start run 
// if mode is one shot, set subConst[] false; 

 overWriteData = false;
    if(iMode == 0 && firstSpectrum == false) {overWriteData = true;}
  
 if(overWriteData == false){      // problem: if we mode is one shot and we already have data, then we need to remove original data
    RawSpecList.add(new GPointsArray());
    ProcIntList.add(new GPointsArray());
    AbsList.add(new GPointsArray()); 
    println("new arrays added to lists");
  }
if(iMode == 0){
  subConst[0] = false;
  yMaxRaw[0] = 0;
}
if(spectra == 0){  // set y min, max to zero
for (int p = 0; p<3; p++){
  yMin[p] = 0;
  yMax[p] = 0;
}
}
  if(spectra == 20){
    iError = 2;  // error message
    errorFlag = true;
  }else{
    if(Comselected){
    reading = true;
//  startRun = true;             // starts actual run
  dataCounter = 0;             // reset data counter
  counter = 0;                 // strings of data recieved from u-cont.
  if(iMode !=0 || spectra == 0){
    
  spectra++;
  subConst[spectra] = false;
  headers[spectra] = cp5.get(Textfield.class, "fileName").getText()+spectra;  // need file name
  println("spectra: "+spectra);
  selectBox[spectra-1] = true;  // not sure about the -1
  //RawSpecList.add(new GPointsArray());  // repeated in readSerial tab, convert data method
  yMinRaw[spectra-1] = 0;
  yMaxRaw[spectra-1] = 0;

  }else{   // if iMode is zero, need to clear arrAy
  clearArray(0, false);
    }
    // text below moved from main tab, Mar 20, 2022 //
    // startRun boolean removed
    counter =0;
    running = true;
    println("running flag set");
    // below copied from calibration sketch
 // stTime = cp5ExpSetup.get(Textfield.class, "Integration_Time").getText();
   stTime = cp5.get(Textfield.class, "Integration_Time").getText();
  int iIntTime = round(float(stTime)*1000);
  IntTime = nf(iIntTime, 6);   // make ScanR have 3 digits. pad with zero if no digits
  String commands = "I"+IntTime+"&";
  running = true;
  
   serialPort.write(commands);
   println("running flag set");
   println("commands: "+commands);
  }
else{
println("Connected?");
}  
  }  
}


void clearArray(int y, boolean move){
  GPointsArray array = RawSpecList.get(y);
  int a = array.getNPoints(); //1000;
  array.removeRange(0,a);
  if(move == true){
    try{
  for(int g = y; g<spectra-1; g++){ // move down one number
   GPointsArray array1 = RawSpecList.get(g);
   GPointsArray array2 = RawSpecList.get(g+1);
   array1.add(array2);
   array2.removeRange(0,a);
   if(processFlag == true){
    GPointsArray array3 = AbsList.get(g);
    GPointsArray array4 = AbsList.get(g+1);
    array3.removeRange(0,a);
    array3.add(array4);
    array4.removeRange(0,a);
   }
   subConst[g] = subConst[g+1];  // has raw spectrum been background subtracted
   yMinRaw[g] = yMinRaw[g+1];
   yMaxRaw[g] = yMaxRaw[g+1];
   yMinCalc[g] = yMinCalc[g+1];
   yMaxCalc[g] = yMaxCalc[g+1];
   sFileName[g] = sFileName[g+1];
   headers[g] = headers[g+1];
   cHeader[g] = cHeader[g+1];
   selectBox[g] = selectBox[g+1];
   selectSpec[g] = selectSpec[g+1];
  }
  spectra--;
    } catch(Exception e){
    println("problem moving spectra");
  }
  }
}

void peak_pick(){
  if(spectra == 0){
    errorFlag = true;
    iError =4;
  }else{             // we have spectra

  if(errorFlag == false){    // still in baseline, if only one peak selected
 int j = 0;
   println("before pic method, line 135");
 j= pick();
}
  }
}  // end of peak_pick routine

int pick(){  // pick largest y value in zoom and return x position
//println("line 145, pick method");
GPointsArray array = RawSpecList.get(0);
int min=0;  // pixel numbers
int n = array.getNPoints();   // number of data

int max = n;
int peakPix = 0;
float peakWavelength = 0;
float thisYVal = 0;
float peakYVal = 0;

// deal with error of no spectra recorded
if(spectra == 0){
  errorFlag = true;
  iError = 4;
}
if(errorFlag == true){
  println("errorFlag");
}
// if there is a spectrum recorded do this
else{
//  println("no error flag");
try{

println("in pick routine");
if(zoomed == true){      //  note: wavelengths are linear in x, not pixels
// find pixel associated with xMin[3] & xMax[3];
println("min nm: "+xMin[3]);
  min = findPixel(xMin[3])-1;  //int(fBox[0]*n);  // n is the no of pixels?
  max = findPixel(xMax[3]);  //int(fBox[2]*n);
}
println("pixel range: "+min+", "+max);     
float a = array.getX(min);
float b = array.getX(max);      // this gives wrong answer, falue from xData[]
println("wavelength range: "+a+", "+b);
   
println("array got, line 123");
for(int x = min;x<max; x++){
  thisYVal = array.getY(x);
  if(thisYVal> peakYVal){
   peakPix = x;
   peakYVal = thisYVal;
   
   peakWavelength = array.getX(x);
  
  }
}
println("peak at "+peakWavelength+": pixel "+peakPix); 
}
catch(Exception e){
  println("exception in pick routine");
}
}
return peakPix;
}

/* void flameClr(){
 println("flame clear button pressed");
 }
 
 void flameNxt(){
  println("flame next"); 
 }  */
 
 void specSel(){
  expNo++;
  expNo = expNo%4;
  println("Experiment number "+expNo);
  bckgnd = backColor[expNo];
  setupSpec();
set();  // sets xMin and xMax
setAxes();  // in charts Setup tab, sets up x axes
wavelengthCalc();  // calculates wavelengths for x axis

 }
 
 void cursor(){
  viewCursor =!viewCursor;
  println("cursor view: "+viewCursor);
 }
 
 void addExp(){
   String newParams;
   if(Comselected == false){
     newParams = cp5Name.get(Textfield.class, "name").getText();
   } else {
     newParams = serialNo;
   }
  params(); 
  String expName = cp5Spec.get(Textfield.class,"ExpName").getText();
  newParams = newParams+","+expName+","+stTime+","+sLoops+","+sAvg+","+stMin+","+stMax;
  String[] paramFile = loadStrings("Setup.txt");
  paramFile = append(paramFile,newParams);
  String a = dataPath("Setup")+".txt";
  println(a);
  saveStrings(a, paramFile);
  println("parameters saved");
 }
 
 
