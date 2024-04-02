# Ansible playbooks

## Executive Summary
As part of our tasks, we aimed to create virtual machines (VMs) to facilitate the work of developers. The following needs were mentioned:

- Testing applications before requesting IT to install the software on our personal laptops
- Facilitating the work of certain developers (e.g., having CLIs already installed and configured)
To set up virtual machines in the cloud, using Ansible was very useful to enable scaling in case we need more VMs in the future.

## Glossary

**Ansible:** Ansible is an open-source software tool for IT automation. It automates the provisioning, configuration, and deployment of servers and applications. Ansible is agentless, meaning it does not require any software to be installed on the machines it manages. It uses SSH to connect to machines and execute commands.

**Virtual machine (VM):** A virtual machine is a software that simulates a complete computer, with its own operating system and applications, and runs on a physical computer. In short, it is a virtual computer inside a physical computer.

## Diagrams

![Ansible](img/ansible.svg)

## References

[Kubernetes](https://kubernetes.io/docs/concepts/overview/)

[Pod](https://kubernetes.io/docs/concepts/workloads/pods/)

[HA](https://www.techtarget.com/searchdatacenter/definition/high-availability)

[Load balancer](https://www.nginx.com/resources/glossary/load-balancing/)
