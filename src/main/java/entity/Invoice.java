package entity;

import jakarta.persistence.*;
import java.util.Date;

@Entity
@Table(name = "invoice")
public class Invoice {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column(name = "InvoiceID")
    private int InvoiceID;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "ContractID", nullable = false)
    private Contract contract;

    @Column(name = "IssueDate", nullable = false)
    @Temporal(TemporalType.DATE)
    private Date issueDate;

    @Column(name = "PaymentDate")
    @Temporal(TemporalType.DATE)
    private Date paymentDate;

    @Column(name = "Amount", nullable = false)
    private long amount;

    @Column(name = "PaymentStatus", nullable = false)
    private String paymentStatus;

    // Getters and Setters
    public int getInvoiceID() { return InvoiceID; }
    public void setInvoiceID(int invoiceID) { InvoiceID = invoiceID; }
    
    public Contract getContract() { return contract; }
    public void setContract(Contract contract) { this.contract = contract; }
    
    public Date getIssueDate() { return issueDate; }
    public void setIssueDate(Date issueDate) { this.issueDate = issueDate; }
    
    public Date getPaymentDate() { return paymentDate; }
    public void setPaymentDate(Date paymentDate) { this.paymentDate = paymentDate; }
    
    public long getAmount() { return amount; }
    public void setAmount(long amount) { this.amount = amount; }
    
    public String getPaymentStatus() { return paymentStatus; }
    public void setPaymentStatus(String paymentStatus) { this.paymentStatus = paymentStatus; }
    
}