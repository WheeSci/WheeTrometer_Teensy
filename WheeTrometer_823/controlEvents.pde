// controlEvents tab, WheeTrometer_2020
// mode
// view
// clear

// select - determine which spectrum is selected
// process() - convert intensity to absorbance
// set

void mode(){
  int noModes = 2;
  iMode++;
  iMode = iMode%noModes;
  println("mode: "+iMode);
}

void view(){     // itterate view, only seen after some spectra processed
//  println("view pressed");
  if(iView == 0 && refFlag == false){
    errorFlag = true;
    iError = 1;
  } else {
  iView++;
  iView = iView%3;
//  viewVal = iView;    // eliminates zoom 
  zoomed = false;
  getYLims();
  println("iView: "+iView);
  }
}

void clear(){    // clear error flag
 iError = 0;
 errorFlag = false;
}



 

void delete_spec(){
  for(int i = spectra-1; i>=0; i--){  // for each spectrum, starting at last
    if(selectBox[i] == false){  // delete unselected spectra
    clearArray(i,true);    // method is in buttons tab.
    }
  }
  getYLims();  //resetLims();  //  resets y limit, method in buttons tab, line 105
}
