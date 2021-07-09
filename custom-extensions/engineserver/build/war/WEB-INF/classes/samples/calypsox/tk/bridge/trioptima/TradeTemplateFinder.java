/**
 * 
 */
package calypsox.tk.bridge.trioptima;

import java.util.HashMap;

import com.calypso.tk.bridge.ITradeTemplateFinder;
import com.calypso.tk.util.TradeCreationEntry;
import com.calypso.tk.util.TriReduceAbstractException;

/**
 * Implementation of ITradeTemplateFinder
 * @author jean-luc_vanniere
 *
 */
public class TradeTemplateFinder implements ITradeTemplateFinder {
	/**
	 * Defaault constructor
	 */
	public TradeTemplateFinder() {
		putTemplate("AsiaCorporate", "cdscasia");
		putTemplate("AustraliaCorporate", "cdscaus");
		putTemplate("EmergingEuropeanCorporate", "cdscemeur");
		putTemplate("EuropeanCorporate", "cdsceuro");
		putTemplate("SubordinatedEuropeanInsuranceCorporate", "cdscisub");
		putTemplate("JapanCorporate", "cdscjapan");
		putTemplate("EmergingEuropeanCorporateLPN", "cdscjscrusse");
		putTemplate("LatinAmericaCorporateBond", "cdsclatame");
		putTemplate("monoline", "cdscmono");
		putTemplate("NewZealandCorporate", "cdscnewz");
		putTemplate("StandardNewZealandCorporate", "cdscnewz");
		putTemplate("StandardAsiaCorporate", "cdscnsasia");
		putTemplate("StandardAustraliaCorporate", "cdscnsaus");
		putTemplate("StandardEmergingEuropeanCorporate", "cdscnsemeur");
		putTemplate("StandardEuropeanCorporate", "cdscnseuro");
		putTemplate("StandardSubordinatedEuropeanInsuranceCorporate", "cdscnsisub");
		putTemplate("StandardJapanCorporate", "cdscnsjapan");
		putTemplate("uStandardEmergingEuropeanCorporateLPN", "cdscnsjscrusse");
		putTemplate("StandardLatinAmericaCorporateBond", "cdscnslatame");
		putTemplate("StandardNewZealandCorporate", "cdscnsnewz");
		putTemplate("StandardSingaporeCorporate", "cdscnssing");
		putTemplate("SingapourCorporate", "cdscsing");
		putTemplate("NorthAmericanCorporate", "cdscus");
		putTemplate("StandardNorthAmericanCorporate", "cdscussnac");
		putTemplate("AsiaSovereign", "cdssasia");
		putTemplate("AustraliaSovereign", "cdssaus");
		putTemplate("EmergingEuropeanSovereign", "cdssceeur");
		putTemplate("SingapourSovereign", "cdssing");
		putTemplate("JapanSovereign", "cdssjapan");
		putTemplate("LatinAmericaSovereign", "cdsslatame");
		putTemplate("MiddleEasternSovereign", "cdssme");
		putTemplate("StandardAsiaSovereign", "cdssnsasia");
		putTemplate("StandardAustraliaSovereign", "cdssnsaus");
		putTemplate("StandardEmergingEuropeanSovereign", "cdssnsceeur");
		putTemplate("StandardEmergingEuropeanAndMiddleEasternSovereign", "cdssnsceeur");
		putTemplate("StandardJapanSovereign", "cdssnsjapan");
		putTemplate("StandardLatinAmericaSovereign", "cdssnslatame");
		putTemplate("StandardMiddleEasternSovereign", "cdssnsme");
		putTemplate("StandardNewZealandSovereign", "cdssnsnz");
		putTemplate("StandardSingaporeSovereign", "cdssnssing");
		putTemplate("StandardWesternEuropeanSovereign", "cdssnsweseur");
		putTemplate("WesternEuropeanSovereign", "Cdssweseur");
		putTemplate("LatinAmericaCorporateBondOrLoan", "cdsclatame_bl");
		putTemplate("StandardLatinAmericaCorporateBondOrLoan", "cdscnslatame_bl");
		putTemplate("NewZealandSovereign", "cdssnz");
		putTemplate("SingaporeSovereign", "cdsssing");

		putTemplate("CDX", "");
	}


	/* (non-Javadoc)
	 * @see com.calypso.tk.bridge.ITradeTemplateFinder#findTemplate(com.calypso.tk.util.TradeCreationEntry)
	 */
	public String findTemplate(TradeCreationEntry entry) throws TriReduceAbstractException {
		String type = entry.getMasterDocumentTransType();
		String res = getTemplate(type);
		if ((res == null) && "CreditDefaultSwap".equals(entry.getCalypsoProductType())) {
			// When no mapping is found for CreditDefaultSwap, we use cdsstruct template
			res = "cdsstruct";
		}
		return res;
	}

	/**
	 * Associates the master document trans type to the template
	 * @param masterDocumentTransType
	 * @param templateName
	 */
	public void putTemplate(String masterDocumentTransType, String templateName) {
		templateMap.put(masterDocumentTransType, templateName);
	}
	
	private String getTemplate(String masterDocumentTransType) {
		return templateMap.get(masterDocumentTransType);
	}
	
	// Map of templates with master document trans types as keys
	private HashMap<String,String> templateMap = new HashMap<String,String>();
}
