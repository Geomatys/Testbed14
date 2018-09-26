# ADES WPS server

Application Deployment and Execution Service (ADES) package

## Requirements
ADES requires the following components to be installed:
* docker engine

## ADES installation and deployment

### Installation

First retrieve the docker image from Geomatys public repository
    
    docker pull images.geomatys.com/examind-ades

### Deployment
To deploy an ADES container you need to map the local docker configuration with the running container i.e. indicates the path to the local docker executable and socket file

    export DOCKER_BINARY=/usr/local/bin/docker
    export DOCKER_SOCKET=/var/run/docker.sock

Then defines the port to run ADES on localhost and an **existing** directory on the local machine that will be shared with the ADES component.

    export ADES_SHARED_DIR=/tmp/ades_shared
    export ADES_PORT=9999

Deploy an ADES instance

    docker run -it \
        -p ${ADES_PORT}:9000 \
        -v ${DOCKER_SOCKET}:/var/run/docker.sock \
        -v ${DOCKER_BINARY}:/usr/bin/docker \
        -v ${ADES_SHARED_DIR}:${ADES_SHARED_DIR} \
        -e EXAMIND_CWL_SHARED_DIR=${ADES_SHARED_DIR} \
        -e CSTL_URL=http://localhost:${ADES_PORT} \
        -e CSTL_SERVICE_URL=http://localhost:${ADES_PORT}/WS images.geomatys.com/examind-ades


### Check deployment

Check if ADES is correctly deployed:

    curl -X GET "http://localhost:${ADES_PORT}/WS/wps/default"

You should get the following answer

    <?xml version="1.0" encoding="UTF-8" standalone="yes"?>
    <ns2:ExceptionReport xmlns:ows="http://www.opengis.net/ows" xmlns:ns2="http://www.opengis.net/ows/1.1" xmlns:ns3="http://www.opengis.net/ows/2.0" xmlns:ogc="http://www.opengis.net/ogc" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.1.0" xsi:schemaLocation="http://www.opengis.net/ows/1.1 http://schemas.opengis.net/ows/1.1.0/owsExceptionReport.xsd">
    <ns2:Exception exceptionCode="MissingParameterValue" locator="request">
        <ns2:ExceptionText>The parameter REQUEST must be specified</ns2:ExceptionText>
    </ns2:Exception>
    </ns2:ExceptionReport>

Get the list of available processes (should be empty):

    curl -X GET "http://localhost:${ADES_PORT}/WS/wps/default/processes"


## Deploy and execute a process on ADES

### Deploy process
Deploy the NDVIMultiSensor process

    # Set the path to the deploy json file
    export DEPLOY_PROCESS_JSON=../application-packages/NDVIMultiSensor/DeployProcess_NDVIMultiSensor.json

    # Deploy process
    curl -X POST \
        -i "http://localhost:${ADES_PORT}/WS/wps/default/processes" \
        -H "Authorization: Bearer Th34cc3ssTok3nFrom4lice" \
        -H "Content-Type: application/json" \
        -d "@${DEPLOY_PROCESS_JSON}"

The answer should be

    HTTP/1.1 100

    HTTP/1.1 200
    Access-Control-Allow-Origin: *
    Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
    Access-Control-Allow-Headers: Origin, access_token, X-Requested-With, Content-Type, Accept
    Access-Control-Allow-Credentials: true
    Cache-Control: no-cache, no-store, max-age=0, must-revalidate
    Pragma: no-cache
    Expires: 0
    X-XSS-Protection: 1; mode=block
    X-Frame-Options: DENY
    X-Content-Type-Options: nosniff
    Content-Type: application/json
    Transfer-Encoding: chunked
    Date: Tue, 25 Sep 2018 20:09:14 GMT

    {"id":"OK","processSummary":{"id":"NDVIMultiSensor","title":"NDVIMultiSensor","keywords":[],"metadata":[],"additionalParameters":[],"version":"1.0.0","jobControlOptions":["async-execute"],"outputTransmission":["reference"],"processDescriptionURL":"http://localhost:9999/WS/wps/default/processes/NDVIMultiSensor","abstract":""}}

You can check that the new process is available in the list of processes:

    curl -X GET "http://localhost:${ADES_PORT}/WS/wps/default/processes"

### Execute process

Execute the process

    # Set the path to the json process input parameters files
    export INPUT_PROCESS_PARAMETERS_JSON=../application-packages/NDVIMultiSensor/Execute_NDVIMultiSensor.json

    # Deploy process
    curl -X POST \
        -i "http://localhost:${ADES_PORT}/WS/wps/default/processes/NDVIMultiSensor/jobs" \
        -H "Authorization: Bearer Th34cc3ssTok3nFrom4lice" \
        -H "Content-Type: application/json" \
        -d "@${INPUT_PROCESS_PARAMETERS_JSON}"

The answer should be an HTTP 201 "Created"

    HTTP/1.1 201
    Access-Control-Allow-Origin: *
    Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
    Access-Control-Allow-Headers: Origin, access_token, X-Requested-With, Content-Type, Accept
    Access-Control-Allow-Credentials: true
    Location: http://localhost:9999/WS/wps/default/processes/NDVIMultiSensor/jobs/0ee6840c-61d1-4fca-b231-82cd01249f1d
    Cache-Control: no-cache, no-store, max-age=0, must-revalidate
    Pragma: no-cache
    Expires: 0
    X-XSS-Protection: 1; mode=block
    X-Frame-Options: DENY
    X-Content-Type-Options: nosniff
    Content-Length: 0
    Date: Wed, 26 Sep 2018 08:44:12 GMT

The **Location** property indicated the url to job status

    curl -X GET "http://localhost:9999/WS/wps/default/processes/NDVIMultiSensor/jobs/0ee6840c-61d1-4fca-b231-82cd01249f1d"

Once the status is in success (i.e. {"status":"SUCCESSFUL","message":"Process completed."}), you can get the result

    curl -X GET "http://localhost:9999/WS/wps/default/processes/NDVIMultiSensor/jobs/0ee6840c-61d1-4fca-b231-82cd01249f1d/result"


