import com.calypso.engine.risk.DailyBatch
import com.calypso.tk.util.ConnectionUtil

def calypsoEnv  = "Rel800"

ds = ConnectionUtil.connect("calypso_user","calypso","ers_scripts",calypsoEnv)

DailyBatch.init(null)

valueDate =(args.length > 1)?args[1]:null
DailyBatch.kickOffBatch(args[0], valueDate);

println "Batch kicked off."
ds.disconnect();

