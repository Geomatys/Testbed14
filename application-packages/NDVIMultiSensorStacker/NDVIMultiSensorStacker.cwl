class: Workflow
cwlVersion: v1.0
id: multisensor_ndvi_stacker
doc: NDVIMultiSensor followed by NDVIStacker.
label: multisensor_ndvi_stacker
requirements:
  - class: MultipleInputFeatureRequirement
inputs:
  - id: image-s2
    type: File
  - id: image-probav
    type: File
outputs:
  - id: output
    outputSource:
      - ndvi-stacker-pfc/output
    type: File
steps:
  - id: multisensor-ndvi-ipt
    label: MultiSensorNDVI-IPT
    in:
      - id: files
        source: image-s2
    out:
      - id: output
    run: 'NDVIMultiSensor.cwl'
  - id: multisensor-ndvi-vito
    label: MultiSensorNDVI-VITO
    in:
      - id: files
        source: image-probav
    out:
      - id: output
    run: 'NDVIMultiSensor.cwl'
  - id: ndvi-stacker-pfc
    label: NDVIStacker
    in:
      - id: files
        source:
          - multisensor-ndvi-ipt/output
          - multisensor-ndvi-vito/output
    out:
      - id: output
    run: 'NDVIStacker.cwl'
