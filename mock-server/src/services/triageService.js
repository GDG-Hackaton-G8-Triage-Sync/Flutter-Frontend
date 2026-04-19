function deriveUrgency(description) {
    const urgency = Math.min(100, Math.max(10, description.length / 4));
    return Math.round(urgency);
}

function derivePriority(urgencyScore) {
    if (urgencyScore > 80) return 1;
    if (urgencyScore > 60) return 2;
    if (urgencyScore > 40) return 3;
    return 4;
}

function deriveCondition(priority) {
    return priority <= 2 ? "Urgent Review Required" : "Standard Assessment";
}

module.exports = { deriveUrgency, derivePriority, deriveCondition };
