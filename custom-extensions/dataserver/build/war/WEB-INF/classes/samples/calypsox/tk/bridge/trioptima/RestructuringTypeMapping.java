/**
 * 
 */
package calypsox.tk.bridge.trioptima;

import com.calypso.tk.bridge.IRestructuringTypeMapping;
import com.calypso.tk.bridge.util.CrossReferenceCache;

/**
 * @author jean-luc_vanniere
 *
 */
public class RestructuringTypeMapping extends CrossReferenceCache<String, String>
		implements IRestructuringTypeMapping {

	
	/**
	 * Default constructor
	 */
	public RestructuringTypeMapping() {
		super();
		add("ModModR", "MMR");
	}

	/* (non-Javadoc)
	 * @see com.calypso.tk.bridge.IRestructuringTypeMapping#getExternalRestructuringType(java.lang.String)
	 */
	public String getExternalRestructuringType(String internalType) {
		return reverseGet(internalType);
	}

	/* (non-Javadoc)
	 * @see com.calypso.tk.bridge.IRestructuringTypeMapping#getInternalRestructuringType(java.lang.String)
	 */
	public String getInternalRestructuringType(String externalType) {
		return get(externalType);
	}

}
