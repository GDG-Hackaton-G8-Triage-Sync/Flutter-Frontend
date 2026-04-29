# TriageSync Backend Improvement Handoff (48-Hour Sprint)

## Objective
Deliver only the highest-impact backend slices needed for a strong final demo with reliable Flutter integration.

## Priority Order (Do In This Exact Order)

1. API reliability and safety
2. Staff clinical workflow support
3. Admin command center and audit data
4. AI copilot contract (guarded)
5. Interoperability proof endpoint

---

## 1) API Reliability and Safety (P0)

### A. Idempotency for symptom submit
- Endpoint: `POST /api/triage/`
- Requirement:
  - Read header `Idempotency-Key`
  - If same key + same patient within 5 minutes, return previous created triage item instead of creating a duplicate
- Response behavior:
  - `201` for first creation
  - `200` with existing record for duplicate replay

### B. Rate limiting
- Endpoint: `POST /api/triage/`
- Requirement:
  - Max 5 submissions per patient per 10 minutes
- Response behavior:
  - `429` with body `{ "error": "Rate limit exceeded" }`

### C. Consistent error schema
- All endpoints should return:
```json
{
  "error": "Human readable message",
  "code": "MACHINE_CODE",
  "details": {}
}
```

---

## 2) Staff Clinical Workflow Support (P0)

### A. Vitals model + API
Add persistent fields linked to triage case:
- `bp_systolic`
- `bp_diastolic`
- `heart_rate`
- `spo2`
- `recorded_by`
- `recorded_at`

Endpoints:
- `POST /api/staff/patient/{id}/vitals/`
- `GET /api/staff/patient/{id}/vitals/latest/`

### B. Reassessment SLA flag
- Rule: if triage status is `waiting` and no vitals update for > 30 minutes, mark `sla_breach=true`
- Include `sla_breach` in:
  - `GET /api/dashboard/staff/patients/`
  - websocket updates for affected patient

### C. WebSocket event normalization
Use fixed event types only:
- `patient_created`
- `status_update`
- `priority_override`
- `sla_breach`
- `vitals_updated`

Payload contract:
```json
{
  "type": "status_update",
  "data": {
    "id": 101,
    "priority": 2,
    "status": "in_progress",
    "sla_breach": false,
    "updated_at": "2026-04-18T12:00:00Z"
  }
}
```

---

## 3) Admin Command Center + Audit Data (P0)

### A. Command center endpoint
- `GET /api/dashboard/admin/command-center/`
- Return:
```json
{
  "total_patients": 21,
  "waiting": 9,
  "in_progress": 7,
  "critical_cases": 3,
  "sla_breaches": 2,
  "backlog_risk": "medium"
}
```

### B. Audit log endpoint
- `GET /api/admin/audit-log/?limit=50`
- Return chronological entries:
```json
[
  {
    "id": "evt_001",
    "time": "2026-04-18T11:53:00Z",
    "actor": "staff@triagesync.com",
    "action": "STATUS_UPDATE",
    "target": "TRIAGE#101",
    "metadata": {"from": "waiting", "to": "in_progress"}
  }
]
```

### C. Required audit events
- triage created
- status updated
- priority overridden
- role changed
- patient deleted
- login success/failure

---

## 4) AI Copilot Contract (P1)

### A. Draft suggestion endpoint
- `POST /api/triage/ai-draft/`
- Input:
```json
{
  "description": "Severe chest pain and sweating",
  "photo_name": "optional.jpg"
}
```
- Output:
```json
{
  "suggested_priority": 1,
  "condition": "Suspected Cardiac Event",
  "department": "Cardiology",
  "confidence": 0.91,
  "reasoning": "Red-flag symptoms: chest pain + diaphoresis",
  "source": "ai_copilot"
}
```

### B. Nurse confirmation endpoint
- `POST /api/staff/patient/{id}/confirm-priority/`
- Input:
```json
{
  "approved_priority": 1,
  "approved": true,
  "reason": "matches presenting symptoms"
}
```

### C. Fallback behavior
- If AI unavailable/timeouts:
  - return deterministic rule-based score
  - set `source` to `fallback_rule_engine`

---

## 5) Interoperability Proof Endpoint (P1)

### A. FHIR-style patient export
- `GET /fhir/Patient/{id}`
- Return minimal valid FHIR-like structure:
```json
{
  "resourceType": "Patient",
  "id": "101",
  "identifier": [{"system": "triagesync", "value": "101"}],
  "name": [{"text": "Patient Demo"}],
  "extension": [{"url": "triage-priority", "valueInteger": 2}]
}
```

Note: This is a prototype integration proof, not full FHIR implementation.

---

## Non-Goals (Do Not Build In 48 Hours)
- SSO/SAML/Active Directory
- Billing/insurance flows
- Full DICOM viewer
- Full production compliance framework

---

## Demo-Readiness Acceptance Checklist
- [ ] Duplicate symptom submit does not create duplicate triage records
- [ ] Staff queue shows `sla_breach` correctly
- [ ] Vitals can be saved and latest vitals can be fetched
- [ ] Command center endpoint returns live summary
- [ ] Audit log endpoint returns latest events
- [ ] AI draft endpoint works with fallback mode
- [ ] FHIR endpoint returns valid JSON shape
- [ ] All error responses follow one schema
