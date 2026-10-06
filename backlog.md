# Weekly Stakeholder Status Report Automation Backlog

This backlog is derived from [project_spec.md](./project_spec.md). It is
ordered for an end-to-end MVP: establish the runtime and provider choices,
complete the report pipeline, integrate real sources and draft delivery, then
validate and document the service.

## Delivery guardrails

- Required sources are Jira, GitHub, primary Google Calendar, and the standard
  meeting-notes location unless the provider discovery phase documents an
  approved equivalent.
- A run must never send email automatically.
- Required-source failures must fail visibly; optional-source failures must be
  disclosed in the draft.
- Private, confidential, restricted, or uncertainly classified content must
  not enter the report.
- The default report limit is fewer than 300 words, configurable at runtime.
- Integration work is gated on completion of the provider/runtime decisions in
  Setup.

## Phase 1: Setup

- [x] Confirm the workspace runtime and conventions: Python project, configured
  `.venv` interpreter, and existing `status_report` package.
- [x] Preserve and reuse the existing provider-neutral primitives for
  `SourceItem`, `SourceClient`, `DataFetcher`, reporting windows, filtering,
  classification, five-section rendering, and word-count enforcement.
- [ ] Inventory the deployment target and select the scheduler mechanism that
  supports a weekly Friday-afternoon run in the user's local timezone.
- [ ] Compare candidate APIs/SDKs for Jira, GitHub, Google Calendar, the
  meeting-notes system, and the email draft provider.
- [ ] Decide how the authenticated user's default Jira project, current-login
  GitHub repository, primary calendar, standard notes location, and email
  contacts are resolved without a user-facing multi-resource configuration UI.
- [ ] Record provider decisions, API versions, required scopes, rate limits,
  timeout limits, retry behavior, and known privacy markers as an
  implementation decision record.
- [ ] Define the configuration schema for credentials, timezone, Friday run
  time, resource resolution, recipient override, word limit, retry policy, and
  optional-source behavior.
- [ ] Define the approved secret/environment mechanism and add safe example
  configuration with placeholders only.
- [ ] Define the run/audit event schema: reporting period, run timestamp,
  source status, item counts, draft identifier, and sanitized failure details.
- [ ] Add or update ignore rules so local environment files, tokens, OAuth
  caches, generated artifacts, and logs cannot be committed.
- [ ] Create the package/module layout for adapters, orchestration, scheduling,
  delivery, configuration, and audit logging while keeping report logic
  provider-independent.
- [ ] **Setup gate:** obtain approval for the provider/runtime decision record,
  configuration schema, permission list, and deployment assumptions before
  starting Integration.

## Phase 2: Core Features

### Reporting period and orchestration

- [ ] Implement timezone-aware Monday 00:00 through Friday 23:59:59.999999
  window calculation for the immediately preceding completed reporting period
  when the scheduled run occurs on Friday afternoon.
- [ ] Validate ambiguous and invalid timezone configuration and surface a
  clear configuration error.
- [ ] Add a run orchestrator that resolves the window, resolves required
  resources, fetches all sources, filters/classifies items, renders the report,
  and invokes draft delivery in a deterministic order.
- [ ] Define typed run results for success, partial-source availability,
  required-source failure, duplicate-draft suppression, and draft-creation
  failure.
- [ ] Add bounded retries with exponential backoff for transient provider
  failures; do not retry authentication, permission, validation, or
  not-found errors.

### Normalized data and privacy

- [ ] Extend the normalized source model only where needed to retain source
  identifiers, resource metadata, visibility classification, source timestamps,
  impact, mitigation, and traceable URLs without storing unnecessary content.
- [ ] Implement source-specific privacy/confidentiality marker mapping for
  Jira, GitHub, Calendar, and meeting notes.
- [ ] Default unknown or ambiguous visibility to excluded/flagged, never
  included.
- [ ] Ensure source adapters cannot bypass provider authorization or retrieve
  content outside the authenticated user's visibility.
- [ ] Deduplicate equivalent items across sources while retaining source
  attribution and stable identifiers for auditability.

### Classification and composition

- [ ] Verify completed-outcome rules for Jira resolution/Done statuses and
  GitHub merged pull requests; keep unmerged or unresolved work out of
  Outcomes.
- [ ] Implement risk/blocker rules for blocked work, overdue work, unresolved
  high-priority Jira items, and explicitly recorded meeting-note risks.
- [ ] Include source, impact, owner, mitigation, or next action when available
  without inventing missing details.
- [ ] Derive next-week priorities from supported open high-priority, blocked,
  overdue, explicit meeting-action, and relevant open GitHub items.
- [ ] Extract Decisions needed only from explicit decisions or unresolved
  source items requiring stakeholder input, including requested action and
  deadline when available.
- [ ] Populate Highlights from the most executive-relevant supported outcomes
  and avoid repeating identical bullets across sections.
- [ ] Render the required section order exactly: Highlights, Outcomes, Risks,
  Decisions needed, Next-week priorities.
- [ ] Render `- None this week` in every empty section.
- [ ] Enforce the configurable word limit with a clear failure or deterministic
  shortening strategy; never silently truncate a bullet or create unsupported
  claims.
- [ ] Include reporting-period and source metadata suitable for review without
  counting system-generated metadata against the report word limit.

### Failure and audit behavior

- [ ] Fail the run when a required default resource cannot be resolved, a
  required source cannot be read, or draft creation fails.
- [ ] Prevent a success-shaped draft when required data is incomplete.
- [ ] Allow a draft after an optional-source failure only when the body
  identifies the unavailable source and resulting limitation.
- [ ] Sanitize exception messages and audit fields so credentials, tokens,
  private content, and confidential note text never appear in logs.
- [ ] Persist or emit structured run audit records with source counts/statuses,
  failure details, and draft ID according to the selected runtime.

## Phase 3: Integration

### Provider adapters

- [ ] Implement Jira authentication and default-project resolution.
- [ ] Implement Jira collection for Done/resolved, blocked, overdue,
  unresolved high-priority, project-status, and milestone data within the
  reporting window.
- [ ] Implement GitHub authentication and current-login default-repository
  resolution.
- [ ] Implement GitHub collection for merged pull requests and relevant open
  work/review activity within the reporting window.
- [ ] Implement Google authentication and primary-calendar resolution.
- [ ] Implement Calendar collection for relevant meetings in the reporting
  window, excluding private events.
- [ ] Implement the meeting-notes adapter and standard-location resolution,
  including explicit risks, blockers, decisions, deadlines, and follow-up
  actions.
- [ ] Implement the selected email provider adapter with recipient resolution,
  subject generation, body insertion, and source/reporting-period metadata.
- [ ] Ensure the email adapter creates a draft only and has no send operation
  or send permission.

### Scheduling and runtime

- [ ] Wire the orchestrator to the selected scheduler for Friday afternoon in
  the configured local timezone.
- [ ] Make schedule, timezone, word limit, retry settings, resource settings,
  and recipient override configurable without code changes where the runtime
  supports it.
- [ ] Add idempotency for the reporting period by detecting an existing draft
  or persisted successful run before creating another draft.
- [ ] Define safe behavior for reruns after a partial or failed run.
- [ ] Add startup/configuration validation that reports all missing required
  settings before contacting providers.
- [ ] Configure operational logging, run status reporting, and alert/notification
  behavior for failed scheduled runs.
- [ ] Execute a sandbox or test-account end-to-end run and verify that no
  message is sent.

## Phase 4: Testing

### Unit and contract tests

- [ ] Test Monday-through-Friday window boundaries across weekdays, month
  boundaries, daylight-saving transitions, and configured timezones.
- [ ] Test required and optional source failure behavior, including sanitized
  errors and no misleading success result.
- [ ] Test privacy filtering for every provider marker, case/whitespace
  variants, and unknown visibility.
- [ ] Test default-resource resolution failure for each required provider.
- [ ] Test Jira outcome, blocker, overdue, high-priority, and milestone
  normalization.
- [ ] Test GitHub merged pull request outcome handling and exclusion of
  unmerged work from Outcomes.
- [ ] Test Calendar and notes normalization for private events, confidential
  notes, risks, decisions, deadlines, and actions.
- [ ] Test classification deduplication, traceable source attribution, and
  prevention of unsupported priorities or decisions.
- [ ] Test exact section order and `None this week` behavior for every empty
  section.
- [ ] Test executive formatting, duplicate suppression, metadata handling, and
  the under-300-word default limit.
- [ ] Test duplicate-draft detection, successful draft creation, and the
  guarantee that no send API is called.
- [ ] Test bounded retry/backoff behavior and non-retryable provider errors.
- [ ] Test audit records for success, partial availability, required failure,
  duplicate suppression, and delivery failure.

### Integration and acceptance tests

- [ ] Add provider-client contract tests using mocked API responses and
  representative permission/visibility failures.
- [ ] Run an end-to-end test with fixtures containing completed work, merged
  pull requests, risks, decisions, priorities, private items, and empty
  sections.
- [ ] Verify the generated subject includes the exact Monday-to-Friday period.
- [ ] Verify recipients are the configured contacts or explicit override and
  no automatic send occurs.
- [ ] Verify secrets are absent from source, fixtures, report body, ordinary
  logs, and audit output.
- [ ] Verify a required-source failure does not create a draft and an
  optional-source failure creates a clearly qualified draft.
- [ ] Run the project's formatter, linter, type checks, and focused test suite.
- [ ] Perform a scheduled-run smoke test in the target runtime and capture
  operational evidence for the release checklist.
- [ ] Map every acceptance criterion in `project_spec.md` to a passing test or
  documented operational verification.

## Phase 5: Documentation

- [ ] Update the project README with setup, local execution, test commands,
  configuration, scheduling, and the no-auto-send safety guarantee.
- [ ] Document provider authentication, minimum scopes, default-resource
  resolution, OAuth/service-account setup, and credential rotation.
- [ ] Document meeting-notes format and the privacy/confidentiality markers
  recognized by each provider.
- [ ] Document the report schema, five required sections, classification rules,
  word-limit behavior, and source metadata.
- [ ] Document failure states, retry behavior, idempotent reruns, audit fields,
  and troubleshooting steps for each provider.
- [ ] Document how to perform a dry run or test-account run and how to inspect
  the resulting draft without sending it.
- [ ] Document deployment and scheduler configuration for the selected runtime,
  including timezone and Friday execution-time behavior.
- [ ] Add a release checklist covering secrets, scopes, default resources,
  privacy filtering, no-send permissions, duplicate prevention, and rollback.
- [ ] Review all documentation and examples for real credentials, tokens,
  private source content, and unsupported claims before release.
- [ ] Perform a final acceptance review against all twelve acceptance criteria
  in `project_spec.md` and record any explicitly deferred work.

## Suggested milestone exit criteria

- **Setup complete:** provider/runtime decision record and configuration/security
  design approved.
- **Core Features complete:** orchestration can turn normalized fixtures into a
  compliant, auditable report and reject unsafe/incomplete runs.
- **Integration complete:** real authenticated adapters and scheduler create a
  reviewable draft without sending it, with duplicate prevention.
- **Testing complete:** critical unit, contract, integration, and acceptance
  paths pass in the target runtime.
- **Documentation complete:** an administrator can configure, run, troubleshoot,
  and safely review the service without source changes.
