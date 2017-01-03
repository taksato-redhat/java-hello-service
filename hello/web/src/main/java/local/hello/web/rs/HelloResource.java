package local.hello.web.rs;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.QueryParam;

@Path("/hello")
public interface HelloResource {

	@GET
	@Path("/hello")
	String hello(@QueryParam("name") String name);
	
	@GET
	@Path("/bye")
	String bye(@QueryParam("name") String name);

}
