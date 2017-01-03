package local.hello.web.rs;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.QueryParam;

@Path("/hello")
public interface HelloResource {

	@GET
	String hello(@QueryParam("name") String name);
	
	@GET
	String bye(@QueryParam("name") String name);

}
