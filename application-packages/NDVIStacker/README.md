# NDVI Stacker process

This process merge multiple [Normalized Difference Vegetation Index](https://en.wikipedia.org/wiki/Normalized_difference_vegetation_index) (NDVI) TIFF files into one GeoTIFF.

The process support the following image types:
* NDVI - as a GeoTIFF file

If each input image as the same CRS the process generate the output image as a GeoTIFF with the same CRS and resolution as the originals.
If not, all the inputs image will be reprojected to EPSG:4326 before the merge.

## Requirements
This process requires the following components to be installed:
* cwl-runner
* docker engine

## Execution

You can download or reference the following images for test purpose:
* Proba-V NDVI image [PROBAV_L1C_20160505_232748_3_V101](https://nexus.geomatys.com/repository/raw-public/testbed14/PROBAV_L1C_20160505_232748_3_V101.tif)
* Proba-V NDVI image [PROBAV_L1C_20160505_232949_3_V101](https://nexus.geomatys.com/repository/raw-public/testbed14/PROBAV_L1C_20160505_232949_3_V101.tif)

In the following we suppose that the working directory contains the images to process.

### Execute using docker only

To execute the process using directly docker:

    # Work directory is current directory 
    export WORKDIR=`pwd`
    
    # The files to process is located under ${WORKDIR}
    export PV1FILE=PROBAV_L1C_20160505_232748_3_V101.tif
    export PV2FILE=PROBAV_L1C_20160505_232949_3_V101.tif

    # Compute NDVI processing
    docker run -v ${WORKDIR}/${PV1FILE}:/${PV1FILE} -v ${WORKDIR}/${PV2FILE}:/${PV2FILE} -v ${WORKDIR}:/outputs --workdir=/outputs images.geomatys.com/ndvis:latest /${PV1FILE} ${PV2FILE}
    
The result (e.g. out.tif) is available within ${WORKDIR}

### Execute using cwl-runner

To execute the process using cwl-runner, you need two files:
* The process workflow (e.g. [NDVIStacker.cwl](https://raw.githubusercontent.com/Geomatys/Testbed14/master/application-packages/NDVIStacker/NDVIStacker.cwl))
* The parameters file which contains the list of input images to be processed (e.g. [NDVIStacker_CWL_params.json](https://raw.githubusercontent.com/Geomatys/Testbed14/master/application-packages/NDVIStacker/NDVIStacker_CWL_params.json))

The NDVIStacker_CWL_params.json references the input files to process.

To execute the process:

    # You can add --debug option to make it more verbose
    cwl-runner --no-read-only --preserve-entire-environment NDVIStacker.cwl NDVIStacker_CWL_params.json

The result (e.g. out.tif) is available within ${WORKDIR}

*Note 1: Input files defined in NDVIStacker_CWL_params.json can be  paths or urls*

*Note 2: the process will use the docker image images.geomatys.com/ndvis:latest*

*Note 3: cwl-runner needs at least 8 Go of RAM to download large files. If you experience some memory error, consider to download the files and then reference them locally in the NDVIStacker_CWL_params.json parameter file.*
