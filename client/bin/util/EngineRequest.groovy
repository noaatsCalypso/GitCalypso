
import com.calypso.tk.util.ConnectionUtil
import com.calypso.tk.service.DSConnection
import com.calypso.tk.event.PSEventEngineRequest

def ers_clean(host, config, request) {
		ebEvent = new PSEventEngineRequest()
		ebEvent.setType(request);
		ebEvent.setMessage("RiskEngineWorker_" + host +"_" + config);
		ds.getRemoteTrade().saveAndPublish(ebEvent)
}

def ers_broker(request) {
		ebEvent = new PSEventEngineRequest()
		ebEvent.setType(request);
		ebEvent.setMessage("RiskEngine");
		ds.getRemoteTrade().saveAndPublish(ebEvent)
}

env = "Rel800"

ds = ConnectionUtil.connect("calypso_user","calypso","ers_scripts",env)

config = null
if (args.length>2)
   config = args[2]

int request = Integer.parseInt(args[1])

if (args[0]=="ENGINE") {
	println "Stopping ERS engine"
	ers_clean("FRANK", config, request)
}
else {
	println "Stopping ERS broker"
        ers_broker(request)
}        
ds.disconnect()

