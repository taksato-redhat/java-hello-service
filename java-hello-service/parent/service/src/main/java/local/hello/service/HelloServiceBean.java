package local.hello.service;

import javax.ejb.Stateless;

@Stateless
public class HelloServiceBean implements HelloService {

	@Override
	public String hello(String name) {
		return "Hello " + name + "!";
	}

	@Override
	public String bye(String name) {
		return "Bye " + name + "!";
	}

}
