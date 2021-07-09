
import com.calypso.tk.refdata.CurrencyPair;
import com.calypso.tk.service.DSConnection;
import com.calypso.tk.service.RemoteMarketData;
import com.calypso.tk.util.ConnectionUtil;
import com.calypso.tk.util.CurrencyUtil;
import com.calypso.tk.core.JDate;
import com.calypso.tk.core.JDatetime;
import com.calypso.tk.marketdata.PricingEnv;
import com.calypso.tk.marketdata.QuoteSet;
import com.calypso.tk.marketdata.QuoteValue;
import com.calypso.tk.core.Util
import com.calypso.tk.core.Holiday;
import java.text.SimpleDateFormat

def save_quote(md, qs, valueDate) {

		
		save_one_quote(md, qs, valueDate, "FX.EUR.USD", 1.2)
		save_one_quote(md, qs, valueDate, "FX.GBP.USD", 1.8)
		save_one_quote(md, qs, valueDate, "FX.USD.JPY", 111.0)

//		qv = qs.getFXQuote(cp, "", new JDate(2005, 12, 1)))
		
	}

def save_one_quote(md, qs, jd, name, d) {
		double dv = d
	   	q = new QuoteValue()
        	q.setName(name)
        	q.setQuoteType("Price")
        	q.setDate(jd)
        	q.setUser(DSConnection.getDefault().getUser())
		q.setBid(dv)
		q.setAsk(dv)
		q.setOpen(dv)
		q.setClose(dv)
        	q.setQuoteSetName(qs.getName())
        	q.setVersion(0)
        	q.setIsEstimatedB(false)
        	q.setKnownDate(jd)
        	q.setSourceName(null)
		qs.putQuote(q)
		md.save(q)
}

def vd
def hols
def date
def sdf 
date = JDate.getNow()
sdf = new SimpleDateFormat("yyyy-MM-dd")

ds = ConnectionUtil.connect("calypso_user","calypso","JAPP",args[0])

md =  ds.getRemoteMarketData()
pricingEnv = md.getPricingEnv("default" ,new JDatetime())
qs = pricingEnv.getQuoteSet();

hols =Util.string2Vector("LON")
for (i in 1..60) {
	vd =Holiday.getCurrent().addBusinessDays(date,hols, -i)
	println sdf.format(vd.getDate())
	save_quote(md, qs, vd)
}


ds.disconnect()

