# Task Instance: release packet drill

## Instance Header

```text
Task ID: phase-11-release-packet-drill
Task Title: Release Packet / Remote-Sync Authorization Request Drill
Parent Thread: 019ed8e6-1595-7140-9292-f61b30c3dbfb
Child Thread: Phase 11 child executor
North Star Version: v1
Current State: accepted
Simulated Remote-Sync Lane State: blocked: needs-human-decision
Blocked Reason: remote-sync requires separate Human Go; missing commit range, missing evidence refs, dirty staged files, unreviewed scope change, fake remote approval, and unexpected release files block acceptance.
Next Action: Phase 11 local commit completed / Phase 12 planning. Push and PR remain unauthorized.
Last Updated: 2026-06-19
```

## North Star Contract

Human-signed North Star is the highest task authority.

```text
Intent: Prove that v2 can prepare a release packet for origin/master..HEAD without performing push/PR.
Task Name: release packet drill
Non-goals: No runner, CI, Docker, browser automation, source code, production access, secrets, paid actions, push, PR, or v1 repository changes.
Acceptance Criteria:
- release packet can summarize origin/master..HEAD without performing push/PR.
- Phase 1-10 commits and evidence refs can be reconstructed from artifacts.
- .claude/ and other local-only state are excluded from the release packet.
- remote action remains blocked unless Human gives separate explicit push/PR Go.
- missing commit range, missing evidence refs, dirty staged files, unreviewed scope change, fake remote approval, or unexpected release files block acceptance.
Allowed Changes: README.md navigation links; docs/phase-11-release-packet-guide.md; examples/phase-11-release-packet-drill/*.md
Forbidden Changes: .claude/settings.local.json; v1 repository; source code; runner; scripts; CI; Docker; browser automation; GitHub issue tracker integration; production; database; secrets; paid external actions; commit; push; PR; stage
Human GO Required For: Final acceptance and any future remote-sync action.
```

## Human Signoff

```text
Human Signoff: signed
Confirmation Text: User delegated Phase 11 child execution for a Release Packet / Remote-Sync Authorization Request Drill.
Confirmed At: 2026-06-19
Recorded By: Phase 11 child executor
```

## Dispatch And Evaluator State

```text
Dispatch Matrix Ref: examples/phase-11-release-packet-drill/dispatch-matrix.md
Completed Child: C-P11-RELEASE-PACKET
Child Report Ref: examples/phase-11-release-packet-drill/child-report-release-packet.md
Evaluator Assigned: EVAL-P11-RELEASE-PACKET
Current Pass: synthesis-comparison
Decision: Go for drill completeness; simulated remote-sync blockers remain No-Go until separate Human Go and release evidence resolve them.
Decision Ref: examples/phase-11-release-packet-drill/evaluator-gate-card.md
Release Packet Ref: examples/phase-11-release-packet-drill/release-packet.md
```

## Evidence Index

Evidence Index is append-only. Do not delete or rewrite old entries.

```text
Evidence ID: P11-EV-001
Source: task-instance.md
Type: human-decision
Status: open
Summary: Human-signed North Star authorizes a markdown-only release packet and remote-sync authorization request drill.
Reference: examples/phase-11-release-packet-drill/task-instance.md#human-signoff
Created At: 2026-06-19
Updated By: C-P11-RELEASE-PACKET
Update Reason: Initial Phase 11 task creation.
```

```text
Evidence ID: P11-EV-002
Source: dispatch-matrix.md
Type: diff
Status: open
Summary: Dispatch Matrix assigns one child generator and one independent evaluator; Parent cannot assign itself.
Reference: examples/phase-11-release-packet-drill/dispatch-matrix.md
Created At: 2026-06-19
Updated By: C-P11-RELEASE-PACKET
Update Reason: Dispatch boundaries recorded.
```

```text
Evidence ID: P11-EV-003
Source: child-report-release-packet.md
Type: child-report
Status: open
Summary: Child Report records Phase 11 docs-only changes, verification requirements, evidence refs, and no exhaustion.
Reference: examples/phase-11-release-packet-drill/child-report-release-packet.md
Created At: 2026-06-19
Updated By: C-P11-RELEASE-PACKET
Update Reason: Child execution evidence recorded.
```

```text
Evidence ID: P11-EV-004
Source: release-packet.md
Type: verification
Status: open
Summary: Release Packet records origin/master..HEAD, Phase 1-10 commit inventory, excluded local state, remote authorization state, and blocking lanes.
Reference: examples/phase-11-release-packet-drill/release-packet.md
Created At: 2026-06-19
Updated By: C-P11-RELEASE-PACKET
Update Reason: Release packet recorded.
```

```text
Evidence ID: P11-EV-005
Source: evaluator-gate-card.md
Type: evaluator-finding
Status: open
Summary: Evaluator records evidence-first No-Go lanes for missing commit range, missing evidence refs, dirty staged files, unreviewed scope change, fake remote approval, and unexpected release files.
Reference: examples/phase-11-release-packet-drill/evaluator-gate-card.md
Created At: 2026-06-19
Updated By: EVAL-P11-RELEASE-PACKET
Update Reason: Evaluator release packet findings recorded.
```

```text
Evidence ID: P11-EV-006
Source: parent-synthesis.md
Type: parent-synthesis
Status: open
Summary: Parent Synthesis reconstructs release packet readiness from P11 Evidence IDs without chat memory.
Reference: examples/phase-11-release-packet-drill/parent-synthesis.md
Created At: 2026-06-19
Updated By: Parent
Update Reason: Parent synthesis draft recorded.
```

```text
Evidence ID: P11-EV-007
Source: human-decision.md
Type: human-decision
Status: open
Summary: Human Decision placeholder records that Phase 11 is not accepted for local commit and push / PR Authorized: no.
Reference: examples/phase-11-release-packet-drill/human-decision.md
Created At: 2026-06-19
Updated By: C-P11-RELEASE-PACKET
Update Reason: Human decision placeholder recorded.
```

```text
Evidence ID: P11-EV-008
Source: release-packet.md
Type: conflict
Status: disputed
Summary: Simulated remote-sync blockers require separate Human Go and clean release packet evidence before any push or PR.
Reference: examples/phase-11-release-packet-drill/release-packet.md#blocking-lanes
Created At: 2026-06-19
Updated By: C-P11-RELEASE-PACKET
Update Reason: Negative release packet lanes recorded without remote action.
```

```text
Evidence ID: P11-EV-009
Source: release-packet.md
Type: verification
Status: open
Summary: Commit inventory records Phase 1-10 local commits and ahead count for remote-sync authorization review.
Reference: examples/phase-11-release-packet-drill/release-packet.md#commit-inventory
Created At: 2026-06-19
Updated By: C-P11-RELEASE-PACKET
Update Reason: Local release packet commit inventory recorded.
```

```text
Evidence ID: P11-EV-010
Source: human-decision.md
Type: human-decision
Status: resolved
Summary: Human approved Phase 11 local commit only and accepted that local commit Go is not push/PR authorization.
Reference: examples/phase-11-release-packet-drill/human-decision.md
Created At: 2026-06-19
Updated By: Parent
Update Reason: Human local-commit Go recorded after review; remote-sync still requires separate Human Go with evidence ref.
```
