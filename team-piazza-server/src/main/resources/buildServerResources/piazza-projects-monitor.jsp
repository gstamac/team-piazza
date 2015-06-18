<!--
Copyright (C) 2007-2009 Nat Pryce.

This file is part of Team Piazza.

Team Piazza is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 3 of the License, or
(at your option) any later version.

Team Piazza is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program. If not, see <http://www.gnu.org/licenses/>.
-->
<%@ include file="/include.jsp" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" session="true" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">

<jsp:useBean id="projects" type="java.util.List<com.natpryce.piazza.ProjectMonitorViewState>" scope="request"/>
<jsp:useBean id="anyProjectBuilding" type="java.lang.Boolean" scope="request"/>

<jsp:useBean id="columns" type="java.lang.Integer" scope="request"/>

<jsp:useBean id="resourceRoot" type="java.lang.String" scope="request"/>

<jsp:useBean id="version" type="java.lang.String" scope="request"/>

<html>
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <title>Piazza</title>
    <meta http-equiv="refresh" content="${anyProjectBuilding ? 1 : 10}">
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>${resourceRoot}piazza2.css"/>
</head>
<body>
<div class="Projects">
<fmt:formatNumber var="columnWidth" value="${(100 / columns) - 1}" maxFractionDigits="0" scope="request"/>
<%--@elvariable id="project" type="com.natpryce.piazza.ProjectMonitorViewState"--%>
<c:forEach var="project" items="${projects}">
	<div class="Project ${project.status}" style="width: ${columnWidth}%;">
		<div class="ProjectName ${project.status}">${project.projectName}</div>
		<div class="Builds">
			<c:if test="${not showFeatureBranchBuildsOnly}">
				<%--@elvariable id="build" type="com.natpryce.piazza.BuildTypeMonitorViewState"--%>
				<c:forEach var="build" items="${project.builds}">
					<div class="Build ${build.status}">
						<div class="BuildDescription">
							<div class="BuildName">${build.name} #${build.buildNumber}</div>
							<c:if test="${build.building}">
								<div class="ProgressBar ${build.runningBuildStatus}" style="width: ${build.completedPercent}%;"></div>
							</c:if>
							<div class="Activity">
								${build.building ? build.activity : build.investigationInfo.description}
								<c:if test="${build.tests.anyHaveRun}">
									(Tests passed: ${build.tests.passed},
									failed: ${build.tests.failed},
									ignored: ${build.tests.ignored})
								</c:if>
							</div>
						</div>
					</div>
				</c:forEach>
			</c:if>
			<c:if test="${project.featureBranchesView.showFeatureBranches}">
		        <%--@elvariable id="featureBranch" type="com.natpryce.piazza.featureBranches.FeatureBranchMonitorViewState"--%>
				<c:forEach var="featureBranch" items="${project.featureBranchesView.featureBranches}">
					<%--@elvariable id="buildType" type="com.natpryce.piazza.featureBranches.BuildTypeWithLatestBuildMonitorViewState"--%>
					<c:forEach var="buildType" items="${featureBranch.buildTypes}">
						<div class="Build ${buildType.runningBuildStatus}">
							<div class="BuildDescription">
								<div class="BuildName"><span class="BranchName">${featureBranch.name}</span> ${buildType.name} #${buildType.buildNumber}</div>
								<c:if test="${buildType.building}">
									<div class="ProgressBar ${buildType.runningBuildStatus}" style="width: ${buildType.completedPercent}%;"></div>
								</c:if>
								<div class="Activity">
									${buildType.building ? buildType.activity : buildType.investigationInfo.description}
									<c:if test="${buildType.tests.anyHaveRun}">
										(Tests passed: ${buildType.tests.passed},
										failed: ${buildType.tests.failed},
										ignored: ${buildType.tests.ignored})
									</c:if>
								</div>
							</div>
						</div>
					</c:forEach>
				</c:forEach>
			</c:if>
		</div>
	</div>
</c:forEach>
</div>

<div class="Version">
    Team Piazza version ${version}
</div>

</body>
</html>
