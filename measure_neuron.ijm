//select the directory containing tif files to be quantified. files are then made into a list
dir = getDir("Select directory containing tiff files for measurement");
dir2 = getDir("Select storage directory for intermediates")
outputDir = getDir("Select directory for final image and data output")
alltif = getFileList(dir);
//set the channel number which contains the neuronal cell body stain for quantification
neuronChannel = getNumber("Input the channel number for your neuronal stain", 1);
quantChannel = getNumber("Input the channel number for the protein to be asessed", 2);
selector1 = "_c" + neuronChannel + ".tif";
selector2 = "_c" + quantChannel + ".tif";
types = newArray("MFI", "Puncta")
Dialog.create("MFI or puncta?");  
Dialog.addChoice("Type:", types);
Dialog.show();
type = Dialog.getChoice();
//loop through only these files
for(i=0;i<alltif.length;i++){
	if(indexOf(alltif[i], selector1)>=1) {
		open(dir + alltif[i]);
		title = getTitle(); 
		fn =File.nameWithoutExtension;
		print("prepping "+title);
		orig = getImageID();
		selectImage(orig);
		run("Duplicate...", "title=" +i +"c" +neuronChannel+ "dup");
		copy = getImageID();
		selectImage(orig);
		close();
		selectImage(copy);
		run("8-bit");
		run("Subtract Background...", "rolling=100 sliding disable");
		setAutoThreshold("Triangle");
		run("Despeckle", "stack");
		run("Gaussian Blur...", "sigma=3");
		run("Enhance Contrast...", "saturated=0.1");
		saveAs("Tiff", dir2 + "intermediate" + fn);
		selectImage(copy);
		close();
		}
}
for(i=0;i<alltif.length;i++){
	if(indexOf(alltif[i], selector2)>=1) {
		open(dir + alltif[i]);
		title = getTitle(); 
		fn =File.nameWithoutExtension;
		print("prepping "+title);
		orig = getImageID();
		selectImage(orig);
		run("Duplicate...", "title=" +i +"c" +quantChannel+ "dup");
		copy = getImageID();
		selectImage(orig);
		close();
		selectImage(copy);
		if(type == "Puncta"){
			//run("Gaussian Blur...", "sigma=1");
			setAutoThreshold("Moments");
			setOption("BlackBackground", true);
			run("Convert to Mask");
			}
		saveAs("Tiff", dir2 + "intermediate" + fn);
		selectImage(copy);
		close();
		}
}
allmid = getFileList(dir2);
for(i=0;i<allmid.length;i++){
	if(indexOf(allmid[i], selector1)>=1) {
		open(dir2 + allmid[i]);
		tmid = getTitle();
		print("converting image" + i);
		mid = getImageID();
		selectImage(mid);
		run("Duplicate...", "title=" +i +"c" +neuronChannel+ "weka");
		copyweka = getImageID();
		selectImage(mid);
		close();
		selectImage(copyweka);
		setTool("freeline");
		run("Trainable Weka Segmentation");
		selectWindow("Trainable Weka Segmentation v3.2.34");
		wait(5000);
		call("trainableSegmentation.Weka_Segmentation.loadClassifier", "C:\\Users\\Aidan\\Desktop\\Neuron Measurer\\classifier.model");
		wait(5000);
		call("trainableSegmentation.Weka_Segmentation.getResult");
		wait(10000);
		selectWindow("Classified image");
		ci = getImageID();
		rename("c" + i + neuronChannel + "wekap");
		setOption("BlackBackground", true);
		run("Convert to Mask");
		run("Watershed");
		if(indexOf(allmid[i + 1], selector2)>=1) {
			open(dir2 + allmid[i + 1]);
			titleq = getTitle();
			q = getImageID();
			selectImage(ci);
			run("Set Measurements...", "area mean modal min perimeter shape feret's integrated stack redirect=None decimal=3");
			run("Analyze Particles...", "size=100.00-1600.00 circularity=0.40-1.00 exclude clear include add");
			selectImage(q);
			roiManager("Show All without labels");
			roiManager("Combine");
			roiManager("Measure");
			selectWindow("Results");
			if(type == "Puncta"){
				Table.save(outputDir + titleq + "_thresh.csv");
     		}
     		if(type == "MFA"){
				Table.save(outputDir + titleq + "_mfa.csv");
     		}
		}
     close("*");
     close("Results");
	}
}	
close("*");
print("Done");
setBatchMode(false);
 