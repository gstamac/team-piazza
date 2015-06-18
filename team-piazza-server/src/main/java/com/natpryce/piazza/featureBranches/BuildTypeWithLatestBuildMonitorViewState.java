/*
 * Copyright (c) 2012 Nat Pryce, Timo Meinen, Frank Bregulla.
 *
 * This file is part of Team Piazza.
 *
 * Team Piazza is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * (at your option) any later version.
 *
 * Team Piazza is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */
package com.natpryce.piazza.featureBranches;

import com.natpryce.piazza.BuildStatus;
import com.natpryce.piazza.TestStatisticsViewState;
import com.natpryce.piazza.InvestigationViewState;
import jetbrains.buildServer.serverSide.SBuild;
import jetbrains.buildServer.serverSide.SBuildType;
import jetbrains.buildServer.serverSide.SRunningBuild;
import jetbrains.buildServer.serverSide.ShortStatistics;
import jetbrains.buildServer.responsibility.ResponsibilityEntry;

import java.util.Date;

/**
 * @author fbregulla
 */
public class BuildTypeWithLatestBuildMonitorViewState {

    private SBuild build;
    private SBuildType buildType;
    private final TestStatisticsViewState tests;
    private final InvestigationViewState investigationInfo;

    public BuildTypeWithLatestBuildMonitorViewState(SBuild build) {
        this.build = build;
        buildType = build.getBuildType();
        this.tests = testStatistics();
        this.investigationInfo = createInvestigationState();
    }

    public Date getStartDate() {
        return build.getStartDate();
    }

    public String getRunningBuildStatus() {
        return getBuildStatus().toString();
    }

    public BuildStatus getBuildStatus() {
        if (build.getBuildStatus().isFailed()) {
            return BuildStatus.FAILURE;
        } else {
            return BuildStatus.SUCCESS;
        }
    }

    public boolean isBuilding() {
        return build instanceof SRunningBuild;
    }

    public TestStatisticsViewState getTests() {
        return tests;
    }

    public InvestigationViewState getInvestigationInfo() {
        return investigationInfo;
    }

    public String getActivity() {
        if (isBuilding()) {
            return ((SRunningBuild) build).getShortStatistics().getCurrentStage();
        } else {
            return "";
        }
    }

    public int getCompletedPercent() {
        if (isBuilding()) {
            return ((SRunningBuild) build).getCompletedPercent();
        } else {
            return 100;
        }
    }

    private TestStatisticsViewState testStatistics() {
        if (isBuilding()) {
            ShortStatistics stats = ((SRunningBuild) build).getShortStatistics();
            return new TestStatisticsViewState(
                    stats.getPassedTestCount(), stats.getFailedTestCount(), stats.getIgnoredTestCount());
        } else {
            return new TestStatisticsViewState(0, 0, 0);
        }
    }

    private InvestigationViewState createInvestigationState() {
        ResponsibilityEntry responsibilityInfo = this.buildType.getResponsibilityInfo();
        if (responsibilityInfo.getState() != ResponsibilityEntry.State.NONE) {
            return new InvestigationViewState(responsibilityInfo.getState(), responsibilityInfo.getResponsibleUser().getDescriptiveName(), responsibilityInfo.getComment());
        } else {
            return new InvestigationViewState();
        }
    }

    public String getName() {
        return buildType.getName();
    }

	public String getBuildNumber() {
        return build.getBuildNumber();
    }
}
