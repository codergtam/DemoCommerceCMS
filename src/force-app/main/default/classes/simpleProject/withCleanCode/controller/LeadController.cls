public with sharing class LeadController {

    @AuraEnabled
    public static String createLead(String firstName, String lastName, String email, String company, String leadSource) {
        try {
            // 1. Map UI Input to Domain Object
            LeadDomain leadDomain = new LeadDomain(firstName, lastName, email, company, leadSource);

            // 2. Instantiate Use Case and Repositories (using simple factory for POC - DI Container in real app)
            LeadRepositoryInterface leadRepository = new LeadRepository(); // Instantiate Repository Implementation
            CreateLeadUseCase createLeadUseCase = new CreateLeadUseCase(leadRepository); // Inject Repository

            // 3. Execute Use Case
            Id leadId = createLeadUseCase.execute(leadDomain);

            return leadId; // Return Lead Id for UI feedback

        } catch (DomainException domainEx) {
            // Handle Domain Validation Errors - Return user-friendly message to UI
            throw new AuraHandledException(domainEx.getMessage());
        } catch (InfrastructureException infraEx) {
            // Handle Infrastructure/Data Access Errors - Log and return generic error to UI
            System.debug('Infrastructure Error creating Lead: ' + infraEx.getMessage());
            throw new AuraHandledException('An unexpected error occurred while creating the Lead. Please contact support.');
        } catch (Exception ex) {
            // Generic Exception Handling - Log and return generic error to UI
            System.debug('Unexpected Error creating Lead: ' + ex.getMessage() + ' Stack Trace: ' + ex.getStackTraceString());
            throw new AuraHandledException('An unexpected error occurred. Please contact support.');
        }
    }
}