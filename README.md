# WIP - docker-jmeter

TODO: Complete the Readme
TODO: Complete the Helm Chart and Example

A JMeter Docker Container for Master/Slave load testing

## Using the Container

### Configuring the Containers

**Environment Variables:**

* JMETER_MODE - master or worker
* JMETER_PROPERTIES - path in the container to the JMeter properties file
* JMETER_LOG - path in the container to the JMeter log
* JMETER_LOADTEST - path in the container to the JMX test file (master)
* JMETER_RESULTS - path in the container for the test results file (master), usually with a '.jtl' extension

**Volumes:**

You'll need to setup one or more volume mounts to cover the locations of the following files from the host running
the `master` instance

* the properties file
* the log file
* the test `.jmx` file
* the rest `.jtl` results file

**Properties:**

You can override or supply any values in the properties file required to run your test. The only requirement is
that you set the `hosts` value to the list of **IPS** used by the **worker** container instances. The format is
a comma separated list of IPs.

### Running a Worker

### Running a Master

### Post Test Data Collection and Review

## Running with Kubernetes

Kubernetes can simplify the process of running load tests without requiring the creation of new hosts to run your tests.
A Kubernetes cluster can take a specification for the containers you want to run and spread it across a cluster and even
scale new cluster node instances if necessary.

## The Loadtest Framework with Kubernetes Helm

[Helm](https://github.com/kubernetes/helm) provides a template approach to Kubernetes deployments. This project provides a
Helm Chart that will deploy a JMeter master and a number of workers with a test that is loaded from a `git` repository.

