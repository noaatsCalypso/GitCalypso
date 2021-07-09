
import com.calypso.tk.refdata.CurrencyPair;
import com.calypso.tk.service.DSConnection;
import com.calypso.tk.service.RemoteMarketData;
import com.calypso.tk.util.ConnectionUtil;
import com.calypso.tk.util.CurrencyUtil;
import com.calypso.tk.core.JDate;
import com.calypso.tk.core.JDatetime;
import com.calypso.tk.marketdata.PricingEnv;
import com.calypso.tk.marketdata.QuoteSet;
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

def save_cash() {

	md =  ds.getRemoteMarketData()

	createMMUnderlying(md, "USD", "9M", 2, "LIBOR", "ACT/360", "MOD_FOLLOW", "LON,NYC")
	createMMUnderlying(md, "USD", "1Y", 2, "LIBOR" ,"ACT/360", "MOD_FOLLOW", "LON,NYC")

	createMMUnderlying(md, "EUR", "1M", 1, "EURIBOR" ,"ACT/360", "MOD_FOLLOW", "EUR")
	createMMUnderlying(md, "EUR", "2M", 1, "EURIBOR" ,"ACT/360", "MOD_FOLLOW", "EUR")
	createMMUnderlying(md, "EUR", "3M", 1, "EURIBOR" ,"ACT/360", "MOD_FOLLOW", "EUR")
	createMMUnderlying(md, "EUR", "6M", 1, "EURIBOR" ,"ACT/360", "MOD_FOLLOW", "EUR")
	createMMUnderlying(md, "EUR", "9M", 1, "EURIBOR" ,"ACT/360", "MOD_FOLLOW", "EUR")
	createMMUnderlying(md, "EUR", "1Y", 1, "EURIBOR" ,"ACT/360", "MOD_FOLLOW", "EUR")

	createMMUnderlying(md, "ZAR", "1D", 0, "LIBOR" ,"ACT/360", "FOLLOWING", "LON")
	createMMUnderlying(md, "ZAR", "1M", 0, "LIBOR" ,"ACT/360", "FOLLOWING", "LON")
	createMMUnderlying(md, "ZAR", "2M", 0, "LIBOR" ,"ACT/360", "FOLLOWING", "LON")
	createMMUnderlying(md, "ZAR", "3M", 0, "LIBOR" ,"ACT/360", "FOLLOWING", "LON")
	createMMUnderlying(md, "ZAR", "4M", 0, "LIBOR" ,"ACT/360", "FOLLOWING", "LON")
	createMMUnderlying(md, "ZAR", "5M", 0, "LIBOR" ,"ACT/360", "FOLLOWING", "LON")
	createMMUnderlying(md, "ZAR", "6M", 0, "LIBOR" ,"ACT/360", "FOLLOWING", "LON")
	createMMUnderlying(md, "ZAR", "9M", 0, "LIBOR" ,"ACT/360", "FOLLOWING", "LON")
	createMMUnderlying(md, "ZAR", "1Y", 0, "LIBOR" ,"ACT/360", "FOLLOWING", "LON")
	createMMUnderlying(md, "ZAR", "18M", 0, "LIBOR" ,"ACT/360", "FOLLOWING", "LON")

	createMMUnderlying(md, "JPY", "1D", 0, "LIBOR" ,"ACT/360", "FOLLOWING", "TOK")
	createMMUnderlying(md, "JPY", "1M", 0, "LIBOR" ,"ACT/360", "FOLLOWING", "TOK")
	createMMUnderlying(md, "JPY", "2M", 0, "LIBOR" ,"ACT/360", "FOLLOWING", "TOK")
	createMMUnderlying(md, "JPY", "3M", 0, "LIBOR" ,"ACT/360", "FOLLOWING", "TOK")
	createMMUnderlying(md, "JPY", "4M", 0, "LIBOR" ,"ACT/360", "FOLLOWING", "TOK")
	createMMUnderlying(md, "JPY", "5M", 0, "LIBOR" ,"ACT/360", "FOLLOWING", "TOK")
	createMMUnderlying(md, "JPY", "6M", 0, "LIBOR" ,"ACT/360", "FOLLOWING", "TOK")
	createMMUnderlying(md, "JPY", "9M", 0, "LIBOR" ,"ACT/360", "FOLLOWING", "TOK")
	createMMUnderlying(md, "JPY", "1Y", 0, "LIBOR" ,"ACT/360", "FOLLOWING", "TOK")
	createMMUnderlying(md, "JPY", "18M", 0, "LIBOR" ,"ACT/360", "FOLLOWING", "TOK")
}

def save_swap() {

	md =  ds.getRemoteMarketData()
	
	createSwapUnderlying(md, "USD", "LIBOR", "6M", "4Y", "NYC")
	createSwapUnderlying(md, "USD", "LIBOR", "6M", "6Y", "NYC")
	createSwapUnderlying(md, "USD", "LIBOR", "6M", "8Y", "NYC")
	createSwapUnderlying(md, "USD", "LIBOR", "6M", "9Y", "NYC")
	createSwapUnderlying(md, "USD", "LIBOR", "6M", "11Y", "NYC")
	createSwapUnderlying(md, "USD", "LIBOR", "6M", "12Y", "NYC")
	createSwapUnderlying(md, "USD", "LIBOR", "6M", "15Y", "NYC")
	createSwapUnderlying(md, "USD", "LIBOR", "6M", "17Y", "NYC")
	createSwapUnderlying(md, "USD", "LIBOR", "6M", "20Y", "NYC")
	createSwapUnderlying(md, "USD", "LIBOR", "6M", "25Y", "NYC")
	createSwapUnderlying(md, "USD", "LIBOR", "6M", "30Y", "NYC")


	createSwapUnderlying(md, "EUR", "EURIBOR", "3M", "2Y", "EUR")
	createSwapUnderlying(md, "EUR", "EURIBOR", "3M", "3Y", "EUR")
	createSwapUnderlying(md, "EUR", "EURIBOR", "3M", "5Y", "EUR")
	createSwapUnderlying(md, "EUR", "EURIBOR", "3M", "7Y", "EUR")
	createSwapUnderlying(md, "EUR", "EURIBOR", "3M", "10Y", "EUR")
	createSwapUnderlying(md, "EUR", "EURIBOR", "3M", "15Y", "EUR")
	createSwapUnderlying(md, "EUR", "EURIBOR", "3M", "20Y", "EUR")
	createSwapUnderlying(md, "EUR", "EURIBOR", "3M", "25Y", "EUR")
	createSwapUnderlying(md, "EUR", "EURIBOR", "3M", "30Y", "EUR")
	createSwapUnderlying(md, "EUR", "EURIBOR", "3M", "40Y", "EUR")

	createSwapUnderlying(md, "ZAR", "LIBOR", "3M", "2Y", "LON")
	createSwapUnderlying(md, "ZAR", "LIBOR", "3M", "3Y", "LON")
	createSwapUnderlying(md, "ZAR", "LIBOR", "3M", "4Y", "LON")
	createSwapUnderlying(md, "ZAR", "LIBOR", "3M", "5Y", "LON")
	createSwapUnderlying(md, "ZAR", "LIBOR", "3M", "6Y", "LON")
	createSwapUnderlying(md, "ZAR", "LIBOR", "3M", "7Y", "LON")
	createSwapUnderlying(md, "ZAR", "LIBOR", "3M", "8Y", "LON")
	createSwapUnderlying(md, "ZAR", "LIBOR", "3M", "9Y", "LON")
	createSwapUnderlying(md, "ZAR", "LIBOR", "3M", "10Y", "LON")
	createSwapUnderlying(md, "ZAR", "LIBOR", "3M", "12Y", "LON")
	createSwapUnderlying(md, "ZAR", "LIBOR", "3M", "15Y", "LON")
	createSwapUnderlying(md, "ZAR", "LIBOR", "3M", "17Y", "LON")
	createSwapUnderlying(md, "ZAR", "LIBOR", "3M", "20Y", "LON")
	createSwapUnderlying(md, "ZAR", "LIBOR", "3M", "25Y", "LON")
	createSwapUnderlying(md, "ZAR", "LIBOR", "3M", "30Y", "LON")


	createSwapUnderlying(md, "JPY", "LIBOR", "3M", "2Y", "TOK")
	createSwapUnderlying(md, "JPY", "LIBOR", "3M", "3Y", "TOK")
	createSwapUnderlying(md, "JPY", "LIBOR", "3M", "4Y", "TOK")
	createSwapUnderlying(md, "JPY", "LIBOR", "3M", "5Y", "TOK")
	createSwapUnderlying(md, "JPY", "LIBOR", "3M", "6Y", "TOK")
	createSwapUnderlying(md, "JPY", "LIBOR", "3M", "7Y", "TOK")
	createSwapUnderlying(md, "JPY", "LIBOR", "3M", "8Y", "TOK")
	createSwapUnderlying(md, "JPY", "LIBOR", "3M", "9Y", "TOK")
	createSwapUnderlying(md, "JPY", "LIBOR", "3M", "10Y", "TOK")
	createSwapUnderlying(md, "JPY", "LIBOR", "3M", "12Y", "TOK")
	createSwapUnderlying(md, "JPY", "LIBOR", "3M", "15Y", "TOK")
	createSwapUnderlying(md, "JPY", "LIBOR", "3M", "17Y", "TOK")
	createSwapUnderlying(md, "JPY", "LIBOR", "3M", "20Y", "TOK")
	createSwapUnderlying(md, "JPY", "LIBOR", "3M", "25Y", "TOK")
	createSwapUnderlying(md, "JPY", "LIBOR", "3M", "30Y", "TOK")
}

ds = ConnectionUtil.connect("calypso_user","calypso","ers_scripts",args[0])

save_cash()
save_swap()

ds.disconnect()

def createMMUnderlying(md, currency, tenor, settledays, index, dayCount, dateRoll, holiday) {
    cu = new CurveUnderlyingMoneyMarket();
    cu.setRateIndexSource("T3750");
    cu.setCurrency(currency);
    cu.setIsDiscount(false);
    cu.setMoneyMarketType(index);
    cu.setDayCount(new DayCount(dayCount));
    cu.setDateRoll(new DateRoll(dateRoll));
    cu.setHolidays(Util.string2Vector(holiday));
    cu.setId(0);
    cu.setUser(DSConnection.getDefault().getUser());
    cu.setIsSpecific(false);
    cu.setSettleDays(settledays);
    cu.setTenor(new Tenor(tenor));
    
    id = 0;
    try {
        id = md.save(cu);
    }
    catch (Exception e) { }

}


def createSwapUnderlying(md, currency, index, tenor, maturity, holiday)
//	fixFreq, fixDayCount, fixDateRoll, fixHol,
//	floatFreq, floatDayCount, floatDateRoll, floatHol) 
    {
    
    fixFreq = "SA"
    fixDayCount = "ACT/360"
    fixDateRoll = "FOLLOWING"
    fixHol = floatHol = holiday
    floatFreq = "QTR"
    floatDayCount = "ACT/360"
    floatDateRoll = "FOLLOWING"
    
    cu = new CurveUnderlyingSwap();
    cu.setCurrency(currency);
    src = "T3750"
    try {
        cu.setRateIndex(LocalCache.getRateIndex(ds,
        		currency, index, new Tenor(tenor), src));
    } catch (Exception e) {
       println e
       
    }
    if (cu.getRateIndex() == null) {
        println "Rate Index " + currency + "/" + index + " " + tenor + " " + src + " Does not exist"
        return
    }
    cu.setMaturity(new Tenor(maturity));
    cu.setFixedCouponHolidays(Util.string2Vector(fixHol));
    cu.setFloatingCouponHolidays(Util.string2Vector(floatHol));
    cu.setFixedDayCount(new DayCount(fixDayCount));
    cu.setFixedCouponDateRoll(new DateRoll(fixDateRoll));
    cu.setFloatingCouponDateRoll(new DateRoll(floatDateRoll));
    cu.setFixedCouponFrequency(new Frequency(fixFreq));
    cu.setFloatCouponFrequency(new Frequency(floatFreq));
    cu.setId(0);
    cu.setIsManualFirstResetB(true);
    cu.setFixedPeriodRule(PeriodRule.get("ADJUSTED"));
    cu.setFloatPeriodRule(PeriodRule.get("ADJUSTED"));
    cu.setFloatCompoundFrequency(Frequency.get("NON"));
    cmp = cu.getFloatCompoundFrequency();
    f = cu.getFloatCouponFrequency();

    if (fixFreq.equals("ZC")) {
        cu.setFixedCompoundFrequency(Frequency
                .get("ZC"));
    } else
        cu.setFixedCompoundFrequency(null);
    cu.setSpecificLagB(false);
    cu.setPrincipalActualB(false);
    try {
        cu.generateUnderlying(new JDatetime());
    } catch (Exception ex) {
        return;
    } finally {
        if (cu.getProduct() != null)
            cu.setProduct(null);
    }
    id = 0;
    try {
        id = md.save(cu);
    }
    catch (Exception e) { println e}
    println id
}
