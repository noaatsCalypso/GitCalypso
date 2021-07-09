
import com.calypso.tk.refdata.CurrencyPair;
import com.calypso.tk.service.DSConnection;
import com.calypso.tk.service.RemoteMarketData;
import com.calypso.tk.util.ConnectionUtil;
import com.calypso.tk.util.CurrencyUtil;
import com.calypso.tk.core.JDate;
import com.calypso.tk.core.JDatetime;
import com.calypso.tk.marketdata.PricingEnv;
import com.calypso.tk.marketdata.QuoteSet;
import com.calypso.tk.marketdata.CurveZero;
import com.calypso.tk.marketdata.CurveUnderlying;
import com.calypso.tk.marketdata.CurveUnderlyingMoneyMarket;
import com.calypso.tk.marketdata.CurveUnderlyingSwap;
import com.calypso.tk.core.DateRoll;
import com.calypso.tk.core.DayCount;
import com.calypso.tk.core.Tenor;
import com.calypso.tk.core.Util;
import com.calypso.tk.core.Frequency;
import com.calypso.tk.service.LocalCache;
import com.calypso.tk.core.PeriodRule;


def createCurve(list, name, currency, index, tenor, holiday) {

        
	v = new Vector()
	vStr = new Vector()
	md =  ds.getRemoteMarketData()
	swapUnderlyings=md.getCurveUnderlyings("CurveUnderlyingSwap",currency)
	mmUnderlyings=md.getCurveUnderlyings("CurveUnderlyingMoneyMarket",currency)
	
	for (i in 0..swapUnderlyings.size()-1) {
		cu = swapUnderlyings.get(i)
		if (list.contains(cu.toString())) {
			println cu
			if (!vStr.contains(cu.toString())) {
			v.add((CurveUnderlying)cu)
			vStr.add(cu.toString())
			}
		}
	}	
	for (i in 0..mmUnderlyings.size()-1) {
		cu = mmUnderlyings.get(i)
		if (list.contains(cu.toString())) {
			println cu
			if (!vStr.contains(cu.toString())) {
			v.add((CurveUnderlying)cu)
			vStr.add(cu.toString())
			}
		}
	}
	
	
 	curv1 = new CurveZero()
	curv1.setUnderlyings(v)
	curv1.setCurrency(currency)
	curv1.setDayCount(new DayCount("ACT/360"))
	curv1.setFrequency(new Frequency("QTR"))
	curv1.setHolidays(Util.string2Vector(holiday))
	curv1.setIndex(index)
	curv1.setIndexTenor(new Tenor(tenor))
	curv1.setInterpolatorName("InterpolatorLogLinear")
	curv1.setGeneratorName("BootStrap")
	curv1.setPricingEnvName("default")
	jdt = new JDatetime()
	curv1.setDatetime(jdt)
	curv1.setName(name)
	curv1.setInstance(2)

	md.save(curv1)
}

def setCurvePoints(vList, currency, name) {

	md =  ds.getRemoteMarketData()
	curve2 = md.getZeroCurve(currency,name)

	quotes = new Hashtable()

        cus = curve2.getUnderlyings();
        
	for (i in 0..cus.size()-1) {
	  println cus.get(i).getId()
	  quotes.put(cus.elementAt(i).getId(), vList[i])
	}


curve2.setQuoteValues(quotes)
md.save(curve2)

}
ds = ConnectionUtil.connect("calypso_user","calypso","ers_scripts",args[0])

def EURList = ["EUR/EURIBOR/1M/T3750",
              "EUR/EURIBOR/2M/T3750",
              "EUR/EURIBOR/3M/T3750",
              "EUR/EURIBOR/6M/T3750",
              "EUR/EURIBOR/9M/T3750",
              "EUR/EURIBOR/1Y/T3750",
	      "Swap/EUR/2Y/EURIBOR/3M/T3750/6M",
             "Swap/EUR/3Y/EURIBOR/3M/T3750/6M",
             "Swap/EUR/5Y/EURIBOR/3M/T3750/6M",
             "Swap/EUR/7Y/EURIBOR/3M/T3750/6M",
             "Swap/EUR/10Y/EURIBOR/3M/T3750/6M",
             "Swap/EUR/15Y/EURIBOR/3M/T3750/6M",
             "Swap/EUR/20Y/EURIBOR/3M/T3750/6M",
             "Swap/EUR/25Y/EURIBOR/3M/T3750/6M",
             "Swap/EUR/30Y/EURIBOR/3M/T3750/6M",
             "Swap/EUR/40Y/EURIBOR/3M/T3750/6M"
             ]
def USDList = [
              "USD/LIBOR/ON/T3750",
	      "USD/LIBOR/TON/T3750",
              "USD/LIBOR/1W/T3750",
              "USD/LIBOR/1M/T3750",
              "USD/LIBOR/2M/T3750",
              "USD/LIBOR/3M/T3750",
              "USD/LIBOR/6M/T3750",
              "USD/LIBOR/9M/T3750",
              "USD/LIBOR/1Y/T3750",
	      "Swap/USD/2Y/LIBOR/6M/T3750/6M",
             "Swap/USD/3Y/LIBOR/6M/T3750/6M",
             "Swap/USD/4Y/LIBOR/6M/T3750/6M",
             "Swap/USD/5Y/LIBOR/6M/T3750/6M",
             "Swap/USD/6Y/LIBOR/6M/T3750/6M",
             "Swap/USD/7Y/LIBOR/6M/T3750/6M",
             "Swap/USD/8Y/LIBOR/6M/T3750/6M",
             "Swap/USD/9Y/LIBOR/6M/T3750/6M",
             "Swap/USD/10Y/LIBOR/6M/T3750/6M",
             "Swap/USD/11Y/LIBOR/6M/T3750/6M",
             "Swap/USD/12Y/LIBOR/6M/T3750/6M",
             "Swap/USD/15Y/LIBOR/6M/T3750/6M",
             "Swap/USD/17Y/LIBOR/6M/T3750/6M",
             "Swap/USD/20Y/LIBOR/6M/T3750/6M",
             "Swap/USD/25Y/LIBOR/6M/T3750/6M",
             "Swap/USD/30Y/LIBOR/6M/T3750/6M"
             ]
def ZARList = [
              "ZAR/LIBOR/ON/T3750",
              "ZAR/LIBOR/1M/T3750",
              "ZAR/LIBOR/2M/T3750",
              "ZAR/LIBOR/3M/T3750",
              "ZAR/LIBOR/4M/T3750",
              "ZAR/LIBOR/5M/T3750",
              "ZAR/LIBOR/6M/T3750",
              "ZAR/LIBOR/9M/T3750",
              "ZAR/LIBOR/1Y/T3750",
              "ZAR/LIBOR/18M/T3750",
	      "Swap/ZAR/2Y/LIBOR/3M/T3750/6M",
             "Swap/ZAR/3Y/LIBOR/3M/T3750/6M",
             "Swap/ZAR/4Y/LIBOR/3M/T3750/6M",
             "Swap/ZAR/5Y/LIBOR/3M/T3750/6M",
             "Swap/ZAR/6Y/LIBOR/3M/T3750/6M",
             "Swap/ZAR/7Y/LIBOR/3M/T3750/6M",
             "Swap/ZAR/8Y/LIBOR/3M/T3750/6M",
             "Swap/ZAR/9Y/LIBOR/3M/T3750/6M",
             "Swap/ZAR/10Y/LIBOR/3M/T3750/6M",
             "Swap/ZAR/12Y/LIBOR/3M/T3750/6M",
             "Swap/ZAR/15Y/LIBOR/3M/T3750/6M",
             "Swap/ZAR/17Y/LIBOR/3M/T3750/6M",
             "Swap/ZAR/20Y/LIBOR/3M/T3750/6M",
             "Swap/ZAR/25Y/LIBOR/3M/T3750/6M",
             "Swap/ZAR/30Y/LIBOR/3M/T3750/6M"
             ]


def JPYList = [
              "JPY/LIBOR/ON/T3750",
              "JPY/LIBOR/1M/T3750",
              "JPY/LIBOR/2M/T3750",
              "JPY/LIBOR/3M/T3750",
              "JPY/LIBOR/4M/T3750",
              "JPY/LIBOR/5M/T3750",
              "JPY/LIBOR/6M/T3750",
              "JPY/LIBOR/9M/T3750",
              "JPY/LIBOR/1Y/T3750",
              "JPY/LIBOR/18M/T3750",
	      "Swap/JPY/2Y/LIBOR/3M/T3750/6M",
             "Swap/JPY/3Y/LIBOR/3M/T3750/6M",
             "Swap/JPY/4Y/LIBOR/3M/T3750/6M",
             "Swap/JPY/5Y/LIBOR/3M/T3750/6M",
             "Swap/JPY/6Y/LIBOR/3M/T3750/6M",
             "Swap/JPY/7Y/LIBOR/3M/T3750/6M",
             "Swap/JPY/8Y/LIBOR/3M/T3750/6M",
             "Swap/JPY/9Y/LIBOR/3M/T3750/6M",
             "Swap/JPY/10Y/LIBOR/3M/T3750/6M",
             "Swap/JPY/12Y/LIBOR/3M/T3750/6M",
             "Swap/JPY/15Y/LIBOR/3M/T3750/6M",
             "Swap/JPY/17Y/LIBOR/3M/T3750/6M",
             "Swap/JPY/20Y/LIBOR/3M/T3750/6M",
             "Swap/JPY/25Y/LIBOR/3M/T3750/6M",
             "Swap/JPY/30Y/LIBOR/3M/T3750/6M"
             ]
 
 
// def EURquotes = [2.6,2.6,2.7,2.9,3,3.1,3.3,3.45,3.55,3.64,3.85,4,4.1,4.1,4.1,4.1]

//createCurve(USDList,"varUsd1", "USD", "LIBOR", "3M", "NYC")
//createCurve(EURList,"varEur1", "EUR", "EURIBOR", "3M", "EUR")
//createCurve(ZARList,"varZar1", "ZAR", "LIBOR", "3M", "LON")
createCurve(JPYList,"varJpy1", "JPY", "LIBOR", "3M", "TOK")

//setCurvePoints(EURquotes, "EUR", "EURZeroCurve1") 
ds.disconnect()

