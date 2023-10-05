# Stack-pipeline-synced

This stack watch all your Cycloid project and sent a daily event when the pipeline is not up to date with the template in the stack.

# Requirements

This stack require to provide a Cycloid API key in a credential.

# Details

The pipeline will run a periodical job which will list all your organization projects.
For each project using Cycloid CLI, the job will check if all environments pipelines are
up-to-date from the pipeline template contained in the stack.

If some pipelines are not up-to-date it will send a Cycloid event.
