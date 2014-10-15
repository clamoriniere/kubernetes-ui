kubernetes-ui
=============

I done this kubernetes dashboard for demo purpose.

Dashboard features
------------------

-	connect to a kubernetes master thanks to the REST API
-	display the list of nodes
-	display the list of pods
-	display the cAdvisor report for each node.

How to start the dashboard in Dart mode (dev)
---------------------------------------------

-	you to have the dart sdk install on your machine. (https://www.dartlang.org/)
-	also in chrome add the extension 'CORS': Allow-Control-Allow-Origin
-	then go to the project folder and run: pub serve
-	then use Dartium browser to access the dashboard. ''' dartium http://localhost:8080/dashboard.html '''

How to start Serve the dashboard in a Docker container
------------------------------------------------------

currently broken... the current code is not compliant with the last dart2js (SDK 1.6)

''' docker build --tag='kubernetesui' . '''

''' docker run -d -p 8080:80 --name="kubernetesui" kubernetesui '''

''' chrome http://localhost:8080/ '''
