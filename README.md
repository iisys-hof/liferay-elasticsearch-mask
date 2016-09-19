# Facet Search for Elasticsearch (Liferay 7 Portlet)

Configuration:
* adjust URLs in /src/main/resources/META-INF/resources/js/es-facetsearch.js
* adjust URLs in /src/main/resources/META-INF/resources/html/view.jsp (search for 127.0.0.1)

This is a facet search mask for elastic search, supporting the following facets:
* filetypes
* created time
* author
* system (portal, documents, emails, persons, activities)

The mask is implemented in Javascript as a **Liferay 7** Module Portlet, using [Bootstrap](http://getbootstrap.com/) and [handelbars.js templates](http://handlebarsjs.com/) for layouting.

Building and Installing:

* Import into Liferay IDE as Liferay Module or possibly Gradle Project
* Execute build from the eclipse view "gradle tasks" for the root project
* this will generate a deployable jar file in build/libs/
* deploy the jar in liferay