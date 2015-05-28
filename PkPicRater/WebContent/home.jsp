<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<c:import url="header.jsp">
<c:param name="title" value="Parkour Rater Home"></c:param>
</c:import>

<sql:setDataSource var="ds" dataSource="jdbc/webapp" />
<sql:query dataSource="${ds}" sql="select * from images" var="results"	/>

<p>First Java Servlet: Parkour Image Rater <br>
This is a work in progress site. It has a long way to go. I'm using this site to learn different java technologies. 
This Parkour image rater is my first Java servlet. Best way to learn is to build something you're passionate about. This first started as a standard
JSP page, but was converted to JSTL as it flows much better with HTML.
This site is coded via MVC architecture and uses a JNDI to access a MySQL database. This page will change as new technologies are learned.
Stayed tuned!!
</p>

<table class="images">

<c:set var="tableWidth" value="4"/>
<c:forEach var="image" items="${results.rows}" varStatus="row">
	<%--Using the index, print only 4 images per row. Take index/4, if it's 0 print a row tag --%>
	<c:if test="${row.index % tableWidth == 0 }">
	<tr>
	</c:if>
	<c:set scope="page" var="imagename" value="${image.imageName}.${image.image_ext}"></c:set>

	<td>
		<%--Encode the URL with JSTL using c:url to ensure that even if cookies are disable, site will still function --%>
		<a href="<c:url value="/gallery?action=image&image=${image.id}"/>">
		<img width="400" src="${pageContext.request.contextPath}/pics/${imagename}" >
	</a>
	</td>
	<%--If the last image in row, close the table row --%>
	<c:if test="${row.index + 1 % tableWidth == 0 }">
	</tr>
	</c:if>
	
</c:forEach>

</table>

<c:import url="footer.jsp"></c:import>