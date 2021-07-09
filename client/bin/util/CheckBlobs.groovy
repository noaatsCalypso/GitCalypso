
import com.calypso.engine.risk.util.PackedResultsChecker


def envName = "Rel800"

checker = new PackedResultsChecker();


valueDate1 =(args.length > 0)?args[0]:null
valueDate2 =(args.length > 1)?args[1]:null
checker.printResults(valueDate1, valueDate2, envName);


