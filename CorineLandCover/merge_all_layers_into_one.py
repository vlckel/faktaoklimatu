# Import standard library modules
import arcpy, os, sys
from arcpy import env


# Allow for file overwrite
arcpy.env.overwriteOutput = True

# Set the workspace for ListFeatureClasses
gdb = "CLC_CR_LEVEL2.gdb"
outputGdb = "C:/Users/elisk/Desktop/FAKTAOKLIMATU/CORINE_LandCover/01_DataPerep/CLC_Merged_Years.gdb"
arcpy.env.workspace = "C:/Users/elisk/Desktop/FAKTAOKLIMATU/CORINE_LandCover/01_DataPerep"+"/"+gdb


# Get the list of the featureclasses to process
fc_tables = arcpy.ListFeatureClasses()

# Loop through geodatabase to get a list of all feataures insite
fcList = []
for fc in fc_tables:
    fcList.append(os.path.join(fc)) # add path to list
print(fcList)

# merge (optionally, YEAR add field from previous script could be omitted and so be used ADD_SOURCE_INFO parameter in this function)
arcpy.Merge_management(fcList, outputGdb+"/"+"CLC_CR", "", "")