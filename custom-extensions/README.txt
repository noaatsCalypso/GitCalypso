This project will create a development workspace for:

Modifying resources like templates, property files, etc
* Adding third-party libraries required by Calypso code (ex: market data provider jars) or your custom code
* Developing and patching Calypso extensions like dataserver services, engines, pricers, handlers, etc.
* The bld and bld.bat files in this location can be used to build the jars for each project and generate the IDE files.

To develop Calypso extensions, add your custom code to the appropriate project within 'custom-projects'.

To create the eclipse files, run:

bld eclipse

This will create the Eclipse .project and .classpath files for all the projects.

You can run the dataserver and engineserver within Eclipse 
by deploying the dataserver and engineserver projects into JBoss.

To deploy your custom code, run

bld deploy

The command will compile, package and patch the custom code into the installation.
