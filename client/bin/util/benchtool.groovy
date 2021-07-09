
import com.calypso.tk.util.ConnectionUtil;
import com.calypso.tk.core.JDate;
//import com.calypso.tk.core.Util;
import com.calypso.bench.TradeDuplicatorForRisk;

ds = ConnectionUtil.connect("calypso_user","calypso","JAPP",args[0])

def srcTrade = ds.getRemoteTrade().getTrade(Integer.parseInt(args[1]))

def numberofTrade = 300
        
TradeDuplicatorForRisk.duplicateTrade(srcTrade, new JDate(2006, 1, 26), new JDate(2006,1,27), ((Double)numberofTrade).doubleValue(), ds, 
        true, true, false, false, false, (new Long(200)).longValue(), true, false);
        
    
ds.disconnect()

