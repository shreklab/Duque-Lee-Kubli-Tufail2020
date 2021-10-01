 var filter, rollingball, threshold_method, mincellsize, maxcellsize
     showMessage("Please choose the folder that the images are in");
     input = getDirectory("Input directory");
     showMessage("Please choose the folder you want the ROI's to go");
     input2 = getDirectory("Input directory");

     list = getFileList(input);

  parameterinput();
  for (i=0; i<list.length; i++)
  {
  convert(input, list[i]);

  }
  
  function convert(input, file)
  {
  	  open(input + file);
	  run("Gaussian Blur...", "sigma="+filter);
	  run("Subtract Background...", "rolling="+rollingball);
	  setAutoThreshold(threshold_method+ " dark");
	  setOption("BlackBackground", true);
	  run("Convert to Mask");
	  run("Watershed");
	  run("Analyze Particles...", "size="+mincellsize+"-"+maxcellsize+"circularity=0.20-1.00 exclude clear add");
	  if (roiManager("Count") > 0)
	  {
	  	new_file_name=replace(file,".tif",""); 
	  	roiManager("Save", input2+new_file_name+"ROISET.zip");
	  }
	  run("Close All");
	  
  }

  function parameterinput()
  {
	  Dialog.create("Parameter");
	  Dialog.addNumber("MinCellSize(um^2)", 600); //min cell size detected (radius ~14 pixels)
	  Dialog.addNumber("MaxCellSize(um^2)", 8000); //max cell size detected (radius ~60 pixels)
	  Dialog.addChoice("Threshold Method:", newArray("Li","Triangle", "Otsu", "Default", "Huang", "Yen", "Mean")); //different threshold/identification methods. 
	  Dialog.addNumber("Gaussian filter size", 2.5); //sets gaussian filter
	  Dialog.addNumber("RollingballSize", 43); //sets rolling ball variable (used in background subtraction
	  Dialog.show();
	  mincellsize = Dialog.getNumber();//currently in pixels
	  maxcellsize = Dialog.getNumber();//currently in pixels
	  threshold_method = Dialog.getChoice();
	  filter = Dialog.getNumber();
	  rollingball = Dialog.getNumber();
  }
