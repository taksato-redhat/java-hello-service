package local.hello.web.rs;

import javax.enterprise.context.RequestScoped;
import javax.inject.Inject;

import local.hello.service.HelloService;

@RequestScoped
public class HelloResourceBean implements HelloResource {

	@Inject
	HelloService service;

	@Override
	public String hello(String name) {
		return service.hello(name);
	}

	@Override
	public String bye(String name) {
		return service.bye(name);
	}

}
