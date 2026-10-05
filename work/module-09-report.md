# Module 09 Completion Report

## Tracked Files
```text
.gitignore
README.md
backlog.md
calculator.py
main.py
project_spec.md
```

## Backlog Commit History
```text
bec9218 (HEAD -> master) created backlog file
```

## backlog.md Contents
````markdown
# Implementation Backlog: Internal Release Management Web App

## Planning Assumptions

- The first usable release prioritizes read-only release visibility for internal customers; role-based editing and Excel write-back follow after the SharePoint integration details are confirmed.
- SharePoint-hosted Excel remains the source of truth and release data refreshes daily.
- Microsoft Graph is a candidate integration, not a confirmed technology choice.
- All tasks are initially unchecked; estimates, owners, and delivery dates have not been assigned.

## Phase 1: Setup

- [ ] Confirm whether the SharePoint workbook already exists; record its site, drive, file, worksheet, and structured table names.
- [ ] Document the workbook columns for release name, dates, scope, overall status, and Code Freeze, QA, UAT, and Production stages.
- [ ] Agree allowed values and validation rules for release status and lifecycle-stage status.
- [ ] Confirm whether each lifecycle stage needs its own target date, actual date, owner, and notes.
- [ ] Select the application framework, hosting target, supported browsers, and deployment environments.
- [ ] Select the authentication provider and document how users are assigned Release Manager, Product Owner, and Internal Customer roles.
- [ ] Confirm the approved SharePoint integration method and the least-privilege permissions required for reading and updating the workbook.
- [ ] Create local development, test, and production configuration without committing credentials or tokens.
- [ ] Agree the daily refresh time, timezone, and behavior when a refresh fails.

## Phase 2: Core Features

### MVP: Release Visibility

- [ ] Build a release list view that separates ongoing releases from future releases.
- [ ] Show release name, release dates, scope summary, and overall status in the list.
- [ ] Build a release detail view with scope and Code Freeze, QA, UAT, and Production stage information.
- [ ] Add clear visual status indicators for overall release status and each stage.
- [ ] Enforce read-only behavior for Internal Customers in the interface.
- [ ] Add filters for ongoing/future releases and status, if confirmed during requirements review.
- [ ] Add loading, empty, stale-data, and recoverable-error states.

### Follow-up: Role-Based Editing

- [ ] Let Release Managers create releases and add or edit all approved release fields.
- [ ] Let Product Owners edit release scope without granting access to other protected fields.
- [ ] Keep Internal Customer access read-only, including through direct API requests.
- [ ] Validate required fields, date ordering, and permitted status transitions before saving.
- [ ] Show save success or actionable validation and save errors to the editor.

## Phase 3: Integration

- [ ] Implement secure authentication to the selected SharePoint/Excel API using the approved identity flow.
- [ ] Read release rows from the agreed Excel table and map them to the application's release model.
- [ ] Refresh cached/displayed release data from Excel once per day.
- [ ] Record and display the last successful refresh time; surface refresh failures without exposing secrets.
- [ ] Write authorized application edits back to the Excel source of truth.
- [ ] Define and implement behavior for simultaneous edits, stale data, partial writes, retries, and duplicate requests.
- [ ] Validate Excel data on import and report malformed rows without silently dropping releases.
- [ ] Confirm whether manual refresh is needed in addition to the daily refresh.

## Phase 4: Testing

- [ ] Unit-test workbook-to-release mapping, field validation, status mapping, and date handling.
- [ ] Test loading ongoing and future releases, release details, empty results, and API failures.
- [ ] Verify the daily refresh runs at the configured time and recovers after transient failures.
- [ ] Integration-test reading from and writing to a non-production SharePoint workbook.
- [ ] Test concurrent edits and verify that failed or conflicting writes do not silently lose data.
- [ ] Test the permission matrix: Release Manager full edit, Product Owner scope edit, Internal Customer read-only.
- [ ] Verify API endpoints enforce the same permissions as the UI.
- [ ] Run accessibility, supported-browser, and end-to-end acceptance checks with representatives of each user role.
- [ ] Complete user acceptance testing for the release list, detail view, stage tracking, and editing workflows.

## Phase 5: Documentation

- [ ] Document local setup, required configuration, and how to run the application and tests.
- [ ] Document SharePoint workbook location, table schema, permissions, and data validation rules.
- [ ] Write a user guide for viewing releases and editing fields permitted by each role.
- [ ] Write an administrator guide for role assignment and credential rotation.
- [ ] Document the daily refresh schedule, last-refresh indicator, and recovery steps for integration failures.
- [ ] Record known limitations, operational ownership, and deployment/rollback steps.
````