import com.calypso.tk.core.Defaults;
import com.calypso.tk.scenarios.ScenarioWriter;

csvPath = "C:/calypso/software/ers/install/sample/resources/"

def envName = "Rel800"

def mgr = new ScenarioWriter();
    	    	
mgr.init(envName)

// Rates
mgr.addReader(1, "Rates", csvPath + "ScenarioSetForRatesUSD.csv", "USD", "LIBOR", "US.USD.ISZ.D.M.Y.CY", "Zero")
mgr.addReader(1, "Rates", csvPath + "ScenarioSetForRatesEUR.csv", "EUR", "EURIBOR", "EU.EUR.ISZ.D.M.Y.CY", "Zero")
//mgr.addReader(1, "Rates", csvPath + "ScenarioSetForRatesZAR.csv", "ZAR", "LIBOR", "ZA.ZAR.ISZ.D.M.Y.CY", "Zero")

// FX
mgr.addReader(1, "FX", csvPath + "USD-EUR.csv", "EUR", "", "USD.EUR.CCY.CP")
//mgr.addReader(1, "FX", csvPath + "ZAR-USD.csv", "ZAR", "", "USD.ZAR.CCY.CP")

// Swaptions
mgr.addReader(1, "Vols", csvPath + "ScenarioSetForVolsSwaptionsUSD.csv", "USD", "LIBOR", "US.USD.ISO.D.M.Y.YY.CP");
//mgr.addReader(1, "Vols", csvPath + "ScenarioSetForVolsSwaptionsUSD.csv", "ZAR", "LIBOR", "ZA.ZAR.ISO.D.M.Y.YY.CP");

// Cap Data 
// "US.USD.CAP.0.0.Y.YY.CP" change CAP to FLR/EQO/FUO for other option types.. 
//mgr.addReader(1, "Options", csvPath + "cap_volsurfaceEUR.csv", "USD", "LIBOR", "US.USD.CAP.0.0.Y.YY.CP");

// Credit
//mgr.addReader(1, "CreditTemp", csvPath + "CreditA2C.csv", null, null, null);

// Equity Quotes 
// 'Equity.Equity.ORCL' means its an 'Equity' on with name 'Equity.ORCL' in calypso
//mgr.addReader(1, "Quotes", csvPath + "equity/"+"ORCL.csv", "USD", "ORCL", "Equity.Equity.ORCL");
//mgr.addReader(1, "Quotes", csvPath + "equity/"+"BP.csv", "GBP", "BP", "Equity.Equity.BP");
//mgr.addReader(1, "Quotes", csvPath + "equity/"+"DB.csv", "EUR", "DB", "Equity.Equity.DB");
//mgr.addReader(1, "Quotes", csvPath + "equity/"+"FORD.csv", "USD", "FORD", "Equity.Equity.FORD");
//mgr.addReader(1, "Quotes", csvPath + "equity/"+"HSBC.csv", "GBP", "HSBC", "Equity.Equity.HSBC");
//mgr.addReader(1, "Quotes", csvPath + "equity/"+"GM.csv", "USD", "GM", "Equity.Equity.GM");
//mgr.addReader(1, "Quotes", csvPath + "equity/"+"MSFT.csv", "USD", "MSFT", "Equity.Equity.MSFT");
//mgr.addReader(1, "Quotes", csvPath + "equity/"+"SAP.csv", "EUR", "SAP", "Equity.Equity.SAP");
//mgr.addReader(1, "Quotes", csvPath + "equity/"+"SONY.csv", "JPY", "SONY", "Equity.Equity.SONY");
//mgr.addReader(1, "Quotes", csvPath + "equity/"+"TOYT.csv", "JPY", "TOYT", "Equity.Equity.TOYT");
//mgr.addReader(1, "Quotes", csvPath + "equity/"+"SP500.csv", "USD", "SP500", "Equity.Equity.SP500");
//mgr.addReader(1, "Quotes", csvPath + "equity/"+"FTSE.csv", "GBP", "FTSE", "Equity.Equity.FTSE");

//mgr.addReader(1, "CDSSpread", csvPath+"ig5_cds_quote_small.csv", null, null, null);

// Correlation Skew
//mgr.addReader(1, "CorrelationSkew", csvPath + "ig5_tranche_correlations_valid.csv", null, null, "newone");

// Bond Prices
// 'BondPrice.Bond.UST.11-15-2008.4.75000' means its an 'BondPrice' on with name 'Bond.UST.11-15-2008.4.75000' in calypso
//mgr.addReader(1, "Quotes", csvPath + "equity/"+"ORCL.csv", "JPY", "UST.11-15-2008.4.75000", "BondPrice.Bond.UST.11-15-2008.4.75000");

//FX Options
//mgr.addReader(1, "FXOptions", csvPath + "ScenarioSetForFXVolsUSD.csv", "USD", "EUR.USD", "US.USD.FXO.D.M.Y.YY.CP");


mgr.start()

println "Finished"

