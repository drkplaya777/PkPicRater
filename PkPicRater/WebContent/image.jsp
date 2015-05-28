<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ taglib tagdir="/WEB-INF/tags" prefix="ps" %>
<c:import url="header.jsp">
	<c:param name="title" value="Parkour Rater - View Image"></c:param>
</c:import>

<center>

<%--Connect to the datasource --%>

<%--Wrap rating update to database in sql transaction so that no user can overwrite anothers rating --%>
<sql:transaction dataSource="jdbc/webapp">

<%--Get the image that corresponds to the ID that we passed from home.jsp --%>
<sql:query  sql="select * from images where id=?"
	var="results">
	<sql:param>${param.image}</sql:param>
</sql:query>



<%--Get the row for this image and set the image name --%>
<c:set scope="page" var="image" value="${results.rows[0]}"></c:set>

<%--Set a variable named average_ranking equal to average_ranking stored in database --%>
<c:set scope="page" var="average_ranking"
	value="${image.average_ranking}"></c:set>

<%--If the user has submitted the page, calculate the ranking --%>
<c:if test='${param.action == "rate" }'>
	<c:set scope="page" var="newRating"
		value="${(image.average_ranking * image.rankings + param.rating)/(image.rankings + 1)}" />
		
	<%--Update the average_ranking variable set above to new calculated rating --%>
	<c:set scope="page" var="average_ranking" value="${newRating}" />
	
	<%--Run SQL update query to set new ranking --%>
	<sql:update sql="update images set average_ranking=? where id=?">
		<sql:param>${newRating}</sql:param>
		<sql:param>${param.image}</sql:param>
	</sql:update>
	<%--Update the number of rankings the image has received --%>
	<sql:update sql="update images set rankings=? where id=?">
		<sql:param>${image.rankings+1}</sql:param>
		<sql:param>${param.image}</sql:param>
	</sql:update>
	
</c:if>
	</sql:transaction>

<h2>
	<%--Use JSTL functions, substring and toUpperCase to capitalize the first letter --%>
	<c:out
		value="${fn:toUpperCase(fn:substring(image.imageName,0,1))}${fn:toLowerCase(fn:substring(image.imageName,1,-1))}"></c:out>
</h2>
	<span class="rating">Rated: <fmt:formatNumber value="${average_ranking}" maxFractionDigits="1"/></span>
	<table style="border: none;">
		<tr>
			<td><br style="margin-bottom: 1px;"> 
			<%--Display the URL that gives credit for image --%>
			<span	class="attribution"> Image of <a class="attribution"
					href="${image.attribution_url}">${image.attribution_name}</a></span><br />
					<%-- This is using a the custom tag that was created --%>
					<ps:image width="500" imageName="${image.imageName}"  image_ext="${image.image_ext}"/> <br>
					<a href="<c:url value="/gallery?action=home"/>"> Click here to go back home </a>
			</td>
			<td>
				<form action='<c:url value="/gallery" />' method="post">
				<%--Submit two hidden values. The first one, "rate", will contain the action=rate which the controller will use to redirect back to page --%>
				<%--Submit second value which will contain the imageID. When page resubmits to itself, it will use that hidden value to successfully connect back to database --%>
				    <input type="hidden" name="action" value="rate" />
				    <input type="hidden" name="image" value="${image.id}" />
					
					<table style="padding: 20px; border: none;">
						<tr>
							<td><h3>
									<i>Rate It!</i>
								</h3></td>
						</tr>
						<tr>
							<td align="left"><input type="radio" name="rating" value="5">5
								- Amazing</input></td>
						</tr>
						<tr>
							<td align="left"><input type="radio" name="rating" value="4">4
								- Good</input></td>
						</tr>
						<tr>
							<td align="left"><input type="radio" name="rating" value="3"
								checked="checked">3 - Average</input></td>
						</tr>
						<tr>
							<td align="left"><input type="radio" name="rating" value="2">2
								- Bad</input></td>
						</tr>
						<tr>
							<td align="left"><input type="radio" name="rating" value="1">1
								- Horrendous</input></td>
						</tr>
						<tr>
							<td align="left"><input type="submit" name="submit"
								value="OK"></input></td>
						</tr>
					</table>
				</form>
			</td>
		</tr>
	</table>
</center>
<c:import url="footer.jsp"></c:import>