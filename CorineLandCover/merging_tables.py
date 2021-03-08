import arcpy
from dbfread import DBF


arcpy.env.workspace = "C:/Users/elisk/Desktop/FAKTAOKLIMATU/CORINE_LandCover/02_OutputData/FromScript"

listTables = arcpy.ListTables("*KRAJ*")

for table in listTables:
    print(table)
#arcpy.Merge_management(listTable, 'C:/junk/tables/ppt.dbf')
