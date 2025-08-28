package com.bcp.expenses;

import java.math.BigDecimal;
import io.smallrye.config.ConfigMapping;

@ConfigMapping( prefix = "expense" )
public interface ExpenseConfiguration {
    BigDecimal maxAmount();
}