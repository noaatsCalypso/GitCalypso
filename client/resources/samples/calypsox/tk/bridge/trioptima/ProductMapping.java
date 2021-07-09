/**
 * 
 */
package calypsox.tk.bridge.trioptima;

import java.util.HashMap;

import com.calypso.tk.bridge.IProductMapping;
import com.calypso.tk.bridge.IProductInformation;
import com.calypso.tk.bridge.trioptima.ProductInformation;

/**
 * @author jean-luc_vanniere
 *
 */
public class ProductMapping implements IProductMapping {
	/**
	 * Public constructor
	 */
	public ProductMapping() {
		cache = new HashMap<String, ProductInformation>();
		add(trioptima_cds, "CreditDefaultSwap", "SingleNameCDS");
		add(trioptima_cdx, "CDSIndex", "CDSIndex");
		add(trioptima_cds_abx, "CDSABSIndex", "CDSABSIndex");
		add(trioptima_cdx_tranche, "CDSIndexTranche", "CDSIndexTranche");
	}

	/**
	 * Add product information into the cache
	 * @param externalType external product type
	 * @param type calypso product type
	 * @param subType calypso product subtype
	 * @param transactionType external transaction type
	 */
	public void add(String externalType, String type, String subType, String transactionType) {
		ProductInformation info = new ProductInformation(externalType, type, subType, transactionType);
		remove(externalType);
		cache.put(externalType, info);
	}

	/**
	 * Add product information into the cache
	 * @param externalType product type in external format
	 * @param type calypso product type
	 * @param subType calypso product subtype
	 */
	public void add(String externalType, String type, String subType) {
		add(externalType, type, subType, type);
	}

	/* (non-Javadoc)
	 * @see com.calypso.tk.bridge.IProductMapping#getProductInformation(java.lang.String)
	 */
	public IProductInformation getProductInformation(String externalProductType) {
		return cache.get(externalProductType);
	}
	
	/**
	 * Removes all the information related to the given product type
	 * @param externalProductType product type in external format
	 * @return The information previously recorded in the cache
	 */
	public IProductInformation remove(String externalProductType) {
		IProductInformation res = getProductInformation(externalProductType);
		if (res != null) {
			cache.remove(externalProductType);
		}
		return res;
	}

	/**
	 * Clears the product information cache
	 */
	public void clear() {
		cache.clear();
	}

	// TODO Maybe should be a concurrent hashmap...
	private final HashMap<String, ProductInformation> cache;



}
