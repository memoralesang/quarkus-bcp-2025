package com.bcp;

import io.smallrye.config.ConfigMapping;

import java.math.BigDecimal;

@ConfigMapping(prefix = "expense")
public interface ExpenseConfiguration {
    BigDecimal maxAmount();
}
