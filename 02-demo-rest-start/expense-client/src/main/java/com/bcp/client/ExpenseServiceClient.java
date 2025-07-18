package com.bcp.client;

import com.bcp.model.Expense;
import jakarta.ws.rs.GET;
import jakarta.ws.rs.POST;

import java.util.Set;



public interface ExpenseServiceClient {

    @GET
    Set<Expense> getAll();

    @POST
    Expense create(Expense expense);
}

