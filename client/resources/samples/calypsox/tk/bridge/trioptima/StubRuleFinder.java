/**
 * 
 */
package calypsox.tk.bridge.trioptima;

import java.util.Vector;

import com.calypso.tk.bridge.IProductMapping;
import com.calypso.tk.bridge.IStubRuleFinder;
import com.calypso.tk.core.Util;
import com.calypso.tk.service.DSConnection;
import com.calypso.tk.service.LocalCache;
import com.calypso.tk.service.RemoteReferenceData;
import com.calypso.tk.util.TradeCreationEntry;
import com.calypso.tk.core.StubRule;

/**
 * @author jean-luc_vanniere
 *
 */
public class StubRuleFinder implements IStubRuleFinder {

	
	/**
	 * Public constructor
	 */
	public StubRuleFinder() {
	}
	/* (non-Javadoc)
	 * @see com.calypso.tk.bridge.IStubPeriodFinder#findStubPeriod(com.calypso.tk.util.TradeCreationEntry)
	 */
	public String findStubRule(TradeCreationEntry entry) {
		String res = null;
		if (entry != null) {
			String trioptima_product_type = entry.getTrioptimaProductType();
			if (IProductMapping.trioptima_cds.equals(trioptima_product_type)) {
			   // if (helper instanceof CDSCreationHelper)
				res = findCDSStubPeriod(entry);
		}
			else if (IProductMapping.trioptima_cdx_tranche.equals(trioptima_product_type)) {
				// else if (helper instanceof CDXTrancheCreationHelper) 
				res = findCDXTrancheStubPeriod(entry);
			}
		}
		return res;
	}

	private String findCDSStubPeriod(TradeCreationEntry entry) {
		String res = null;
		String templateName = entry.getCalypsoTemplateName();
		Vector<String> fullCouponTemplates = getCdsFullCouponTemplates();
		if (fullCouponTemplates.contains(templateName)) {
			res = StubRule.S_FULL_COUPON;
		}
		return res;
	}
	
	private String findCDXTrancheStubPeriod(TradeCreationEntry entry) {
		String res = null;
		if ("StandardCDXTranche".equals(entry.getMasterDocumentTransType())) {
			res = StubRule.S_FULL_COUPON;
		}
		return res;
	}
	
	
	private synchronized Vector<String> getCdsFullCouponTemplates() {
		if (cdsFullCouponTemplates == null) {
			cdsFullCouponTemplates = new Vector<String>();
			DSConnection ds = DSConnection.getDefault();
			RemoteReferenceData reference = DSConnection.getDefault().getRemoteReferenceData();
			String[] domains = {"StandardsISDA_ASIE", 
					 			"StandardsISDA_EMERGENT",
					 			"StandardsISDA_EUR",
					 			"StandardsISDA_PACIFIQUE",
					 			"StandardsISDA_STP",
					 			"StandardsISDA_US"};
			for (int i = 0; i < domains.length; i++) {
				@SuppressWarnings("unchecked")
				Vector<String> values = (Vector<String>)LocalCache.getDomainValues(ds, domains[i]);
				if (!Util.isEmpty(values)) {
					for (String val : values) {
						if (!cdsFullCouponTemplates.contains(val)) {
							cdsFullCouponTemplates.add(val);
						}
					}
				}				
			}
		}
		return cdsFullCouponTemplates;
	}
	
	// templates that imply FULL COUPON stub period for CDS
	private Vector<String> cdsFullCouponTemplates = null;
}
