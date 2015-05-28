package net.jeremysplayground.java;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.naming.NamingException;
import javax.servlet.Servlet;
import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.sql.DataSource;

/**
 * Servlet implementation class Controller
 */
public class Controller extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private DataSource ds;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public Controller() {
	}

	/**
	 * @see Servlet#init(ServletConfig)
	 */
	public void init(ServletConfig config) throws ServletException {
		try {
			InitialContext initContext = new InitialContext();
			Context env = (Context) initContext.lookup("java:comp/env");

			ds = (DataSource) env.lookup("jdbc/webapp");

		} catch (NamingException e) {
			throw new ServletException(e);
		}
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
			//Call forwardRequest function to forward requests to corresponding pages
			forwardRequest(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//Call forwardRequest function to forward requests to corresponding pages
		forwardRequest(request, response);
	}
	protected void forwardRequest(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		
		String action = request.getParameter("action");

		// Create map of actions and corresponding pages they will be associated
		// with
		Map<String, String> actionMap = new HashMap<>();
		actionMap.put("image", "/image.jsp");
		actionMap.put("home", "/home.jsp");
		actionMap.put("rate", "/image.jsp");

		// If the action parameter is empty or contains an action that isn't in
		// the map, set action to hom
		// That will forward back to home.jsp
		if (action == null || !actionMap.containsKey(action)){
			action = "home";
		}
		
		// Forward to correct page based off action
		request.getRequestDispatcher(actionMap.get(action)).forward(request,response);
			
	}

}
