/*************************************
*  controllers tab, WheeTrometer_GUI
*    buttons
*      connect
*       mode
*       load data
*    textfields
*      expName
*      fileName
*      integration time
*       name
*       loops
*       data averaging
*********************************/
void setupSpec(){
  
//  ExpName.setText(expName[expNo]);                  
//  min.setText(sMin[expNo]);
//  max.setText(sMax[expNo]);

//  loops.setText(stAvg[expNo]);  // loops
  integration_Time.setText(sIntTime[expNo]);   // integration time
//  Average.setText(stLoops[expNo]);     //  data average
}

void cp5_controllers_setup(){
 ////////////////////////////////////////////////Text Fields//////////////////////////////
  cp5 = new ControlP5(this);  //cp5 = new ControlP5(this);
  cp5Cursor = new ControlP5(this);
//  cp5Files = new ControlP5(this);
//  cp5Cal = new ControlP5(this);
  cp5Name = new ControlP5(this);
  cp5Spec = new ControlP5(this);     // for experiment files?
                                      // cp5Process moved to processData tab
  cp5AbsView = new ControlP5(this);  // only show view button after spectra processed
//  PFont font = loadFont("ArialMT-48.vlw");
PFont font = createFont("Arial", 14);
//  PFont font2 = createFont("arial", 16);
//  PFont font3 = createFont("arial",12); 
  int lowY = height -45;
  int buttonC = #E3CA85;
  int runC = #C64F2E;

  int loadX = 320;
  int deltaX = 60;
  int viewX = loadX+deltaX;
  int viewY = 50;
 // int deltaY = 20;
  
 /* ExpName = cp5Spec.addTextfield("ExpName")
    .setColor(#030302) 
      .setColorBackground(#CEC6C6)//(#FFFEFC) 
        .setColorForeground(#AA8A16) 
          .setPosition(150, height-90)               
            .setSize(80, 20)
              .setFont(font)
                .setFocus(false)               
                    .setText(expName[expNo]);  */
  
  fileName = cp5.addTextfield("fileName")
    .setColor(#030302) 
      .setColorBackground(#CEC6C6)//(#FFFEFC) 
        .setColorForeground(#AA8A16) 
          .setPosition(800, 40)               // new
            .setSize(100, 20)
              .setFont(font)
                .setFocus(false)               
                    .setText("file");
                    

  /*                 
  cp5ExpSetup.addButton("specSel")
     .setPosition(200, height-45)
     .setSize(50,30)
     .setLabel("Next");
     
     cp5ExpSetup.addButton("addExp")
     .setPosition(265, height-45)
     .setSize(50,30)
     .setLabel("add exp");
  */
/*  name = cp5Name.addTextfield("name")
    .setColor(#030302) 
      //.setColorActive(#AA8A16)
      .setColorBackground(#CEC6C6)//(#FFFEFC) 
        //.setColorCaptionLabel(#F01B1B) 
        .setColorForeground(#AA8A16) 
          //.setColorValueLabel(#F01B1B)
          .setPosition(340, height - 45)               // new
            .setSize(40, 25)
              .setFont(font)
                .setFocus(false)
                  //.setLabel("initial voltage (mV)")                
                    .setText("0011"); 
  */
 // integration_Time = cp5ExpSetup.addTextfield("Integration_Time")
   integration_Time = cp5.addTextfield("Integration_Time")
    .setColor(#030302) 
      .setColorBackground(#CEC6C6)//(#FFFEFC) 
        .setColorForeground(#AA8A16) 
          .setPosition(20, lowY)               // new
            .setSize(50, 25)
              .setFont(font)
                  .setText(msInt);
                            


  
 
               
cp5.addButton("delete_spec")
       .setPosition(width -160, height - 200)
                    .setSize(110,25)
                    .setFont(font);
                    

  /////////////////////////////Bang's///////////////////////////////////////////////////////////
  cp5.addButton("Start_Run")
    .setColorBackground(#F5B759)//#FFFEFC 
        .setColorCaptionLabel(#030302) //#030302
          .setColorForeground(runC)
          .setColorActive(#06CB49)
            .setPosition(40, height-100)
              .setSize(80, 30)
              .setFont(font)
         //       .setTriggerEvent(Bang.RELEASE)
                  .setLabel("Start Run") //
                    .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)  //.setLabel("Start_Run")
                      ;
 
   cp5.addButton("Save_run")
    .setColorBackground(buttonC)//#FFFEFC 
        .setColorCaptionLabel(#030302) //#030302
          .setColorForeground(buttonC)  
          .setPosition(loadX, 40)
            .setSize(90, 20)
    //          .setTriggerEvent(Bang.RELEASE)
                .setLabel("Save Run")
                .setFont(font)
                  .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)  //.setLabel("Start_Run")
                    ;
  
  cp5.addButton("LoadFile")
    .setColorBackground(buttonC)//#FFFEFC 
        .setColorCaptionLabel(#030302) //#030302
          .setColorForeground(buttonC)  
          .setPosition(loadX, 10)
            .setSize(90, 20)
            .setFont(font)
                .setLabel("Load Data")
                  .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)  //.setLabel("Start_Run")
                    ;
 
       //////  process data buttons /////////
                    
   cp5AbsView.addButton("view")
    .setColorBackground(buttonC)//#FFFEFC 
        .setColorCaptionLabel(#030302) //#030302
          .setColorForeground(buttonC)  
          .setPosition(viewX, 10)
            .setSize(50, 20)
                .setLabel("View")
                .setFont(font)
                  .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)  //.setLabel("Start_Run")
                    ;
    ////////////////  Processing buttons ////////////////  

    cp5.addButton("processAbs")
    .setColorBackground(buttonC)//#FFFEFC 
        .setColorCaptionLabel(#030302) //#030302
          .setColorForeground(buttonC)  
          .setPosition(viewX+50, viewY-10)
            .setSize(90, 20)
                .setLabel("process")
                .setFont(font)
                  .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)  //.setLabel("Start_Run")
                    ;
                    

                    
 cp5.addButton("clear")
    .setColorBackground(buttonC)//#FFFEFC 
        .setColorCaptionLabel(#030302) //#030302
          .setColorForeground(buttonC)  
          .setPosition(viewX+150, 10)
            .setSize(90, 20)
                .setLabel("Clear Flag")
                .setFont(font)
                  .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)  //.setLabel("Start_Run")
                    ;
                    

                    
cp5.addButton("zoom")
    .setColorBackground(buttonC)//#FFFEFC 
        .setColorCaptionLabel(#030302) //#030302
          .setColorForeground(buttonC)  
          .setPosition(700, 40)
            .setSize(50, 20)
                .setLabel("Zoom")
                .setFont(font)
                  .getCaptionLabel().align(ControlP5.CENTER, ControlP5.CENTER)  //.setLabel("Start_Run")
                    ;
                    
         
                    

   cp5.addButton("mode")
     .setPosition(20, 55)  // moved over
      .setSize(65, 20)
      .setFont(font)
      ;  
 
    cp5Cursor.addButton("peak_pick")
     .setPosition(650, height-100) 
      .setSize(90, 20)
      .setFont(font)
      ;
      
   cp5.addButton("cursor")
     .setPosition(550, height-100) 
      .setSize(90, 20)
      .setFont(font)
      ;
      // bring the set button and wavelength text field back later
}
