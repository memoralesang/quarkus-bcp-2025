package com.bcp.event;

public class HighRiskAccountWasDetected {
    public Long bankAccountId;

    public HighRiskAccountWasDetected() {}

    public HighRiskAccountWasDetected(Long bankAccountId) {
        this.bankAccountId = bankAccountId;
    }
}
