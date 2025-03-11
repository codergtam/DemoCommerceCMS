// Domain Entity - Lead (Simplified - mirrors Salesforce Lead object fields we need for domain logic)
public class LeadDomain {
    public String firstName { get; set; }
    public String lastName { get; set; }
    public String email { get; set; }
    public String company { get; set; }
    public String leadSource { get; set; }

    public LeadDomain(String firstName, String lastName, String email, String company, String leadSource) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.email = email;
        this.company = company;
        this.leadSource = leadSource;
    }

    // Domain Business Rule - Example: Validate Lead Source
    public Boolean isValidLeadSource() {
        // Example business rule - only allow 'Web' or 'Referral' as valid sources for now.
        return new List<String>{'Web', 'Referral'}.contains(leadSource);
    }
}