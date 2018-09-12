# NDVI multiSpectral process

NDVI is calculated after the two bands values Near Infrared and red.
It is calculated by this formula : NDVI = (NIR-Red)/(NIR+Red)
The images needed for NDVI calculation must follow these constraints :

- Sentinel-2 (JPEG2000)
- Proba-V (HDF5)

The processing consists in :
-   for each image, generate a NDVI GeoTIFF image, with the same CRS and resolution as the original one
-   copy the NDVI images in the output folder (the new files are named with an uuid)

Test data can be found at the following location :
- http://...../S2A_MSIL1C_20180610T154901_N0206_R054_T18TXR_20180610T193029.SAFE.zip (sentinel-2)
- https://nexus.geomatys.com/repository/raw-public/testbed14/PROBAV_L1C_20160101_004905_2_V101.HDF5 (Proba-V)

# CWL
here is a reference to the CWL file : 
https://raw.githubusercontent.com/Geomatys/Testbed14/master/application-packages/NDVIMultiSensor/NDVIMultiSensor.cwl

using the docker image : images.geomatys.com/ndvims:latest

usage : 
cwl-runner --no-read-only --preserve-entire-environment  https://raw.githubusercontent.com/Geomatys/Testbed14/master/application-packages/NDVIMultiSensor/NDVIMultiSensor.cwl params.json

with a params.json containing :
```json
{
    "files": [
        {
	    "location": "https://nexus.geomatys.com/repository/raw-public/testbed14/S2A_MSIL1C_20180610T154901_N0206_R054_T18TXR_20180610T193029.SAFE.zip",
	    "class": "File"
        },
        {
            "location": "https://nexus.geomatys.com/repository/raw-public/testbed14/PROBAV_L1C_20160101_004905_2_V101.HDF5",
            "class": "File"
        }
    ]
}
```

**Warning:** 
cwl-runner use a lot a memory to download large files. If you experience some memory error, consider to download the files and then reference them locally in params.json


# WPS
in order to call this process in WPS :

1) Deploy request :
https://raw.githubusercontent.com/Geomatys/Testbed14/master/application-packages/NDVIMultiSensor/DeployProcess_NDVIMultiSensor.json

2) Execute request :
https://raw.githubusercontent.com/Geomatys/Testbed14/master/application-packages/NDVIMultiSensor/Execute_NDVIMultiSensor.json

the result will look like this:
```json
{
  "outputs": [
    {
      "id": "output",
      "value": "http://<wps hosting url>/3e75093e-9f41-4fd9-b95b-69cc7594dcd1.tif"
    },
    {
      "id": "output",
      "value": "http://<wps hosting url>/4d8a989f-49e5-4ae4-b830-b768aaf9a289.tif"
    }
  ]
}
```

