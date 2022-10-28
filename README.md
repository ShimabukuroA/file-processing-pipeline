# File Processing Pipeline

### Table of Contents

1. [Introduction](#introduction)
2. [Backlog of Tasks](#backlog)
3. [Solution](#solution)
    - [High Level Design Solution](#hld)
    - [Overview](#overview)
4. [Implementation](#implementation)
5. [How to run](#how2run)
6. [Results](#results)
7. [References](#references)



## Introduction <a name="introduction"></a>

The content of this repository has the purpose to demonstrate a solution to perform a processing of events that are stored in files.  
For this scenario, we expect that each event follow a well-defined schema described bellow. Here is an example of event payload that our pipeline is going to process:

```json
{
    "event_id": "3aaafb1f-c83b-4e77-9d0a-8d88f9a9fa9a",
    "timestamp": "2021-01-14T10:18:57",
    "domain": "account",
    "event_type": "status-change",
    "data": {
        "id": 948874,
        "old_status": "SUSPENDED",
        "new_status": "ACTIVE",
        "reason": "Natus nam ad minima consequatur temporibus."
    }
}

```
The following table describes each field from the payload:
| Field | Description |
|------------|-------------|
| event_id   |Unique identifier for each event.|
| timestamp  |Timestamp for event generation.|
| domain     |A classifier for the event.|
| event_type |A classifier for the event. <br> A combination of fields **domain + data** represents a unique event type.|
| data       |Payload from event itself. A field **id** present inside is a unique identifier for a domain value represented in field **domain**.|

We are a going to process a sample of events dumped in files and write to an output partitioned by event type and timestamp(year, month and day).

## Backlog of Tasks <a name="backlog"></a>

The following table list tasks to do for the project.
| ID | Description | Status | Commit |
|------------|-------------|-------------|-------------|
|TASK-01|High Level Design for the solution|<mark>**DONE**</mark>|[Commit link](https://github.com/ShimabukuroA/file-processing-pipeline/commit/cbe75647bda48033f6356213299a8b3d85d84e9f)|
|TASK-02|Implement Docker environment to run the job|<mark>**DONE**</mark>|[Commit link](https://github.com/ShimabukuroA/file-processing-pipeline/commit/ac1638224eeaf80a266fcd7cb902b3c0d9ef5c6c)|
|TASK-03|Implement the Pyspark job|<mark>**DONE**</mark>|[Commit link](https://github.com/ShimabukuroA/file-processing-pipeline/commit/63d9ec48f20b7f4ea9ae5ced9bd5f27ac9374f9c)|
|TASK-04|Finish documentation|<mark>**TO DO**</mark>||

## Solution <a name="solution"></a>

### High Level Design Solution <a name="hld"></a>
![Alt text](https://github.com/ShimabukuroA/file-processing-pipeline/blob/develop/docs/hld_solution.svg)

### Overview <a name="overview"></a>
The solution consists of 3 components:
- JupyterLab interface
- Spark cluster
- Shared volume

The components will be created within a Docker environment where source code and data will be mounted in a shared volume(1) where JupyterLab and Spark cluster(3) can access from it. JupyterLab will be an interface to access Spark cluster using Pyspark code(2).
## Implementation <a name="implementation"></a>


## How to Run <a name="how2run"></a>


## Results <a name="results"></a>


## References <a name="references"></a>
