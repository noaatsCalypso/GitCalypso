
import com.calypso.tk.util.ConnectionUtil
import com.calypso.tk.service.DSConnection

def ers_clean(host) {

	SEPARATOR="/";
	appsToKill = []

	clientList = ds.getRemoteAccess().getConnectedClients();
	if (clientList != null) {
            for(client in clientList){
		idx = client.indexOf(SEPARATOR);
		lastidx = client.lastIndexOf(SEPARATOR);
		if(idx < 0 || lastidx < 0 || idx == lastidx) {
			continue;
		}
		hostName = client.substring(idx + 1, lastidx);
		user = client.substring(0, idx);
		app = client.substring(lastidx + 1);
	        if ((app.startsWith("RiskEngine") || app=="ERSLimitEngine") && hostName.startsWith(host)) {
	        	appsToKill << client
		}
	    }
	}
	for (s in appsToKill) {
		ds.getRemoteAccess().stopClient(s);
	}	
}

def envName = "fangorn"
def hostName = "fangorn"

ds = ConnectionUtil.connect("calypso_user","calypso","ers_script",envName)

ers_clean(hostName)

ds.disconnect()
