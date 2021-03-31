dir1 = getDir("Select Source Directory");
list1 = getFileList(dir1);
dir2 = getDir("Select Destination Directory");

setBatchMode(true);

//run("Bio-Formats Importer", "open=" +dir1 + list1[0] + " autoscale color_mode=Composite rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");

for (i = 0; i < list1.length; i++) {

	run("Bio-Formats Importer", "open=[" +dir1 + list1[i] + "] autoscale color_mode=Composite rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
	title = getTitle(); 
	print(title);
	splitName = split(title, ".");
	//selectWindow("ACC_10x_overview_section01_1.czi");
	selectWindow(title);
	getDimensions(width, height, channels, slices, frames);
	saveAs("Tiff", dir2 + splitName[0] + "_all_c.tif");
	close("*");
	if(channels == 2){
		run("Bio-Formats Importer", "open=[" +dir1 + list1[i] + "] autoscale color_mode=Composite rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
		title = getTitle(); 
		print(title);
		splitName = split(title, ".");
		selectWindow(title);
		run("Split Channels");
		selectWindow("C1-" + title);
		saveAs("Tiff", dir2 + splitName[0] + "_c1.tif");
		selectWindow("C2-" + title);
		saveAs("Tiff", dir2 + splitName[0] + "_c2.tif");
	}
	if(channels == 3){
		run("Bio-Formats Importer", "open=[" +dir1 + list1[i] + "] autoscale color_mode=Composite rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
		title = getTitle(); 
		print(title);
		splitName = split(title, ".");
		selectWindow(title);
		run("Split Channels");
		selectWindow("C1-" + title);
		saveAs("Tiff", dir2 + splitName[0] + "_c1.tif");
		selectWindow("C2-" + title);
		saveAs("Tiff", dir2 + splitName[0] + "_c2.tif");
		//run("Split Channels");
		selectWindow("C3-" + title);
		saveAs("Tiff", dir2 + splitName[0] + "_c3.tif");
	}
	if(channels == 4){
		run("Bio-Formats Importer", "open=[" +dir1 + list1[i] + "] autoscale color_mode=Composite rois_import=[ROI manager] view=Hyperstack stack_order=XYCZT");
		title = getTitle(); 
		print(title);
		splitName = split(title, ".");
		selectWindow(title);
		run("Split Channels");
		selectWindow("C1-" + title);
		saveAs("Tiff", dir2 + splitName[0] + "_c1.tif");
		selectWindow("C2-" + title);
		saveAs("Tiff", dir2 + splitName[0] + "_c2.tif");
		//run("Split Channels");
		selectWindow("C3-" + title);
		saveAs("Tiff", dir2 + splitName[0] + "_c3.tif");
		//run("Split Channels");
		selectWindow("C4-" + title);
		saveAs("Tiff", dir2 + splitName[0] + "_c4.tif");
	}
	close("*");
}
print("Done");
setBatchMode(false);