//chartsSetup tab, Wheetrometer_2020
// methods: setupCharts
//     setAxes

void setupCharts(){

 ////////////////////////////////grafica uses GPlots
  plot1 = new GPlot(this);

  plot1.setPos(plotX, plotY);
  plot1.setDim(plotWidth, plotHeight);
  plot1.setXLim(xMin[0], xMax[0]);
  print(wavelength);
  plot1.setYLim(0, 800);
    plot1.setPoints(data);
  for(int i = 0; i<4000; i++){
  data.add(i,i);
  }
 
}/////////////////end setupChart/////

void setAxes(){

  String[] title = {"Raw Data","Absorbance Data","Processed Intensity","Zoomed Data"};
  String[] yLabelTxt = {"Raw Intensity","Absorbance","Processed Intensity","Zoomed Data"};
  plot1.getXAxis().getAxisLabel().setText("Wavelength (nm)");
 //     println("in set Axes, line 27, charts Setup");
  plot1.getYAxis().getAxisLabel().setText(yLabelTxt[iView]);
  plot1.getTitle().setText(title[iView]);

  plot1.setXLim(xMin[iView],xMax[iView]);
  plot1.setYLim(yMin[iView],yMax[iView]);
  }
