# File Processing Pipeline

### Table of Contents

1. [Introduction](#introduction)
2. [Backlog of Tasks](#backlog)
3. [Solution](#solution)
4. [Implementation](#implementation)
5. [How to run](#how2run)
6. [Results](#results)
7. [References](#references)



## Introduction <a name="introduction"></a>
___
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
___
The following table list tasks to do for the project.
| ID | Description | Status | Commit |
|------------|-------------|-------------|-------------|
|TASK-01|High Level Design for the solution|<mark>**DOING**</mark>||

## Solution <a name="solution"></a>
___

## Implementation <a name="implementation"></a>
___

## How to Run <a name="how2run"></a>
___

## Results <a name="results"></a>
___

## References <a name="references"></a>
___