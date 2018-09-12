# NDVI multiSpectral process

This process compute a [Normalized Difference Vegetation Index](https://en.wikipedia.org/wiki/Normalized_difference_vegetation_index) (NDVI) from an input list of satellite images.

The NDVI is calculated as follows:

    NDVI = (NIR − Red) / (NIR + Red)

The process support the following image types:
* Sentinel-2 - as a zipped SAFE file
* Proba-V - as a HDF5 file

For each input image, the process generate the NDVI as a GeoTIFF image with the same CRS and resolution as the original one

## Requirements
This process requires the following components to be installed:
* cwl-runner
* docker engine

## Execution

The process workflow is described within the [NDVIMultiSensor.cwl](https://raw.githubusercontent.com/Geomatys/Testbed14/master/application-packages/NDVIMultiSensor/NDVIMultiSensor.cwl) file

The list of input images should be provided within the [NDVIMultiSensor_CWL_params.json](https://raw.githubusercontent.com/Geomatys/Testbed14/master/application-packages/NDVIMultiSensor/NDVIMultiSensor_CWL_params.json) file

The NDVIMultiSensor_CWL_params.json references the input files to process. Files can be defined from paths or urls.

You can download or reference the following images for test purpose:
* Sentinel-2 image [S2A_MSIL1C_20180610T154901_N0206_R054_T18TXR_20180610T193029](https://nexus.geomatys.com/repository/raw-public/testbed14/S2A_MSIL1C_20180610T154901_N0206_R054_T18TXR_20180610T193029.SAFE.zip)
* Proba-V image [PROBAV_L1C_20160101_004905_2_V101](https://nexus.geomatys.com/repository/raw-public/testbed14/PROBAV_L1C_20160101_004905_2_V101.HDF5)

To execute the process:

    cwl-runner --no-read-only --preserve-entire-environment NDVIMultiSensor.cwl NDVIMultiSensor_CWL_params.json

*Note 1: the process will use the docker image images.geomatys.com/ndvims:latest*

*Note 2: cwl-runner needs at least 8 Go of RAM to download large files. If you experience some memory error, consider to download the files and then reference them locally in the NDVIMultiSensor_CWL_params.json parameter file.*

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

