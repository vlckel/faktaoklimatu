# Import standard library modules
import arcpy, os, sys
from arcpy import env
import re

# Allow for file overwrite
arcpy.env.overwriteOutput = True

# Set the workspace for ListFeatureClasses
gdb = "CLC_CR_ORP.gdb"
arcpy.env.workspace = "C:/Users/elisk/Desktop/FAKTAOKLIMATU/CORINE_LandCover/01_DataPerep"+"/"+gdb


# Get the list of the featureclasses to process
fc_tables = arcpy.ListFeatureClasses()

# Loop through each file and perform the processing
for fc in fc_tables:
    print(str("processing " + fc))

    # Define field name and expression
    field = "YEAR"
    expression = str(fc) #populates field   
    match = re.search(r"(\d{4})", expression).group(1) #extract year from the feature name

    # Create a new field with a new name
    arcpy.AddField_management(fc,field,"TEXT")

    # Calculate field here
    arcpy.CalculateField_management(fc, field, '"'+match+'"', "PYTHON")