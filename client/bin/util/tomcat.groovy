class Build {
        def ant = new AntBuilder()

	def base_dir = "."
	def src_dir = "${base_dir}/src"
	def lib_dir = "${base_dir}"
	def build_dir = "${base_dir}/build"
	def dist_dir = "${base_dir}/dist"
	def file_name = ""

	def classpath = ant.path {
			fileset(dir: "${lib_dir}")	{
				include(name: "*.jar")
			}
			pathelement(path: "${build_dir}")
		}


	def clean() {
		ant.delete(dir: "${build_dir}")
		ant.delete(dir: "${dist_dir}")
	}

	def build() {
		ant.mkdir(dir: "${build_dir}")
		ant.javac(destdir: "${build_dir}", srcdir: "${src_dir}", classpath: "${classpath}")		
	}


	def jar() {
		clean()
		build()
		ant.mkdir(dir: "${dist_dir}")
		ant.jar(destfile: "${dist_dir}/${file_name}.jar", basedir: "${build_dir}")
	}
	
	def dumpProperties() {
		
		println "Base Dir ${base_dir}"
		println "Source Dir ${src_dir}"
		println "Lib Dir ${lib_dir}"
		println "Build Dir ${build_dir}"
		println "Dist Dir ${dist_dir}"
		println "File Name ${file_name}"
		
	}
	
	static void main(args) {
		def b = new Build()
		b.run(args)
	}


	def void run(args) {
		if ( args.size() > 0 ) { 
			invokeMethod(args[0], null )
		}
		else {
			build()
		}	
	}
	
	
	//server part
	
	// def server_script = base_dir+"/tomcat.groovy"
	def server = initServer()
	def initServer()
	{
	
	//	Class clazz = new GroovyClassLoader().parseClass(new java.io.File(server_script))
	//	GroovyObject obj = (GroovyObject) clazz.newInstance()
		def obj = new Tomcat()
		obj.ant = ant
		return obj	
	}
	
	def start()
	{			
		server.start()
	}
	
	def stop()
	{	
		server.stop()
	}
	
	def reload()
	{
		server.reload()
	}
	
	
	
}

class Tomcat
{

def ant = null;

def url = "http://localhost:8080/manager"
def username = "tomcat"
def password = "tomcat"
def path = "/risk-services"

def start()
{
	ant.taskdef(name: "start", classname: "org.apache.catalina.ant.StartTask")
	ant.start(url: "${url}", username: "${username}", password: "${password}", path: "${path}")	
}

def stop()
{
	ant.taskdef(name: "stop", classname: "org.apache.catalina.ant.StopTask")
	ant.stop(url: "${url}", username: "${username}", password: "${password}", path: "${path}")	
	
}
def reload()
{
	ant.taskdef(name: "reload", classname: "org.apache.catalina.ant.ReloadTask")
	ant.reload(url: "${url}", username: "${username}", password: "${password}", path: "${path}")	
	
}
}

