/**
 * 
 */
package calypsox.tk.bridge.trioptima;

import java.util.List;

import com.calypso.tk.bridge.ITenorMapping;
import com.calypso.tk.bridge.util.CrossReferenceCache;
import com.calypso.tk.core.Frequency;
import com.calypso.tk.core.Tenor;


/**
 * @author jean-luc_vanniere
 *
 */
public class TenorMapping extends CrossReferenceCache<String, String>
		implements ITenorMapping {
	public TenorMapping() {
		super(DuplicatePolicy.MANY_TO_ONE_KEEP_FIRST_IN);
		init();
	}

	/* (non-Javadoc)
	 * @see com.calypso.tk.bridge.ITenorMapping#getExternalCouponPeriod(java.lang.String)
	 */
	public String getExternalTenor(String internalReference) {
		return reverseGet(internalReference);
	}

	/* (non-Javadoc)
	 * @see com.calypso.tk.bridge.ITenorMapping#getInternalCouponPeriod(java.lang.String)
	 */
	public String getInternalTenor(String externalReference) {
		return get(externalReference);
	}

	private void init() {
		List<Frequency> frequencies = Frequency.values();
		for (Frequency f : frequencies) {
			Tenor tenor = f.getTenor();
			this.add(tenor.getName(), f.toString());
		}
		// It seems that trioptima indicates "1A" for yearly coupons
		add("1A", "PA"); 
	}
}
