const MEDICAL_KEYWORDS = [
    { words: ["chest pain", "heart", "cardiovascular", "breathless", "palpitations"], score: 95, condition: "Suspected Cardiac Event", reason: "Potential acute coronary syndrome. Presenting symptoms include high-risk thoracic indicators." },
    { words: ["stroke", "numbness", "speech", "paralysis", "vision"], score: 90, condition: "Neurological Alert", reason: "F.A.S.T. markers detected. High risk of cerebrovascular accident." },
    { words: ["breathing", "respiratory", "asthma", "gasping", "cyanosis"], score: 85, condition: "Respiratory Distress", reason: "Compromised airway/breathing detected. Immediate oxygen saturation check required." },
    { words: ["bleeding", "hemorrhage", "cut", "wound", "blood"], score: 70, condition: "Acute Hemorrhage", reason: "Active bleeding reported. Requires pressure and evaluation for surgical closure." },
    { words: ["fever", "infection", "shaking", "sepsis", "flu"], score: 60, condition: "Systemic Infection", reason: "High triage score due to potential sepsis or severe viral syndrome." },
    { words: ["broken", "fracture", "bone", "fall", "injury"], score: 50, condition: "Trauma/Orthopedic", reason: "Structural integrity compromised. X-ray and immobilization required." },
    { words: ["headache", "migraine", "pain", "dizzy"], score: 30, condition: "Non-Acute Pain", reason: "Primary symptom is pain without immediate life-threat markers." }
];

function deriveTriageLogic(description) {
    const lowerDesc = description.toLowerCase();
    let topMatch = null;
    let maxWeight = 0;

    for (const item of MEDICAL_KEYWORDS) {
        const matches = item.words.filter(w => lowerDesc.includes(w)).length;
        if (matches > 0) {
            const weight = matches * 20 + item.score; // Higher density of keywords = higher relevance
            if (weight > maxWeight) {
                maxWeight = weight;
                topMatch = item;
            }
        }
    }

    if (!topMatch) {
        return {
            urgencyScore: Math.min(40, Math.max(10, description.length / 5)),
            priority: 4,
            condition: "General Assessment",
            reasoning: "General presentation. Symptoms do not map to high-risk clinical templates.",
            confidence: 0.65
        };
    }

    const urgencyScore = Math.min(100, topMatch.score + (description.length / 10));
    let priority = 4;
    if (urgencyScore > 80) priority = 1;
    else if (urgencyScore > 65) priority = 2;
    else if (urgencyScore > 45) priority = 3;

    return {
        urgencyScore: Math.round(urgencyScore),
        priority,
        condition: topMatch.condition,
        reasoning: topMatch.reason,
        confidence: 0.7 + (Math.random() * 0.25) // Simulate AI confidence
    };
}

module.exports = { deriveTriageLogic };

