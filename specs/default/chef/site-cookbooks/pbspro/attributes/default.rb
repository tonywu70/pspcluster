# Copyright (c) Microsoft Corporation. All rights reserved.
# Licensed under the MIT License.
#
default[:pbspro][:version] = "19.1.2-0"
default[:pbspro][:slots] = nil

default[:pbspro][:is_grouped] = true

default[:pbspro][:submit_hook][:__comment__] = "This file was generated by serializing node[:cyclecloud][:pbspro][:submit_hook]."
default[:pbspro][:submit_hook][:disable_eager_packing] = true
default[:pbspro][:submit_hook][:enabled] = true

default[:pbspro][:submit_hook][:logging][:level] = "INFO"
default[:pbspro][:submit_hook][:logging][:filename] = "#{node[:cyclecloud][:bootstrap]}/pbs/submit_hook.log"
default[:pbspro][:submit_hook][:logging][:filemode] = "a"
default[:pbspro][:submit_hook][:logging][:format] = "%(asctime)s %(levelname)s %(message)s"


default[:pbspro][:autoscale_hook][:__comment__] = "This file was generated by serializing node[:cyclecloud][:pbspro][:autostart_hook]."
default[:pbspro][:autoscale_hook][:src_dirs] = ["#{node[:cyclecloud][:home]}/system/embedded/lib/python2.7/site-packages",
                                                "#{node[:cyclecloud][:bootstrap]}/pbs"]
# pass through to the hook config json file
default[:pbspro][:autoscale_hook][:cyclecloud_home] = node[:cyclecloud][:home]
default[:pbspro][:autoscale_hook][:autostart_log_level] = "DEBUG"
default[:pbspro][:autoscale_hook][:autostart_log_file_level] = "DEBUG"

if node[:cyclecloud][:node][:template] == "manager"
	default[:cyclecloud][:cluster][:autoscale][:idle_time_before_jobs] = 300
	default[:cyclecloud][:cluster][:autoscale][:idle_time_after_jobs] = 300
else
	# the pbs autoscaler should be removing idle nodes, but if after an hour of idle time assume something is wrong with the autoscaler.
	#default[:cyclecloud][:cluster][:autoscale][:idle_time_before_jobs] = 4 * 3600
	#default[:cyclecloud][:cluster][:autoscale][:idle_time_after_jobs] = 4 * 3600
	default[:cyclecloud][:cluster][:autoscale][:idle_time_before_jobs] = 900
	default[:cyclecloud][:cluster][:autoscale][:idle_time_after_jobs] = 900
end
