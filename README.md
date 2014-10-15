kubernetes-ui
=============

I done this kubernetes dashboard for demo purpose.

Dashboard features
------------------

-	connect to a kubernetes master thanks to the REST API
-	display the list of nodes
-	display the list of pods
-	display the cAdvisor report for each node.

How to start the dashboard
--------------------------

### In Dart mode (dev) ###

-	you to have the dart sdk install on your machine. (https://www.dartlang.org/)
-	also in chrome add the extension 'CORS': Allow-Control-Allow-Origin
-	then go to the project folder and run: pub serve
-	then use Dartium browser to access the dashboard. ``` dartium http://localhost:8080/dashboard.html ```

### In a Docker container ###

> **currently broken...** the current code is not compliant with the last dart2js (SDK 1.6)

``` docker build --tag='kubernetesui' . ```

``` docker run -d -p 8080:80 --name="kubernetesui" kubernetesui ```

``` chrome http://localhost:8080/ ```


How to use the Dashboard
------------------------

- you should have a kubernetes cluster up and running (you can use the vagrant demo installation provided here [link](https://github.com/GoogleCloudPlatform/kubernetes/blob/master/docs/getting-started-guides/vagrant.md)  )
- put the IP address of your kubernetes master Node
- You should start to see some informations about your kubernetes cluster

> This Dashbord is a passive dashbord: only retrieving data, but not pushing instructions!
