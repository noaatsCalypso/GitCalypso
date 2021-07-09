
import com.calypso.tk.util.ConnectionUtil
import com.calypso.tk.service.DSConnection
import com.calypso.tk.event.PSEventEngineRequest

def ers_clean(host) {
		ebEvent = new PSEventEngineRequest()
		ebEvent.setType(PSEventEngineRequest.REQUEST_GC);
		ebEvent.setMessage("RiskEngineWorker_" + host +"_test");
		ds.getRemoteTrade().saveAndPublish(ebEvent)
}
	

ds = ConnectionUtil.connect("calypso_user","calypso","JAPP",args[1])

ers_clean(args[0])

ds.disconnect()

