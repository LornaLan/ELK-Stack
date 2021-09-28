## Automated ELK Stack Deployment

The files in this repository were used to configure the network depicted below.

![Structure of the ELK Stack Cloud Network](images/cloud-structure.png)

The files in this repository have been tested and used to generate a live ELK deployment on Microsoft Azure. The Ansible scripts to install all the required containers for ELK stack and DVWA webservers are under folder `yml-install`. Some other Ansible scripts for running tests and managing the deployed virtual machines (VMs) are under folder `yml-tests`. There are also some shell scripts used for testing VM setups, which are stored under `shell-scripts`. Images recording the test results are under the `images` folder. 

This document contains the following details:

[TOC]




### Description of the Topology

The main purpose of this network is to expose a load-balanced and monitored instance of DVWA, the D*mn Vulnerable Web Application. This website is accessible by the public at http://40.88.33.102/setup.php when the containers are running.

The load balancer ensures that the application will be highly available, in addition to restricting unauthorized access to the network. It acts as a public facing interface between the private DVWA servers and the internet. 

Integrating an ELK server allows users to easily monitor the vulnerable VMs for changes to the docker metrics and system logs. More specifically, we used the Filebeat and Metricbeat applications from ELK.

- [Filebeat](https://www.elastic.co/beats/filebeat) is a lightweight system log monitoring system integrated with the Elastic Stack. It processes all the raw system log files in a queue, aggregates and parses them, and ships the result to Kibana for visualization. A typical Filebeat system dashboard is shown below, where it displays all the logs for system operations, sudo commands, ssh logins and users and groups creation or management.

  ![Filebeat Dashboard](images/system-logs-dashboard.jpg)

- [Metricbeat](https://www.elastic.co/beats/metricbeat) collects metrics about the deployed systems and metrics and sends them to Kibana for visualization. It displays many metrics across your cloud VMs, such as CPU, memory and file system usage, disk and network IO statistics. A typical Metricbeat dashboard is shown below:

  ![Metricbeat Dashboard](images/metricbeat-docker-dashboard.jpg)

The configuration details of each machine may be found below.

| Name         | Function                                       | IP Address (Public)          | IP Address (Private) | Operating System          | Machine Hardware            |
| ------------ | ---------------------------------------------- | ---------------------------- | -------------------- | ------------------------- | --------------------------- |
| jumpHost     | Only Gateway to configure the internal network | 20.102.104.146               | 10.0.0.4             | Linux - Ubuntu 20.04 gen2 | 1 vCPUs, 1GB RAM, 30GB Disk |
| elkHost      | Base machine for running the ELK stack         | 20.48.224.215                | 10.1.7.4             | Linux - Ubuntu 20.04 gen1 | 2 vCPUs, 8GB RAM, 30GB Disk |
| Web{1, 2, 3} | Redundant servers for running DVWA             | 40.88.33.102 (Load Balancer) | 10.0.0.{5, 6, 7}     | Linux - Ubuntu 20.04 gen1 | 1 vCPUs, 2GB RAM, 30GB Disk |
|              |                                                |                              |                      |                           |                             |

### Access Policies

The machines on the internal network are not exposed to the public Internet. They are protected by a firewall, allowing access only through the expected service ports.

Only the jumpHost machine can accept connections from the Internet. Access to this machine is only allowed via SSH on port 22 from my home computer's IP address. The connection is also authenticated by RSA asymmetric key pairs, with the jumpHost only holding the public key generated from my home desktop via `ssh-gen`. 

Machines within the network can only be accessed by the Ansible Docker container running on the jumpHost. All the Ansible services and setups are run from that docker container, and the private DVWA webservers and ELK host machine hold the public generated from that docker container only. 

The Kibana visualization page is also restricted to be accessed from my home IP address only. To accomplish this, the firewall rule "allow TCP traffic to port 5601 of the ELK host machine from this IP" is added, while another lower-priority rule by default rejects all other traffics. The Kibana interface can be access via http://20.48.224.215:5601/app/kibana in a web browser.

A summary of the access policies in place can be found in the table below.

| Name          | Publicly Accessible | Allowed IP Addresses | Protocol @ Port |
| ------------- | ------------------- | -------------------- | --------------- |
| jumpHost      | Yes                 | my home IP           | SSH @ 22        |
| elkHost       | Yes                 | my home IP           | Kibana @ 5601   |
| web{1, 2, 3}  | No                  | N/A                  | N/A             |
| Load Balancer | Yes                 | any                  | HTTP @ 80       |
|               |                     |                      |                 |

### Elk Configuration

#### Beats Setup

Ansible was used to automate configuration of the ELK machine. No configuration was performed manually, which reduces human input error, and allows us to spin up similar machines with ease.

To set up the ELK host machine, the Ansible playbook script `install-elk.yml` is run via command `ansible-playbook install-elk.yml`. The script installs Docker module and ELK container on `elkHost` machine. The allocated memory for the ELK application is increased to ensure the smooth running of the docker container, and they are persistent through reboots.

The following screenshot displays the expected result of successfully configuring the ELK instance. After running the `docker ps -a` command on your ELK host, you should see the `sebp/elk:761` running, with the port mappings as configured.


![Docker PS Success Config](images/elk-docker-deployed.jpg)

#### Machines Being Monitored
This ELK server is configured to monitor the three DVWA webservers (`web{1, 2, 3}` as listed before). The Filebeat and Metricbeat packages are installed on these individual machine via Ansible playbook scripts.

### Using Ansible Playbooks

A few other playbook scripts to set up the network structure, under the `yml-install` folder, are described below:

- `dockerweb.yml`: install Docker module and launch the DVWA web container on `web{1, 2, 3}` machines. Docker and DVWA web containers will always restart after each machine reboot.
- `filebeat/metricbeat-playbook.yml`: install the Filebeat/Metricbeat package and configure them according to Kibana instructions. The `filebeat/metricbeat services` are always started at reboot, to prevent the monitoring data stream in Kibana from being interrupted.  

In order to use the playbook, you will need to have an Ansible control node already configured. Assuming you have such a control node provisioned: 

SSH into the control node and follow the steps below:
- Copy the _____ file to _____.
- Update the _____ file to include...
- Run the playbook, and navigate to ____ to check that the installation worked as expected.

_TODO: Answer the following questions to fill in the blanks:_
- _Which file is the playbook? Where do you copy it?_
- _Which file do you update to make Ansible run the playbook on a specific machine? How do I specify which machine to install the ELK server on versus which to install Filebeat on?_
- _Which URL do you navigate to in order to check that the ELK server is running?

_As a **Bonus**, provide the specific commands the user will need to run to download the playbook, update the files, etc._

### Acknowledgement

I would like to thank the Teaching team from the Trilogy, 2U Inc. Cybersecurity Bootcamp from University of Toronto (2021-June cohort), for teaching us the basics of networking and web applications, providing us the starter scripts, and helping us troubleshoot along the way.
