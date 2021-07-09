
import com.calypso.engine.risk.DailyBatch

def envName = "Demo"

def pricingEnv = "default"

batch = new DailyBatch();
batch.init(envName)

batch.clear("DailyRT")

// arguments are <batch name> <analysis> <PORTFOLIO|HIERARCHY> <parms> <pricingEnv> <valueDate> <is_complex> <is _live>
batch.addItem("DailyRT", "IRDelta", "MainBook", "PORTFOLIO", "IRDelta", pricingEnv, null, false, true)
batch.addItem("DailyRT", "ProfitLoss", "MainBook", "PORTFOLIO", "test", pricingEnv, null, false, true)
batch.addItem("DailyRT", "Scenario", "MainBook", "PORTFOLIO", "Stress", pricingEnv, null, false, true)

batch.addItem("DailyRT", "ProfitLoss", "SwapBook", "PORTFOLIO", "test", pricingEnv, null, false, true)
batch.addItem("DailyRT", "HistSim", "SwapBook", "PORTFOLIO", "Standard", pricingEnv, null, false, true)

batch.save()

println "Batch items added";



