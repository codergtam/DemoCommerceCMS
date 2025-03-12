public class CreateLeadUseCase {
    private final LeadRepositoryInterface leadRepository; // Dependency Inversion

    public CreateLeadUseCase(LeadRepositoryInterface leadRepository) {
        this.leadRepository = leadRepository;
    }

    public Id execute(LeadDomain leadDomain) {
        if (!leadDomain.isValidLeadSource()) {
            throw new DomainException('Invalid Lead Source. Must be Web or Referral.'); // Example Domain Exception
        }

        // Map Domain Lead to SObject (Data Model)
        Lead leadSObject = new Lead();
        leadSObject.FirstName = leadDomain.firstName;
        leadSObject.LastName = leadDomain.lastName;
        leadSObject.Email = leadDomain.email;
        leadSObject.Company = leadDomain.company;
        leadSObject.LeadSource = leadDomain.leadSource;
        leadSObject.Status = 'Open - Not Contacted'; // Set initial status

        return leadRepository.create(leadSObject); // Delegate data persistence to Repository
    }
}