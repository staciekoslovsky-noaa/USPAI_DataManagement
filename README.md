# USPAI Data Management

This repository stores the code associated with managing USPAI data. Code numbered 0+ are intended to be run sequentially as the data are available for processing. Code numbered 99 are stored for longetivity, but are intended to only be run once to address a specific issue or run as needed, depending on the intent of the code.

The Datasheets folder contains the KAMERA-specific datasheets for USPAI flights.

The data management processing code is as follows:
* **USPAI_01_Import2DB.R** - code to import data from the network into the DB

Other code in the repository includes:
* Code for data QA/QC in the field
	* USPAI_99_DroppedFrameRates.R
	* USPAI_99_IdentifyImagesInPolys.R
	* USPAI_99_ProcessLogFiles2Shp.R