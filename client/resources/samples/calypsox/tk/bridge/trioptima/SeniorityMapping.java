/**
 * 
 */
package calypsox.tk.bridge.trioptima;

import com.calypso.tk.bridge.ISeniorityMapping;
import com.calypso.tk.bridge.util.CrossReferenceCache;

/**
 * @author jean-luc_vanniere
 *
 */
public class SeniorityMapping extends CrossReferenceCache<String, String> implements
		ISeniorityMapping {

	/**
	 * Public constructor
	 */
	public SeniorityMapping() {
		super();
		add("Senior", "SENIOR_UNSECURED");
		add("SubLowerTier2", "SUBORDINATE");
	}

	/* (non-Javadoc)
	 * @see com.calypso.tk.bridge.ISeniorityMapping#getExternalSeniority(java.lang.String)
	 */
	public String getExternalSeniority(String internalSeniority) {
		return reverseGet(internalSeniority);
	}

	/* (non-Javadoc)
	 * @see com.calypso.tk.bridge.ISeniorityMapping#getInternalSeniority(java.lang.String)
	 */
	public String getInternalSeniority(String externalSeniority) {
		return get(externalSeniority);
	}

}
