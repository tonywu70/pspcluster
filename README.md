#### Using CycleCloud to rapid deploy HPC with PBS Pro and BeeGFS
### PBS Professional Open Source Project -- "Golden" Source Repository

If you are new to this project, please start at http://www.pbspro.org

### What is PBS Professional?
PBS Professional® software optimizes job scheduling and workload management in high-performance computing (HPC) environments – clusters, clouds, and supercomputers – improving system efficiency and people’s productivity.  Built by HPC people for HPC people, PBS Pro™ is fast, scalable, secure, and resilient, and supports all modern infrastructure, middleware, and applications.

* **Scalability:** supports millions of cores with fast job dispatch and minimal latency; tested beyond 50,000 nodes
* **Policy-Driven Scheduling:** meets unique site goals and SLAs by balancing job turnaround time and utilization with optimal job placement
* **Resiliency:** includes automatic fail-over architecture with no single point of failure – jobs are never lost, and jobs continue to run despite failures
* **Flexible Plugin Framework:** simplifies administration with enhanced visibility and extensibility; customize implementations to meet complex requirements
* **Health Checks:** monitors and automatically mitigates faults with a comprehensive health check framework
* **Voted #1 HPC Software** by HPC Wire readers and proven for over 20 years at thousands of sites around the globe in both the private sector and public sector

### Blog
[PBS Pro Blog](https://pbspro.atlassian.net/wiki/pages/viewrecentblogposts.action?key=PBSPro)

### Community and Ways to Participate

PBS Professional is a community effort and there are a variety of ways to engage, from helping answer questions to benchmarking to developing new capabilities and tests.  We value being aggressively open and inclusive, but also aggressively respectful and professional.  See our [Code of Conduct](https://pbspro.atlassian.net/wiki/display/PBSPro/Code+of+Conduct).

The best place to start is by joining the community forum.  You may sign up or view the archives via:

* [Announcements](http://community.pbspro.org/c/announcements) -- important updates relevant to the entire PBS Pro community
* [Users/Site Admins](http://community.pbspro.org/c/users-site-administrators) -- general questions and discussions among end users (system admins, engineers, scientists)
* [Developers](http://community.pbspro.org/c/developers) -- technical discussions among developers

To dive in deeper and learn more about the project and what the community is up to, visit:

* [Contributor’s portal](https://pbspro.atlassian.net/wiki) -- includes roadmaps, processes, how to articles, coding standards, release notes, etc  (Uses Confluence)
* [Source code](https://github.com/PBSPro/pbspro) -- includes full source code and test framework (Uses Github)
* [Issue tracking system](https://pbspro.atlassian.net)  -- includes bugs and feature requests and status  (Uses JIRA)

PBS Professional is also integrated in the OpenHPC software stack. The mission of OpenHPC is to provide an integrated collection of HPC-centric components to provide full-featured HPC software stacks. OpenHPC is a Linux Foundation Collaborative Project.  Learn more at:

* [OpenHPC.community](http://openhpc.community)
* [The Linux Foundation](http://thelinuxfoundation.org)

### Our Vision:  One Scheduler for the whole HPC World

There is a huge opportunity to advance the state of the art in HPC scheduling by bringing the whole HPC world together, marrying public sector innovations with private sector enterprise know-how, and retargeting the effort wasted re-implementing the same old capabilities again and again towards pushing the outside of the envelope.  At the heart of this vision is fostering common standards (at least defacto standards like common software).  To this end, Altair has made a big investment by releasing PBS Pro under an Open Source license (to meet the needs of the public sector), while also continuing to offer PBS Pro under a commercial license (to meet the needs of the private sector).  One defacto standard that can work for the whole HPC community.  See Bill’s Open Letter to the HPC Community for more details.
 



A CycleCloud Project for starting a BeeGFS cluster in Azure. 

## Performance, Capacity and Cost

This project includes two scenarios; one configuration based on low-latency local NVMe SSDs and one based on Azure Premium Disks.

| Scenario | Local Disk | Persistent Disk |
|---|---|---|
| VM Size | Standard_L8s_v2 | Standard_D16s_v3 |
| Disk | Local NVMe SSD  | Premium Disk (2 x P30) |
| Capacity | 1.9 TB | 2.0 TB  | 
| Node Throughput | 400 MB/s | 384 MB/s  |
| Node IOPS | 40000 | 10000  |
| Node $/month | $455  | $830  |
| Node Data Durability | 3 9's | 11 9's | 

These configurations have been designed and tested to have maximal performance-cost. 
The Local Disk scenario will show better performance, particularly latency and IOPS, 
but durability of data will be relatively lower. The performance (and capacity) of a 
cluster can be estimated as the 
performance of a single node multiplied by the number of storage nodes
in the cluster. This has been tested up to 32 nodes.

If cost-per-storage is more important that cost-per-performance then you can increase the size 
or quantity of additional premium disks attached. 
Increasing the attached disks will increase the capacity, but not the performance.

Using the persistent disks, the data on the cluster will be recoverable 
even in the event of unplanned node termination or VM scheduled maintenance. This is not so when using local disks as the disk is only 
stored locally and will be lost when the VM is deallocated.

### Metadata

BeeGFS is not fully supporting extended file attributes. Applications that make
heavy use of _setxattr_ and _getxattr_ can expose instabilities in the beegfs-meta
daemon. Basic metadata attributes are efficiently used but one should avoid using
BeeGFS for applications using extended file attributes.

## Cluster Life-Cycle for Local Disk (default)

For storage cluster based on local SSDs storage is not preserved across VM 
deallocations and restarts.

* Create Cluster - creates storage VMs and disks
* Add Node - add additional node will increase size & resources of cluster
* Shutdown/Delete Node - delete VM and disks, data on disks will be destroyed.
* Terminate Cluster - delete all VMs and disks, all data destroyed.


## Cluster Life-Cycle for Premium Disk

It is possible to delete data and disks managed by CycleCloud in the CycleCloud UI.
This can result in data loss.  Here are the actions available in the CycleCloud management.

* Create Cluster - creates storage VMs and disks
* Add Node - add additional node will increase size & resources of cluster
* Shutdown/Deallocate Node - will suspend node but preserve disks.
* Start Deallocated Node - restore data and resources of deallocated node.
* Shutdown/Delete Node - delete VM and disks, data on disks will be destroyed.
* Terminate Cluster - delete all VMs and disks, all data destroyed.

It is possible to create a BeeGFS cluster, populate the data then when the workload
is finished, deallocate the VMs so that the cluster can be restarted.
This is helpful in controlling costs, because charges for the VMs will be suspended while
deallocated.  Keep in mind that disks will still accrue charges while the VMs are 
deallocated.

![CC VM Deallocate](/images/deallocate.png "Preserve data by deallocating VMs")

## Monitoring

This cluster includes a recipe for I/O monitoring in _Grafana_. By adding a _monitor_
node to the cluster a VM will start and host a monitoring UI. This service can be
accessed by _HTTP_ on port 3000 of the monitor host (username: `admin`, default_pw: `admin`).

![BeeGFS Monitoring](/images/grafana.png "Monitor IOPs, Througput, Requests")

# Contributing

This project welcomes contributions and suggestions.  Most contributions require you to agree to a
Contributor License Agreement (CLA) declaring that you have the right to, and actually do, grant us
the rights to use your contribution. For details, visit https://cla.microsoft.com.

When you submit a pull request, a CLA-bot will automatically determine whether you need to provide
a CLA and decorate the PR appropriately (e.g., label, comment). Simply follow the instructions
provided by the bot. You will only need to do this once across all repos using our CLA.

This project has adopted the [Microsoft Open Source Code of Conduct](https://opensource.microsoft.com/codeofconduct/).
For more information see the [Code of Conduct FAQ](https://opensource.microsoft.com/codeofconduct/faq/) or
contact [opencode@microsoft.com](mailto:opencode@microsoft.com) with any additional questions or comments.
