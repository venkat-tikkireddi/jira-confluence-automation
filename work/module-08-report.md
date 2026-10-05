# Module 08 Completion Report

## Tracked Files
```text
.gitignore
README.md
calculator.py
main.py
project_spec.md
```

## Spec Commit History
```text
323bd0d (HEAD -> master) My first Webapp changes
```

## project_spec.md Contents
````markdown
# Project Specification: Internal Release Management Web App

**Status:** Initial draft from requirements interview; open decisions are listed below.

## 1. Product Overview

Build an internal web application that gives internal customers visibility into ongoing and future software releases. The product owner manages a 20-person Agile team.

The application will use an Excel workbook stored in SharePoint as its release data source. Authorized edits made in the app must be written back to that workbook; Excel is the designated source of truth.

## 2. User Roles and Permissions

| Role | Permissions |
| --- | --- |
| Release manager | Create releases, add release information, and edit release details. |
| Product owner | Edit release scope. Other release fields are not confirmed as editable. |
| Internal customer | View release information only. |

The authentication provider, identity mapping, and role assignment process have not yet been selected.

## 3. Functional Requirements

1. Show releases that are ongoing or planned for the future.
2. Display release dates, scope, and overall status.
3. Represent release components or lifecycle stages, including:
   - Code freeze
   - QA
   - UAT
   - Production
4. Allow release managers to create releases and maintain release information.
5. Allow product owners to edit release scope.
6. Provide internal customers read-only access to release information.
7. Persist application edits back to the SharePoint-hosted Excel workbook.

## 4. Data and Integration

- **Data source:** Excel workbook in SharePoint.
- **Authority:** Excel is the source of truth; application edits must be written back to it.
- **Release data identified so far:** dates, scope, overall status, and lifecycle-stage information for code freeze, QA, UAT, and production.
- **Workbook details:** File location, worksheet/table name, column schema, and whether an existing workbook is available are still unknown.
- **Integration approach:** To be selected after confirming organizational authentication and workbook details. Microsoft Graph is a candidate, not yet a confirmed implementation choice.

## 5. Data Refresh Frequency

The application shall refresh release data from the SharePoint Excel workbook once per day.

## 6. Security and Access

- Enforce role-based permissions for release managers, product owners, and internal customers.
- Internal customers must not be able to modify release data.
- Protect SharePoint credentials and tokens; do not expose secrets in client-side code or reports.
- Authentication, authorization source, audit requirements, and data-handling constraints require confirmation.

## 7. Open Decisions

1. Does the SharePoint workbook already exist, and what are its location, table structure, and columns?
2. How should users authenticate, and who assigns release-manager and product-owner roles?
3. Should app edits write to Excel immediately or be saved in batches? How should simultaneous edits or sync failures be handled?
4. What are the allowed values and transitions for overall release status and each lifecycle stage? Should each stage have its own dates, owner, and notes?
5. What release list views, filters, and search capabilities are needed?
6. Are notifications, comments, change history, or approval workflows required?
7. What hosting environment, supported browsers, accessibility target, and operational constraints apply?

## 8. Out of Scope for This Draft

- Jira integration; Excel in SharePoint is the currently specified source.
- Detailed UI design, technology stack, deployment plan, and implementation tasks; these depend on answers to the open decisions.
````