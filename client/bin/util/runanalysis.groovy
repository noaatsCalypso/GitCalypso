
import com.calypso.tk.util.ConnectionUtil
import com.calypso.tk.service.DSConnection
import com.calypso.tk.event.PSEventRiskRequest

def ers_run(portfolio,analysis,pricingEnv, parameterName,valueDate) {
		request = new PSEventRiskRequest.RiskRequest()
		request.setPortfolio(portfolio)
		request.setAnalysis(analysis)
		request.setPricingEnv(pricingEnv)
		if (valueDate!=null)
			request.setValueDate(valueDate)
		p= new Properties()
		p.put("CACHING", "false")
		if (parameterName!=null && parameterName.length()>0) {
			p.put("PARAM_NAME", parameterName)	
		}
		request.setParameters(p)
		allRequests << request
}

env = "Rel800"	
pricingEnv = "default"

ds = ConnectionUtil.connect("calypso_user","calypso","ers_script",env)
ebEvent = new PSEventRiskRequest("NEW")
allRequests = []

parameterName = (args.length > 2)?args[2]:null
valueDate =(args.length > 3)?args[3]:null

ers_run(args[0],args[1], pricingEnv, parameterName, valueDate)

ebEvent._request = allRequests.toArray()
ds.getRemoteTrade().saveAndPublish(ebEvent)
ds.disconnect()

