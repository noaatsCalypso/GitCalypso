
import com.calypso.engine.risk.DailyBatch

def envName = "Demo"

def pricingEnv = "default"

batch = new DailyBatch();
batch.init(envName)

batch.clear("DailyNonRT")

// arguments are <batch name> <analysis> <PORTFOLIO|HIERARCHY> <parms> <pricingEnv> <valueDate> <is_complex> <is _live>

batch.addItem("DailyNonRT", "Scenario", "MainBook", "PORTFOLIO", "IRSlide", pricingEnv, null, false)

batch.addItem("DailyNonRT", "CSDelta", "CDSBook", "PORTFOLIO", "CSDelta", pricingEnv, null, false)
batch.addItem("DailyNonRT", "IRDelta", "CDSBook", "PORTFOLIO", "IRDelta", pricingEnv, null, false)
batch.addItem("DailyNonRT", "ProfitLoss", "CDSBook", "PORTFOLIO", "test", pricingEnv, null, false)
batch.addItem("DailyNonRT", "Scenario", "CDSBook", "PORTFOLIO", "Credit_View", pricingEnv, null, false)

batch.addItem("DailyNonRT", "EQDelta", "EQGlobal", "PORTFOLIO", "default", pricingEnv, null, false)
batch.addItem("DailyNonRT", "HistSim", "EQGlobal", "PORTFOLIO", "Standard", pricingEnv, null, false)

batch.addItem("DailyNonRT", "ProfitLoss", "SwaptionBook", "PORTFOLIO", "test", pricingEnv, null, false)
batch.addItem("DailyNonRT", "Scenario", "SwaptionBook", "PORTFOLIO", "Stress", pricingEnv, null, false)
batch.addItem("DailyNonRT", "HistSim", "SwaptionBook", "PORTFOLIO", "Standard", pricingEnv, null, false)
batch.addItem("DailyNonRT", "HistSim", "SwaptionBook", "PORTFOLIO", "Std10d", pricingEnv, null, false)

batch.addItem("DailyNonRT", "HistSim", "FXSwaps", "PORTFOLIO", "Standard", pricingEnv, null, false)

batch.addItem("DailyNonRT", "CSDelta", "CreditNorthAm", "PORTFOLIO", "CSDelta", pricingEnv, null, false)
batch.addItem("DailyNonRT", "IRDelta", "CreditNorthAm", "PORTFOLIO", "IRDelta", pricingEnv, null, false)
batch.addItem("DailyNonRT", "ProfitLoss", "CreditNorthAm", "PORTFOLIO", "test", pricingEnv, null, false)
batch.addItem("DailyNonRT", "Scenario", "CreditNorthAm", "PORTFOLIO", "Credit_View", pricingEnv, null, false)
batch.addItem("DailyNonRT", "HistSim", "CreditNorthAm", "PORTFOLIO", "Standard", pricingEnv, null, false)

batch.save()

println "Batch items added";



