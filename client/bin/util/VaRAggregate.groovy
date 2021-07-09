import com.calypso.tk.service.DSConnection
import com.calypso.tk.event.PSEventRiskEngine
import com.calypso.tk.util.ConnectionUtil
import com.calypso.risk.RiskResultServlet
import com.calypso.risk.aggregation.AggrResult
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

def env="Demo"

def ds = DSConnection.getDefault();
def newConnection = false
if (null==ds) {
	newConnection = true;
	ds = ConnectionUtil.connect("calypso_user","calypso","ers_scripts",env)
}

RiskResultServlet.initialise(env)

user = DSConnection.getDefault().getUser();

def timestamp = "2006-02-24"

if(args.length > 0) timestamp = args[0]

AggrResult.RunAggregation(user, "Official.CapitalMkts.Treasury.Rates.Prop.SwapBook", "RiskType", timestamp, "SwapBook","HistSim.Standard")
AggrResult.RunAggregation(user, "Official.CapitalMkts.Treasury.Rates.Prop.SwapBook", "Product", timestamp, "SwapBook","HistSim.Standard")
AggrResult.RunAggregation(user, "Official.CapitalMkts.Treasury.Rates.Prop.SwapBook", "Currency", timestamp, "SwapBook","HistSim.Standard")
AggrResult.RunAggregation(user, "Official.CapitalMkts.Treasury.Rates.Prop.SwapBook", "Book", timestamp, "SwapBook","HistSim.Standard")
AggrResult.RunAggregation(user, "Official.CapitalMkts.Treasury.Rates.Prop.SwaptionBook", "RiskType", timestamp, "SwaptionBook","HistSim.Standard")
AggrResult.RunAggregation(user, "Official.CapitalMkts.Treasury.Rates.Prop.SwaptionBook", "Product", timestamp, "SwaptionBook","HistSim.Standard")
AggrResult.RunAggregation(user, "Official.CapitalMkts.Treasury.Rates.Prop.SwaptionBook", "Currency", timestamp, "SwaptionBook","HistSim.Standard")
AggrResult.RunAggregation(user, "Official.CapitalMkts.Treasury.Rates.Prop.SwaptionBook", "Book", timestamp, "SwaptionBook","HistSim.Standard")
AggrResult.RunAggregation(user, "Official.CapitalMkts.Treasury.Rates.Prop.CreditNorthAm", "RiskType", timestamp, "CreditNorthAm","HistSim.Standard")
AggrResult.RunAggregation(user, "Official.CapitalMkts.Treasury.Rates.Prop.CreditNorthAm", "Product", timestamp, "CreditNorthAm","HistSim.Standard")
AggrResult.RunAggregation(user, "Official.CapitalMkts.Treasury.Rates.Prop.CreditNorthAm", "Currency", timestamp, "CreditNorthAm","HistSim.Standard")
AggrResult.RunAggregation(user, "Official.CapitalMkts.Treasury.Rates.Prop.CreditNorthAm", "Book", timestamp, "CreditNorthAm","HistSim.Standard")

AggrResult.RunAggregation(user, "Official.CapitalMkts.Treasury.Rates.Prop", "RiskType", timestamp, null,"HistSim.Standard")
AggrResult.RunAggregation(user, "Official.CapitalMkts.Treasury.Rates.Prop", "Product", timestamp, null,"HistSim.Standard")
AggrResult.RunAggregation(user, "Official.CapitalMkts.Treasury.Rates.Prop", "Currency", timestamp, null,"HistSim.Standard")
AggrResult.RunAggregation(user, "Official.CapitalMkts.Treasury.Rates.Prop", "Book", timestamp, null,"HistSim.Standard")
AggrResult.RunAggregation(user, "Official.CapitalMkts.Treasury.Rates", "RiskType", timestamp, null,"HistSim.Standard")
AggrResult.RunAggregation(user, "Official.CapitalMkts.Treasury.Rates", "Product", timestamp, null,"HistSim.Standard")
AggrResult.RunAggregation(user, "Official.CapitalMkts.Treasury.Rates", "Currency", timestamp, null,"HistSim.Standard")
AggrResult.RunAggregation(user, "Official.CapitalMkts.Treasury.Rates", "Book", timestamp, null,"HistSim.Standard")

AggrResult.RunAggregation(user, "Official.CapitalMkts.Treasury.FX.FXSwaps", "RiskType", timestamp, "FXSwaps","HistSim.Standard")
AggrResult.RunAggregation(user, "Official.CapitalMkts.Treasury.FX.FXSwaps", "Product", timestamp, "FXSwaps","HistSim.Standard")
AggrResult.RunAggregation(user, "Official.CapitalMkts.Treasury.FX.FXSwaps", "Currency", timestamp, "FXSwaps","HistSim.Standard")
AggrResult.RunAggregation(user, "Official.CapitalMkts.Treasury.FX.FXSwaps", "Book", timestamp, "FXSwaps","HistSim.Standard")
AggrResult.RunAggregation(user, "Official.CapitalMkts.Treasury.FX", "RiskType", timestamp, null,"HistSim.Standard")
AggrResult.RunAggregation(user, "Official.CapitalMkts.Treasury.FX", "Product", timestamp, null,"HistSim.Standard")
AggrResult.RunAggregation(user, "Official.CapitalMkts.Treasury.FX", "Currency", timestamp, null,"HistSim.Standard")
AggrResult.RunAggregation(user, "Official.CapitalMkts.Treasury.FX", "Book", timestamp, null,"HistSim.Standard")

AggrResult.RunAggregation(user, "Official.CapitalMkts.Treasury", "RiskType", timestamp, null,"HistSim.Standard")
AggrResult.RunAggregation(user, "Official.CapitalMkts.Treasury", "Product", timestamp, null,"HistSim.Standard")
AggrResult.RunAggregation(user, "Official.CapitalMkts.Treasury", "Currency", timestamp, null,"HistSim.Standard")
AggrResult.RunAggregation(user, "Official.CapitalMkts.Treasury", "Book", timestamp, null,"HistSim.Standard")

AggrResult.RunAggregation(user, "Official.CapitalMkts.Securities.EQGlobal", "RiskType", timestamp, "EQGlobal","HistSim.Standard")
AggrResult.RunAggregation(user, "Official.CapitalMkts.Securities.EQGlobal", "Product", timestamp, "EQGlobal","HistSim.Standard")
AggrResult.RunAggregation(user, "Official.CapitalMkts.Securities.EQGlobal", "Currency", timestamp, "EQGlobal","HistSim.Standard")
AggrResult.RunAggregation(user, "Official.CapitalMkts.Securities.EQGlobal", "Book", timestamp, "EQGlobal","HistSim.Standard")
AggrResult.RunAggregation(user, "Official.CapitalMkts.Securities", "RiskType", timestamp, null,"HistSim.Standard")
AggrResult.RunAggregation(user, "Official.CapitalMkts.Securities", "Product", timestamp, null,"HistSim.Standard")
AggrResult.RunAggregation(user, "Official.CapitalMkts.Securities", "Currency", timestamp, null,"HistSim.Standard")
AggrResult.RunAggregation(user, "Official.CapitalMkts.Securities", "Book", timestamp, null,"HistSim.Standard")

AggrResult.RunAggregation(user, "Official.CapitalMkts", "RiskType", timestamp, null,"HistSim.Standard")
AggrResult.RunAggregation(user, "Official.CapitalMkts", "Product", timestamp, null,"HistSim.Standard")
AggrResult.RunAggregation(user, "Official.CapitalMkts", "Currency", timestamp, null,"HistSim.Standard")
AggrResult.RunAggregation(user, "Official.CapitalMkts", "Book", timestamp, null,"HistSim.Standard")

AggrResult.RunAggregation(user, "Official", "RiskType", timestamp, null,"HistSim.Standard")
AggrResult.RunAggregation(user, "Official", "Product", timestamp, null,"HistSim.Standard")
AggrResult.RunAggregation(user, "Official", "Currency", timestamp, null,"HistSim.Standard")
AggrResult.RunAggregation(user, "Official", "Book", timestamp, null,"HistSim.Standard")


if (newConnection) {
	ds.disconnect()
}
