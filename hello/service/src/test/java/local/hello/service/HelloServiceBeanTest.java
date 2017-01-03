package local.hello.service;

import org.junit.Assert;
import org.junit.Test;

public class HelloServiceBeanTest {
	
	@Test
	public void testHello() {
		HelloServiceBean service = new HelloServiceBean();
		String name = "Mike";
		Assert.assertEquals("Verify hello method result.", "Hello Mike!", service.hello(name));
	}
	
	@Test
	public void testBye() {
		HelloServiceBean service = new HelloServiceBean();
		String name = "Mike";
		Assert.assertEquals("Verify bye method result.", "Bye Mike!", service.bye(name));
	}

}
