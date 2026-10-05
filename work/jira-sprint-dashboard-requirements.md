# Jira Sprint Progress Dashboard Requirements

## Purpose
Provide a private Jira dashboard for monitoring the team's progress during its active sprint.

## Confirmed Requirements
- **Platform:** A dashboard inside Jira.
- **Project:** `EPMCDMETST`.
- **Sprint:** Focus on the currently active sprint.
- **Visibility:** Private to the requesting user.
- **Estimation:** Use story points.
- **Progress views:** Show issues by workflow status, story points committed versus completed, and a sprint burndown.
- **Risk views:** Include blocked and at-risk work.

## Proposed Risk Definition
The at-risk criteria are not confirmed yet. Recommended starting rule: flag blocked issues, overdue issues, and incomplete high-priority issues.

## Open Implementation Details
- Identify the Scrum board for `EPMCDMETST` if the project has multiple boards.
- Confirm the at-risk rule before implementation.
- Determine whether the dashboard should refresh automatically and, if so, how often.

## Scope Notes
The dashboard is intended to cover the team's active-sprint issues; no creator-only filter was requested for this dashboard. The separate weekly status report request is out of scope.
