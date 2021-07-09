import com.calypso.tk.core.Defaults;
import com.calypso.apps.riskmetrics.OverlappingScenarios;

def create(scenarioSetId) {

	OverlappingScenarios.create(scenarioSetId, "Rates", "Fractional", "USD")
	OverlappingScenarios.create(scenarioSetId, "Rates", "Fractional", "EUR")
	OverlappingScenarios.create(scenarioSetId, "Rates", "Fractional", "ZAR")
	OverlappingScenarios.create(scenarioSetId, "FX", "Fractional", "EUR")
	OverlappingScenarios.create(scenarioSetId, "FX", "Fractional", "ZAR")

	OverlappingScenarios.create(scenarioSetId, "Credit", "Abs Bps", "USD")

	OverlappingScenarios.create(scenarioSetId, "Vols", "Fractional", "USD")
}

def envName = "Rel800";

OverlappingScenarios.init(envName);

scenarioSetId = 2;

try { create(scenarioSetId) 
    println "Creation of 10d scenarios finished."
} catch (Exception e) {println e}


