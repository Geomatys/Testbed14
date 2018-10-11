# EMS WPS server

The Execution Management Service (EMS) is an implementation of the [OGC Testbed14 REST Transactional WPS 2.0 specification](https://app.swaggerhub.com/apis/Spacebel.be/WPS/Testbed14)

You can test EMS component on a [demo server provided by Geomatys](http://tbd14.geomatys.com/WS/wps/default)

## Requirements
EMS requires the following components to be installed:
* docker engine

## EMS installation and deployment

### Installation

First retrieve the docker image from Geomatys public repository
    
    docker pull images.geomatys.com/examind-ems

### Deployment
To deploy an EMS container you need to map the different ADES to contact on MEP, regarding of the data collection requested.
This parameter is encoded as a json map as : 
{ "ADES_URL" : data collections list}

    export ADES_URLS={"http://ades.vgt.vito.be/WS/wps/default" : ["EOP:VITO:PDF:urn:ogc:def:EOP:VITO:PROBAV_P_V001"]}

A PFC ADES is also required for non-MEP execution :

    export ADES_PFC_URL="http://ades.vgt.vito.be/WS/wps/default"

For authentication, define the IDP URL :

    export IDP_URL="https://eodata-iam.user.eocloud.eu:8080/oauth2/userinfo?schema=openid"

Then defines the port to run EMS on localhost.


    export EMS_PORT=9999

Deploy an ADES instance

    docker run -it \
        -p ${EMS_PORT}:9000 \
        -e ADES_URLS=${ADES_URLS} \
        -e ADES_PFC_URL=${ADES_PFC_URL} \
        -e IDP_URL=${IDP_URL} \
        -e CSTL_URL=http://localhost:${EMS_PORT} \
        -e CSTL_SERVICE_URL=http://localhost:${EMS_PORT}/WS images.geomatys.com/examind-ems

#### 

### Check deployment

Check if EMS is correctly deployed:

    curl -X GET "http://localhost:${EMS_PORT}/WS/wps/default"

You should get the following answer

    `{
	"links": [{
		"href": "http://localhost:${EMS_PORT}/WS/wps/default",
		"rel": "self",
		"type": "application/json"
	}, {
		"href": "http://localhost:${EMS_PORT}/WS/wps/default/api",
		"rel": "service",
		"type": "application/json"
	}, {
		"href": "http://localhost:${EMS_PORT}/WS/wps/default/conformance",
		"rel": "conformance",
		"type": "application/json"
	}, {
		"href": "http://localhost:${EMS_PORT}/WS/wps/default/processes",
		"rel": "processes",
		"type": "application/json"
	}]
    }`

Get the list of available processes (should be empty):

    curl -X GET "http://localhost:${EMS_PORT}/WS/wps/default/processes"


## Deploy and execute a process on EMS

### Deploy process
Deploy the NDVIMultiSensor process

    # Set the path to the deploy json file
    export DEPLOY_PROCESS_JSON=../application-packages/NDVIMultiSensor/DeployProcess_NDVIMultiSensor.json

    # Deploy process
    curl -X POST \
        -i "http://localhost:${EMS_PORT}/WS/wps/default/processes" \
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

    {"id":"OK","processSummary":{"id":"NDVIMultiSensor","title":"NDVIMultiSensor","keywords":[],"metadata":[],"additionalParameters":[],"version":"1.0.0","jobControlOptions":["async-execute"],"outputTransmission":["reference"],"processDescriptionURL":"http://localhost:${EMS_PORT}/WS/wps/default/processes/NDVIMultiSensor","abstract":""}}

You can check that the new process is available in the list of processes:

    curl -X GET "http://localhost:${EMS_PORT}/WS/wps/default/processes"

### Execute process

Execute the process

    # Set the path to the json process input parameters files
    export INPUT_PROCESS_PARAMETERS_JSON=../application-packages/NDVIMultiSensor/Execute_NDVIMultiSensor_EMS.json

    # Deploy process
    curl -X POST \
        -i "http://localhost:${EMS_PORT}/WS/wps/default/processes/NDVIMultiSensor/jobs" \
        -H "Authorization: Bearer Th34cc3ssTok3nFrom4lice" \
        -H "Content-Type: application/json" \
        -d "@${INPUT_PROCESS_PARAMETERS_JSON}"

The answer should be an HTTP 201 "Created"

    HTTP/1.1 201
    Access-Control-Allow-Origin: *
    Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS
    Access-Control-Allow-Headers: Origin, access_token, X-Requested-With, Content-Type, Accept
    Access-Control-Allow-Credentials: true
    Location: http://localhost:${EMS_PORT}/WS/wps/default/processes/NDVIMultiSensor/jobs/0ee6840c-61d1-4fca-b231-82cd01249f1d
    Cache-Control: no-cache, no-store, max-age=0, must-revalidate
    Pragma: no-cache
    Expires: 0
    X-XSS-Protection: 1; mode=block
    X-Frame-Options: DENY
    X-Content-Type-Options: nosniff
    Content-Length: 0
    Date: Wed, 26 Sep 2018 08:44:12 GMT

The **Location** property indicated the url to job status

    curl -X GET "http://localhost:${EMS_PORT}/WS/wps/default/processes/NDVIMultiSensor/jobs/0ee6840c-61d1-4fca-b231-82cd01249f1d"

Once the status is in success (i.e. {"status":"SUCCESSFUL","message":"Process completed."}), you can get the result

    curl -X GET "http://localhost:${EMS_PORT}/WS/wps/default/processes/NDVIMultiSensor/jobs/0ee6840c-61d1-4fca-b231-82cd01249f1d/result"


