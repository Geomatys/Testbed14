{
    "cwlVersion": "v1.0",
    "class": "CommandLineTool",
    "requirements": {
        "DockerRequirement": {
            "dockerPull": "images.geomatys.com/ndvis:latest"
        }
    },
    "inputs": {
        "files": {
            "inputBinding": {
                "position": 1,
                "prefix": "-Pfiles",
                "itemSeparator": ","
            },
            "type": {
                "type": "array",
                "items": "File"
            }
        },
    },
    "outputs": {
        "output": {
            "outputBinding": {
                "glob": "stacked.tif"
            },
            "type": "File",
        }
    }
}

