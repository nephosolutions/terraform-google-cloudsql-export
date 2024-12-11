#  Copyright 2019-2024 NephoSolutions srl, Sebastian Trebitz
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

import base64
import functions_framework
import json
import logging

from cloudevents.http import CloudEvent
from datetime import datetime

from googleapiclient import discovery
from googleapiclient.errors import HttpError


@functions_framework.cloud_event
def main(cloud_event: CloudEvent) -> None:
    """
    This function is triggered by a pubsub message on a Pub/Sub topic.

    Args:
        cloud_event: The CloudEvent that triggered this function.
    Returns:
        None
    """
    service = discovery.build("sqladmin", "v1")
    datestamp = datetime.now().strftime("%Y%m%d-%H%M")  # format timestamp: YearMonthDay-HourMinute
    message_data = json.loads(base64.b64decode(cloud_event.data["message"]["data"]).decode("utf-8"))

    try:
        bucket_url = message_data["bucket_uri"]
        databases = message_data["databases"]
        file_name = message_data["file_name"]
        instance = message_data["instance"]
        offload = message_data["offload"]
        project = message_data["project"]

        uri = "{0}/{1}-{2}.sql.gz".format(bucket_url, file_name, datestamp)

        request_body = {
            "exportContext": {
                "kind": "sql#exportContext",
                "fileType": "SQL",
                "uri": uri,
                "databases": databases,
                "offload": offload,
            }
        }

        try:
            request = service.instances().export(project=project, instance=instance, body=request_body)
            response = request.execute()

        except HttpError as err:
            logging.error("Could NOT run backup. Reason: {}".format(err))

        else:
            logging.info("Backup task status: {}".format(response))

    except KeyError as err:
        logging.error(f"Missing key {err} in `message_data`")
