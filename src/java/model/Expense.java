package model;

import java.sql.Timestamp;

public class Expense {
    private int id;
    private int userId;
    private String category;
    private double amount;
    private Timestamp date;

    public Expense() {}

    public Expense(int id, int userId, String category, double amount, Timestamp date) {
        this.id = id;
        this.userId = userId;
        this.category = category;
        this.amount = amount;
        this.date = date;
    }

    // --- Getters and Setters ---
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getCategory() {
        return category;
    }

    public void setCategory(String category) {
        this.category = category;
    }

    public double getAmount() {
        return amount;
    }

    public void setAmount(double amount) {
        this.amount = amount;
    }

    public Timestamp getDate() {
        return date;
    }

    public void setDate(Timestamp date) {
        this.date = date;
    }
}
