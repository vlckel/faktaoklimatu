import os
import arcpy

# Set the workspace for ListFeatureClasses
gdb = "CLC_CR_LEVEL2.gdb"
arcpy.env.workspace = "C:/Users/elisk/Desktop/FAKTAOKLIMATU/CORINE_LandCover/01_DataPerep"+"/"+gdb

# Use the ListFeatureClasses function to return a list of features
featureclasses = arcpy.ListFeatureClasses()

# iterate feature classes
for fc in featureclasses:
    print(fc)
    # Process: Table to Table
    outLocation = "C:/Users/elisk/Desktop/FAKTAOKLIMATU/CORINE_LandCover/02_OutputData/FromScript"
    
    # Execute TableToTable
    arcpy.TableToTable_conversion(fc, outLocation, fc)