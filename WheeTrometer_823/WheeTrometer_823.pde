
//WheeTrometer_Teensy1
// version on basement computer
// gets serial number and baseline data from u controller  
//  use WheeTeensy_Calibration interface to put calibration data into EEPROM
//
// need to deal with comparing number of data points for saved and scanned spectra.
// loading saved spectra with different number of pixels will not work.
// 
// July 9, 2019- read setup values from setupData.txt file
//    wavelength values calculated from second order polynomial using
//      constants read from setupData file
//    increment values for least squares refinement taken from file as well
//    Default values for integration time, loops and data averaging in there too.


/////////////////////////////////////// Imports/////////////////////////////////
/*import java.awt.Toolkit;
import java.awt.GraphicsEnvironment;
import java.awt.GraphicsDevice;
import java.awt.DisplayMode;
import java.awt.*; */
import java.util.*;
//import java.util.Arrays;
//import java.io.*;                    // for file stuff
import grafica.*;                    // For chart classes.
import grafica.GPlot;
import controlP5.*;                  // for buttons and txt boxes
import processing.serial.*;          // for serial
//import PFrame.*;      // for extra windows

  boolean disconnect = true;
  boolean gotABC = false;
  int pixLimit[] = {0,3694};  // pixels to limit trim
  boolean[] ProcessBox = new boolean[6];  // 0 is smooth
  boolean bSmooth = true;
  boolean bSubtract = true;
   boolean bZAbs = false;  // are we zeroing the absorbance at some wavelength?
 
/// are these used?  //
    boolean subConst[] = new boolean[20];  // has data had minimum value subtracted? 
    boolean smoothData[] = new boolean[20]; // has data been smoothed?
    boolean AbsBox[] = new boolean[20];     // has absorbance data been calculated?

 // boolean gotABC[] = {false,false,false};
//  String[] expName = {"experiment 0","experiment 1","experiment 2","experiment 3"};
//  String[] paramFile = new String[];
  int expNo; // experiment number
  String serialNoTxt;
  String stMin;
  String stMax;
  String stTime;
  boolean bProcess = false;      // determines whether to display process buttons
//  boolean absAvailable = false;  // has conversion method been run?
  int noProcSpec = 0;   // number of processed spectra
  
// new stuff for multiple spectrometer options
  //String[] sSpecName = new String[0]; //{"Wheetrometer 1","Flame","Whee-UV","Whee-Vis"};
  //String ExpName = "exp Name";
//int specs = 0;  // number of specrometers
//int specNo = 0;  // spectrometer number
String serialNo = "";  // serial number read when spectrometer connects in comPort tab
int[] backColor = {#3C88A5,#A52B33,#653274,#895A2C};
String[] sIntTime = {"2","1","0.5","1"};
String[] stLoops = {"1","1","1","1"};
String[] stAvg =  {"1","1","1","1"};
//String[] serNo = new String[0];  // serial no of spectrometers in file
 boolean viewCursor = false;
 //float noise = 200;
 // variables for peak picking
 int xPick;
 int pickDelta = 15;
 int yPick;
 int xCenter;
 int yCenter;
 int linePix = 1000;
float lineWav = 500;
// new stuff 06/09/19 for use in multi-spectra files
String[] headers = new String[20];
int spectra = 0;  // number of spectra
int nSpectra = 0;  // spectra added from file
boolean reading = false;
boolean overWriteData = false;
 GPlot plot, plot1, plot2;
//public GPlot plot, plot1, plot2;   // not sure how many of these are used
GPointsArray data = new GPointsArray(3694);
GPointsArray backArray = new GPointsArray(3694);  // this gets set in controlEvents
GPointsArray refArray = new GPointsArray(3694);
ArrayList<GPointsArray> RawSpecList = new ArrayList<GPointsArray>();
ArrayList<GPointsArray> ProcIntList = new ArrayList<GPointsArray>();
ArrayList<GPointsArray> AbsList = new ArrayList<GPointsArray>();

  //// flags for data processing ////////////////
  boolean newData = false;  // signal to look at min and max Y values
    String processingText[] = {"Select background scan from list", "Select reference scan from list","Select processing parameters","Convert to Absorbance"};
  int iProcTxt = 0;
   String[] sCustom = {"Standard Processing Parameters","Custom Processing Parameters"};
  int iCustom = 0;
  boolean smoothFlag = false;
  int nSmoothPts = 4;
  boolean minSub = false;     // should the y min for each spectrum be subtracted prior to processing?
  boolean trimFlag = true;

float[] yMinRaw = new float[20];
float[] yMaxRaw = new float[20];
float[] yMinProc = new float[20];
float[] yMaxProc = new float[20];
float[] yMinCalc = new float[20];
float[] yMaxCalc = new float[20];

  // params for displaying file names
int specX = 800; 
int specY =100;
int deltaY = 20;
String[] sFileName = new String[20];
String[] cHeader = new String[20]; 
int nPixels;

   // Error stuff
  int iError=0;   // which error message to display
  boolean errorFlag = false;
  boolean refFlag = false; // no reference spectrum
  boolean backFlag = false;  // no background spectrum
  String[] errorTxt = {"","Error: Select one reference spectrum","Error: Too many spectra","Save Error: No spectra selected",
       "Pick error: must record spectrum to pick","Calibrate error: select calibration points", "Error: Select background spectrum",
     "No parameter file present"};

//   Display stuff
int thresh = 1000;  // minimum intensity value for doing calculations
 // String saved = "working on: Absorbance.";  // displayed on lower right of GUI
  int plotWidth;    // position and dimensions of plot calc'ed in setup()
  int plotHeight;
  int plotX = 20;
  int plotY = 80;
int iView = 0;  // 0: intensity, 1: Abs
String[] viewTxt = {"Intensity-0","Absorbance","Processed Intensity","Zoomed Intensity","Zoomed Absorbance"};
int runCount = 0;  // experiment count
int viewVal = 0;  // 0-raw, 1 is processed data, 3 is zoom
int oldViewVal = 0;  // used to return from zoom

boolean[] selectBox = new boolean[20];
boolean[] selectSpec = new boolean[20];
       
int[] red = {  255, 0, 0, 85, 0, 170, 0, 170, 85,
            153,51,51,128,76,51,128,76,51,102,76,76,85}; //color parameters for data
int[] green = {  0, 0, 255, 0, 85, 85, 170, 0, 170, 
            51,153,51,76,51,128,51,128,76,76,102,76,85};
int[] blue = {  0, 255, 0, 170, 170, 0, 85, 85, 0, 
            51,51,153,51,128,76,76,51,128,76,76,102,85};

//   limits for displays
 float[] xMin = {300,400,400,280};      // raw, abs, calc, zoom
 float[] xLimBase = {300, 1000};
  float[] xMax = {4000,900,900,600};
  float[] yMin = {0,0,0,0};
  float[] yMax = {64000,0.1,1,1};
//  boolean xDataAvail = false;  // needed for using data from files
 
//   Calculations stuff
int bkground_scan = 999; // spectrum to use for background 
int ref_scan = 999;      // spectrum for 100% transmitance
boolean selected = false;            // spectrum for setting background or reference
boolean processFlag = false;  // has data been processed to give abs spec? 
    // processFlag set false when reference scan set

float trimXMin;
float trimXMax;
boolean trimmed = false;
boolean firstChart = true;
boolean firstSpectrum = true;

//  Zoom stuff  (should be cleaned up)
float zoomXMax;
float zoomXMin;
float zoomYMax;
float zoomYMin;

int c0 = 90;    //265;  left x value for box
int c1 = 660;   // width of box
int c2 = 495;  // y position of box bottom
int c3 = 374;  // height of box
int deltaXbox = 50;
int deltaXwidth = 100;
int deltaYbox = 50;
int deltaYheight = 100;
float[] limits = new float[4];
int[] xZoom = {c0,c0+c1,c0,c0+c1};
int[] yZoom = {c2,c2-c3,c2,c2-c3};
 int[] xZoomLim = {c0,c0+c1,c0,c0+c1};  //neither box can go below c0 or wider than c1, 
 int[] yZoomLim = {c2,c2-c3,c2,c2-c3};  // y limits for the two boxes
 int[] xBox = {270,670};
 int[] yBox = {473,75};
 float[] fBox = {1.0,1.0,1.0,1.0};
 boolean zoomed = false;
 
 float[] oldChartLim = {0,1,0,1};

//int chartMode;
float[] refScan = new float[3694];     // file to hold reference values
float[] backgrScan = new float[3694];  // file to hold background values

// for mouse tab
  int selVal;
  boolean mouse0 = false;  // is box zero being dragged?
  String selTxt;
  
float chartXMax;
float chartXMin;
float chartYMax;
float chartYMin;

//  new stuff for header file:
int[] iLoops = new int[0];  //{4,4,4,4};  // loops
int[] iAv = new int[0];  //{4,4,4,4};     // 
float[] intTime = new float[0];  //{2,12,2,2};  // integration time
float[] ABC = new float[3];  //{{294.12,0.14952,0},{0,0,0},{0,0,0},{0,0,0}};  //0.5981,-0.00017;  // values for pixel to wavelength calc

//String[] textBoxInfo = {"","","","","","",""};  // integration time, loops, data averaging
 
    String[] AmpVal = {"","","",""};
  String[] Offset = {"","","",""};
//    String[] sMin = "";
  //String[] sMax = "";
  String[] sMin = {"0","0","0","0"};
  String[] sMax = {"0","0","0","0"};
  int pixMin = 0;
  int pixMax = 3646;
  float fNoise = 200;
  
////////////// end of new stuff

  int pixelNo = 0;   // total number of pixels recorded
  int nDataPts = 3688;    // maximum number of data points

ControlP5 cp5,cp5b,cp5c,cp5d, cp5Com, cp5Files, cp5Cal, cp5Cursor, cp5Spec, cp5Name, cp5Process, cp5AbsView,  cp5ExpSetup, cp5Pick, cp5Convert, cp5Custom;

Textfield  integration_Time,  fileName,  min, max, name, noise, tSmooth, zAbs;
        
  // cut textfields: Run_Interval,Number_of_Runs, loops, Average, ExpName, peakLambda, peakPixel, amp, offset,
  
//Toggle ref;
//ControlP5 cp5.Button convert;
/////////// variables for reading data ///////////////////////////////////////////
int dataCounter;
boolean running = false;
boolean dataAcq = false;
boolean graph = false;

String[] wavedata ;   // wavelengths from file
float[] wavelength; //  converted from strings

String buffer; // data read from serial
String[] strData = new String[4000]; 
String[] strParams = new String[10];
int pCount = 0;
//int strCounter = 0;
int counter;  // counter for buffer strings
int LINE_FEED=10; 
//boolean winshow = false;
//boolean overlaydata = false;
//float[] yscale = new float[2];
char[] sMode = {'0','1','2','3'};
String sLoops;
String sAvg;
                    

boolean startRun = false;
String IntTime;
String file2;
int iIntTime;


//////////////font varialbes///////////////////////////////
  PFont font;
  PFont font2;
  PFont font3;
  PFont font4;
  
/////     Information text  ////////
  String[] modeList = {"Absorbance","Transmittance","Series"};
  String comStatTxt = "not connected";
  String[] modeText = {"One shot","Multi-spec","Contin. Acq.","Flame","Series"};

////////////// colors /////////////////
  int bckgnd = #3C88A5;
  int bkgnd = #577193;
  int sel = #E59615;   // color for selected spectra

  /////// serial communications /////////////
  Serial serialPort;
//static
String[] comList ;               //A string to hold the ports in.
String[] comList2;               // string to compare comlist to and update
boolean serialSet;               //A value to test if we have setup the Serial port.
boolean Comselected = false;     //A value to test if you have chosen a port in the list.
boolean pauseFlag = false;

//// controll variables
  int iMode = 0;    // single shot or multiple
  int pixAv = 8;   // number of pixels to average, calc'd in params tab
  int oldAv = 0;  // last value of pixAv
 // float[] xData;

/// button images ////
PImage button0, button1;

String msInt = "";
String sPixAv = "";
String sZeroAbs = "";
String[] sTrim = {"",""};
///////////////////////////////Setup////////////////////////////////////////////////////

void setup(){ 
  size(950, 675); // (800, 700)
  Arrays.fill(subConst, Boolean.FALSE);  // minimum value has not been subtracted from spectra
  Arrays.fill(selectBox, Boolean.FALSE); 
  Arrays.fill(selectSpec, Boolean.FALSE);
  Arrays.fill(smoothData, Boolean.FALSE);
  Arrays.fill(ProcessBox, Boolean.FALSE);
  Arrays.fill(AbsBox, Boolean.FALSE);
  plotWidth = width-290;    // position and dimensions of plot
  plotHeight = height-300;
  
  xCenter = plotWidth/2 + plotX;
  yCenter = plotHeight/2+ plotY+45;
  xPick = xCenter;
  yPick = yCenter;
  xZoom[0] =90;
  xZoom[1] = plotWidth+xZoom[0];

  selectBox[0] = true;       // display first spectrum
  font = createFont("Arial", 16);
    font2 = loadFont("ArialMT-48.vlw");
      font3 = createFont("Arial", 20);
        font4 = createFont("Arial", 16);
        
        button0 = loadImage("button_0.png");
        button1 = loadImage("button_1.png");
// new wavelength data calculation
/*****************************************
*  load standard parameters
*****************************************/
String[] ParamStrings = loadStrings("StandardParameters.txt");
  int lines = ParamStrings.length;
  println("lines in data file: "+lines);
for (int g = 0; g<lines; g++){
println("line "+g+": "+ParamStrings[g]);
}
String[][] tokens = new String[7][4];
for(int r = 1; r<7; r++){
 tokens[r] = ParamStrings[r].split(",");
}
for(int t= 0; t<3; t++){
  ABC[t] = float(tokens[1][t]);
//  println("ABC "+t+": "+ABC[t]);
}

msInt = tokens[2][0];
println("integration time: "+msInt);

sPixAv = tokens[3][0];
bSmooth = boolean(tokens[3][1]);
backFlag = boolean(tokens[4][0]);
sZeroAbs = tokens[5][0];
bZAbs = boolean(tokens[5][1]);
sTrim[0] = tokens[6][0];
sTrim[1] = tokens[6][1];
trimFlag = boolean(tokens[6][2]);
println("trimFlag: "+trimFlag);

 
 wavelengthCalc();  // moved to readSerial tab after params read
 newXVals();
 // surface.setResizable(true);  // not currently used
  setupCharts();
  cp5_controllers_setup();
  setupProcess();
  setupComPort();  // from stopped flow GUI, need to cut older connection code
  connect();
  setupSpec();
  findCursor(); 
//  createXVals();  // just use pixel number
   
}

////////////////////////////Draw/////////////////////////////   

void draw() {

  if(pCount !=0){
    // cut for editing for Teensy code
 //     getParams();  // method in readSerial tab

  }
  try{
    background(bckgnd); 
    fill(0);
   textFont(font,16);
   fill(#080606);
   
   text("SmokyMtSci.com",width-220,height-30);
   if(Comselected == true){
     text(serialNoTxt,250,height -70);
   }
   text("Spectra: "+spectra,specX,specY);
//  show spectra names
   for(int w = 1; w<=spectra; w++){
     if(selectBox[w-1] == true){  // if spectrum color: sel
      fill(sel);
    } else{
      fill(0);
    }
    text(headers[w],specX,specY+(w*deltaY));
    
    if(selectSpec[w-1]== true){
      fill(sel);
    }else{
      noFill();
    }
    if(bProcess == true){
      ellipse(specX+90,specY-5+(w*deltaY),10,10);
    }
  }
fill(0);

// error text
  if(errorFlag == true){
    text(errorTxt[iError],600,26);
  }
  }
 catch(Exception e){
   println(" error before plot");
 }

//   textFont(font,32);

if(reading == false){
  setAxes();  // note: setAxes gives axes legends, does not set limits, in chartsSetup tab
  if(newData){ 
   getYLims();
   newData = false;
  } // get y lims in graph data tab
 
  try{
     plot1.beginDraw();
      plot1.drawBackground();
      plot1.drawBox();
      plot1.drawXAxis();
      plot1.drawYAxis();
      plot1.drawTitle();
       // copied from below
       plot1.setXLim(xMin[iView],xMax[iView]);
          plot1.setYLim(yMin[iView],yMax[iView]);
          plot1.setPos(plotX, plotY);
          plot1.setDim(plotWidth, plotHeight);
          
      plot1.endDraw();
//  getYLims();  // cut 01 / 2020 moved to files
} catch(Exception e){
  println("problem in plot1.beginDraw loop");
}

  int end = spectra;
         for(int h = 0; h< end; h++){
        if(selectBox[h] == true){

        if(iView == 0 || (iView == 3 && oldViewVal ==0)){ // raw data
          GPointsArray array2 = RawSpecList.get(h);
          plot1.setPoints(array2);
          } else if (iView == 1 || (iView == 3 && oldViewVal ==1) && h!= ref_scan && h!= bkground_scan){
          GPointsArray array2 = AbsList.get(h);  
          plot1.setPoints(array2);
          } else if (iView == 2 || (iView == 3 && oldViewVal ==2)){
          GPointsArray array2 = ProcIntList.get(h);  
          plot1.setPoints(array2);
          } 


          if(h==spectra-1){
            plot1.setLineColor(0);   // latest spectrum is black
        //    plot1.drawLines();
          } else {
          plot1.setLineColor(color(red[h],green[h],blue[h],100));
          }
          plot1.beginDraw();
          plot1.drawLines();
          
          plot1.endDraw();
                  }  // end of selectBox[h] loop
      }    // end of h loop 
 }

  textFont(font2,16); 
  text(comStatTxt, 80, 38);  // displays com port state, added May 18
  text(modeText[iMode],90,70);
//// process absorbance data ////
String[] customTxt = {"Pixel Averaging: ","Minus Min Int","Zero Abs at ","Trim wavelengths ","Min nm", "Max nm", "Save as Std Params"};
int cTxtX =460;
int cTxtY = 113;
if(bProcess == true){
  fill(0);
  rect(375,35,300,90);

  if(iProcTxt == 3) {
    rect(375,35,300,210);
      fill(255);
        textSize(16);
    for(int t = 0; t<7; t++){
      text(customTxt[t],cTxtX, cTxtY+20*t);
    }
    fill(0,255,255);
    text(String.valueOf(trimFlag),cTxtX+170,cTxtY+60);
     text(String.valueOf(bSmooth),cTxtX+170,cTxtY);
     text(String.valueOf(bSubtract),cTxtX+170,cTxtY+20);
     text(String.valueOf(bZAbs),cTxtX+170,cTxtY+40);
    
  }
  cp5Process.show();
  int textXVal = 430;
  int textYVal = 80;
  int deltaY = 20;
  fill(255);
  textSize(16);
 

  if(iProcTxt <2) text(processingText[iProcTxt], textXVal, textYVal);
  if(iProcTxt<2){cp5Pick.show();}
  else {cp5Pick.hide();}
  if(iProcTxt>1){
    cp5ExpSetup.show();
//    cp5Convert.show();
  text(sCustom[iCustom],textXVal, textYVal);  
  }
  else {cp5ExpSetup.hide();}
//  cp5Convert.hide();}
  if(iProcTxt == 2) {cp5Convert.show();}
  else { cp5Convert.hide(); }
  if(iProcTxt == 3){
  cp5Custom.show();
  }  else{cp5Custom.hide();}
  
/*  if(iProcTxt==3){cp5Convert.show();}
  else {cp5Convert.hide();}  */
/*  String sText[] = {"smooth data points","subtract min intensity","select background","select reference", "dark noise level","convert to Abs","Process spectra"};
  for(int a = 0; a<7; a++){
  text(sText[a],textXVal, textYVal+a*deltaY);
  }  */
} else {
cp5Process.hide();
cp5Pick.hide();
cp5Convert.hide();
cp5ExpSetup.hide();
cp5Custom.hide();
}
if(noProcSpec != 0){  // could be done with number of converted spec = 0
  cp5AbsView.show();  // if conversion method ran
    text(viewTxt[iView],440,26);
 //   println("line 428");
} else {
  cp5AbsView.hide();
}
if(viewCursor == true){
  cp5Cursor.show();
// pick lines
stroke(0);
int plotLo = 120;
//xPick = 100;
line(xPick,plotLo,xPick, plotLo+plotHeight);
rectMode(CENTER);
noFill();
rect(xPick,yPick,15,15);
//rect(xPick,yPick,2*pickDelta,6*pickDelta);
fill(0);
text(nf(lineWav,0,1)+" nm", xPick,plotY+30);
stroke(255);
//println("line");
} else{
  cp5Cursor.hide();
}
if(Comselected == true){
  cp5Name.hide();
} else {
  cp5Name.show();
}
////////////  zoom box
    if(zoomed == false){
    stroke(0);

  line(xZoom[0],yZoom[0],xZoom[0],yZoom[1]);
  line(xZoom[0],yZoom[0],xZoom[1],yZoom[0]);
  line(xZoom[1],yZoom[1],xZoom[1],yZoom[0]);
  line(xZoom[1],yZoom[1],xZoom[0],yZoom[1]);
  
  noFill();
  rectMode(CENTER);
  rect(xZoom[0],yZoom[0],10,-10);
  fill(229,120,21,100);              // semi-transparent yellow box
    rect(xZoom[1],yZoom[1],-10,10);
  fill(255);
  rectMode(CORNER);
  stroke(255);
  }
///// end of zoom box
  // start run code moved to buttons tab // Mar 2022
 // if (startRun == true){    // start run//////////////////////////  
 // counter =0;  // no strings of data
 /* params();  // gets parameters for spectrum
   if(pixAv != oldAv){ // moved from graphData tab 6/24/19  
   print("startRun is true, line 491, main tab");
     newXVals();
     println(", also to line 462");
     }
    // send commands to microcontroller
      String commands = "&"+sMode[iMode]+","+IntTime+","+sAvg+","+sLoops+",190,125\n";
      println("mode: "+sMode[iMode]+", integration: "+IntTime+", loops: "+sLoops+", sAv: "+sAvg);
 //     println("line 238");
  //     commands = "&0,10000,1,1,190,125";
  */
/*     running = true;
  String commands = "&";
      serialPort.write(commands);  */
 //     delay(100);
 //     serialPort.clear();

//    startRun = false;  // get out of if run Started loop
    // introduced running true for Teensy

//  println("running flag set");
  //}  // end of if startRun is true loop

    ///////////////////////////////////////////////////////////////////////////read serial data //////////////////////////////////////////////////////////

   if(dataAcq == true){
      println("line 322");
      convertData();  // in readSerial tab
      println("out of convertData loop");
      dataAcq = false;
      reading = false;
      if(pixAv != oldAv){  // recalculate wavelength data if new averaging
        newXVals();
      } 
      findCursor();
   }
}
