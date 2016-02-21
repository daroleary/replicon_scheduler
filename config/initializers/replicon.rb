require 'replicon_scheduler_client'

RepliconSchedulerClient.init(api_host: ENV.fetch('REPLICON_HOST', 'interviewtest.replicon.com'))