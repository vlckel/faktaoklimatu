import os
import arcpy

# Set the workspace for ListFeatureClasses
gdb = "CLC_Europe.gdb" #database where all CLC layers are saved (the original ones from Copernicus)
arcpy.env.workspace = "C:/Users/elisk/Desktop/FAKTAOKLIMATU/CORINE_LandCover/01_DataPerep"+"/"+gdb
countries = "C:/Users/elisk/Desktop/FAKTAOKLIMATU/CORINE_LandCover/01_DataPerep/Misc.gdb/Countries_singlepart"

# Use the ListFeatureClasses function to return a list of features
featureclasses = arcpy.ListFeatureClasses()

# iterate feature classes
for clc in featureclasses:
    
    # just another, faster approach 
    fieldnames = [f.name for f in arcpy.ListFields(clc)]
    
    # check type of the column name (CLC_CODE) - needs to be integer, so it can be merged with mapping table
    for field in arcpy.ListFields(clc):
        if field.name == 'CLC_CODE':
            print("Field:       {0}".format(field.name))
            print("Type:        {0}".format(field.type))
    #print(fieldtypes))
    
    print("clipping ",clc)
    fc_clip = "C:/Users/elisk/Desktop/FAKTAOKLIMATU/CORINE_LandCover/01_DataPerep/CLC_Europe_Countries.gdb/"+clc
    arcpy.analysis.Clip(clc, countries, fc_clip, "")
    
    # join the table
    legend = "C:/Users/elisk/Desktop/FAKTAOKLIMATU/CORINE_LandCover/00_InputData/u2018_clc2018_v2020_20u1_fgdb/Legend/clc_legend.dbf"
    fc_join = fc_clip + "_joined"
    arcpy.AddJoin_management(fc_clip, "CLC_CODE", legend, "CODE_CLC", "KEEP_ALL")
    arcpy.CopyFeatures_management(fc_join, output)
    arcpy.RemoveJoin_management (fc_join) 
    
    # intersect with countries
    inFeatures = [fc_join, countries]
    fc_intersect = fc_clip + "_intersect" 
    arcpy.Intersect_analysis(inFeatures, fc_intersect)
    
    # dissolve   
    fc_dissolve = fc_clip + "_dissolve"
    arcpy.Dissolve_management(fc_intersect, fc_dissolve,
                          ["NAME_ENGL", "LABEL2"], "", "MULTI_PART", "")  
    
          
          
    
    