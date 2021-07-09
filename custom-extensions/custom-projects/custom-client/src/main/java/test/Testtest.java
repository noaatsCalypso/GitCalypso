package test;

import java.io.IOException;
import java.net.URISyntaxException;

import com.calypso.tk.service.DSConnection;
import com.calypso.tk.util.ConnectException;
import com.calypso.tk.util.ConnectionUtil;

import calypsox.apps.quote.AddQuote;

public class Testtest {
	DSConnection ds;
	public static void main(String[] args) {
		Testtest test = new Testtest();
		try {
			test.connection(args);

			test.test();
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
	}
	
	private void test() throws IOException, URISyntaxException {
		AddQuote addQuote = new AddQuote();
		addQuote.process(ds);
	}
	private void connection(String[] args) throws ConnectException {
		ds = ConnectionUtil.connect(args, "Test");
	}
	
}
