/**
 * 
 */
package calypsox.tk.trioptima.precheck;

import com.calypso.tk.util.ScheduledTaskTRI_REDUCE_IMPORT;
import com.calypso.tk.trioptima.precheck.CheckHandler;
import com.calypso.tk.trioptima.precheck.ICheckHandler;
import com.calypso.tk.trioptima.precheck.ICheckHandlerFactory;
import com.calypso.tk.trioptima.precheck.NotionalCheckHandler;
import com.calypso.tk.trioptima.precheck.TerminationCheckHandler;

/**
 * The customer factory for pre-check handler.
 * This class should not be renamed, as it is instantiated by reflection.
 * @author jean-luc_vanniere
 *
 */
public class CheckHandlerFactory implements ICheckHandlerFactory {

	/* (non-Javadoc)
	 * @see com.calypso.tk.trioptima.precheck.ICheckHandlerFactory#create(com.calypso.tk.util.ScheduledTaskTRI_REDUCE_IMPORT)
	 */
	@Override
	public ICheckHandler create(ScheduledTaskTRI_REDUCE_IMPORT task) {
		CheckHandler res = new CheckHandler();
		if (task.mockCheck() == false) {
			res.add(new TerminationCheckHandler(task));
			res.add(new NotionalCheckHandler(task));
			res.add(new CustomerCdxTradesChecker(task));
		}
		return res;
	}

}
