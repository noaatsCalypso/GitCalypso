/**
 * 
 */
package calypsox.tk.bridge.trioptima;

import java.util.List;

import com.calypso.tk.bridge.IHolidayFinder;
import com.calypso.tk.core.Product;
import com.calypso.tk.core.TemplateInfo;
import com.calypso.tk.util.TradeCreationEntry;

/**
 * @author jlv
 *
 */
public class HolidayFinder implements IHolidayFinder {

	/* (non-Javadoc)
	 * @see com.calypso.tk.bridge.IHolidayFinder#findHolidays(com.calypso.tk.util.TradeCreationEntry)
	 */
	public List<String> findHolidays(TradeCreationEntry entry) {
		List<String> holidays = null;
		if ("CreditDefaultSwap".equals(entry.getCalypsoProductType())) {
			TemplateInfo template = entry.getCalypsoTemplate();
			if (template != null) {
				Product product = template.getProduct();
				if (product != null) {
					holidays = product.getHolidays();
				}
			}
		}
		return holidays;
	}

}
