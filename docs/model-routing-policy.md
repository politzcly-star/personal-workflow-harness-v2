# Task-first model routing (v6.2)

The Human/platform-selected root owns accepted delivery and is never silently switched. Model choice is optional optimization, not a fixed relay or a reason to pause ordinary work. Follow the live tool's model-selection and delegation permissions. S1/S2 default to root-direct; delegate only concrete independent work with a useful time/context benefit.

## Preferred roles when supported and authorized

| Stable role ID | Configured model / effort | Work |
| --- | --- | --- |
| luna_qa | gpt-6-luna / high | Narrow read-only scan, classification, evidence or repetitive inspection |
| terra_worker | gpt-6-sol / medium | Bounded implementation and integration |
| luna_verifier | gpt-6-sol / high | Non-author review of a materially changed sensitive boundary |
| sol_planner | gpt-6-sol / medium | Optional consequential design tradeoff; never an automatic phase |

Old role IDs are compatibility names, not old model routes; only these current files remain active. Ordinary small, test-backed edits may use a supported generic worker with explicit gpt-6-luna/high when selection is permitted. Do not force a read-only role to write. Do not require Astra coordination or a separate Sol manager for every task. High/max/ultra are not universal quality or economy guarantees.

Give a child the goal, exact allowed scope, acceptance evidence and stop/escalation condition. Prefer short packets over full-history forks; some runtimes cannot override models on full-history forks. The child returns paths, findings/checks and one concrete unresolved question, not an exploration transcript. Escalate ambiguous or failing work with new evidence, not the same broad prompt at a more expensive model. No automatic QA plus verifier pass over the same scope.

## Capability fallback within the current channel

1. Use actual exposed role/model/effort support; configuration or model-list presence alone is not a successful tool-capable request. Never probe model identity through prose.
2. If a preferred role/model is absent or explicitly rejected as unsupported, mark that route unavailable for this session/channel. Do not retry it unchanged. Use an authorized supported generic role with a suitable model/effort, or omit overrides to inherit the current working root model. A custom role pinned to a rejected model is not an inherited-model fallback.
3. If effort alone is rejected, use a supported effort/model pair within existing authority; do not silently drop reasoning/tool capability needed by the task. For API-backed agents, reasoning with tools needs compatible Responses support; a model-list result is insufficient.
4. If delegation is unavailable, continue safe root work. S1/S2 need no invented review gate. Where independent review is actually required, leave that boundary pending; do not label self-review independent or block unrelated work.
5. Authentication/permission failure or exhausted account quota is not a model-not-found error: stop affected calls, preserve progress, report the precise category and continue offline work where possible. Never rotate credentials/providers to bypass limits. Transient network/rate-limit errors get only bounded evidence-backed recovery, respecting server retry guidance; do not spin through model names.
6. A user-selected login/provider change invalidates prior capability assumptions. Resume from a compact handoff plus current source/dirty/evidence state. Do not rewrite auth, provider, root or global defaults. Do not keep rejecting an unsupported optional route before every child.

This is agent scheduling policy, not an installed automatic provider router. Runtime tool/schema rules prevail. Separate configured model, tool-declared support, observed request outcome and trusted backend identity; unknown stays unknown. Modern standalone role discovery and legacy config registration are separate inventory facts. scripts/runtime-inspect.py makes no live requests.

Use only normal authorized work for passive observations: requested role/model/effort, channel class (no secrets), acceptance/repair, elapsed time and available usage. No paid A/B/probes or new monitors. Compare total accepted-task cost including children and rework; do not convert official API prices into subscription or proxy bills.
