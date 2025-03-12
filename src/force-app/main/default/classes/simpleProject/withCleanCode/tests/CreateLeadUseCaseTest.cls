@IsTest
private class CreateLeadUseCaseTest {

    @IsTest
    static void testCreateLead_ValidInput_Success() {
        // Arrange
        LeadRepositoryMock mockRepository = new LeadRepositoryMock(); // Mock Repository
        CreateLeadUseCase useCase = new CreateLeadUseCase(mockRepository);

        LeadDomain validLeadDomain = new LeadDomain('Test', 'Lead', 'test@example.com', 'Test Co', 'Web');

        // Act
        Id leadId = useCase.execute(validLeadDomain);

        // Assert
        System.assertNotEquals(null, leadId, 'Lead ID should be returned on success');
        System.assertEquals(1, mockRepository.insertCalls, 'Repository create method should be called once');
        System.assertEquals('Open - Not Contacted', mockRepository.insertedLead.Status, 'Initial Lead Status should be set');
    }

    @IsTest
    static void testCreateLead_InvalidLeadSource_DomainException() {
        // Arrange
        LeadRepositoryMock mockRepository = new LeadRepositoryMock(); // Mock Repository
        CreateLeadUseCase useCase = new CreateLeadUseCase(mockRepository);

        LeadDomain invalidLeadDomain = new LeadDomain('Test', 'Lead', 'test@example.com', 'Test Co', 'Other Source'); // Invalid Lead Source

        // Act & Assert
        try {
            useCase.execute(invalidLeadDomain);
            System.assert(false, 'Expected DomainException was not thrown'); // Should not reach here
        } catch (DomainException domainEx) {
            System.assert(true, 'DomainException was thrown as expected');
            System.assertEquals('Invalid Lead Source. Must be Web or Referral.', domainEx.getMessage(), 'Correct Domain Exception Message');
            System.assertEquals(0, mockRepository.insertCalls, 'Repository create method should NOT be called on validation failure');
        }
    }

    @IsTest
    static void testCreateLead_DatabaseError_InfrastructureException() {
        // Arrange
        LeadRepositoryFailingMock failingMockRepository = new LeadRepositoryFailingMock(); // Mock Repository that simulates DB error
        CreateLeadUseCase useCase = new CreateLeadUseCase(failingMockRepository);

        LeadDomain validLeadDomain = new LeadDomain('Test', 'Lead', 'test@example.com', 'Test Co', 'Web');

        // Act & Assert
        try {
            useCase.execute(validLeadDomain);
            System.assert(false, 'Expected InfrastructureException was not thrown'); // Should not reach here
        } catch (InfrastructureException infraEx) {
            System.assert(true, 'InfrastructureException was thrown as expected');
            System.assertNotEquals(null, infraEx.getMessage(), 'Infrastructure Exception should have a message'); // **Corrected assertNotEmpty to assertNotEquals(null, ...)**
        }
    }


    // **Mock Repository Implementations for Testing - In-Memory Mocks**

    // Mock for Successful Repository Scenario
    private class LeadRepositoryMock implements LeadRepositoryInterface {
        public Integer insertCalls = 0;
        public Lead insertedLead;

        public Id create(Lead leadSObject) {
            insertCalls++;
            insertedLead = leadSObject;
            return MockAnId.forType(Lead.SObjectType); 
        }
    }

    // Mock for Repository that Simulates Database Error
    private class LeadRepositoryFailingMock implements LeadRepositoryInterface {
        public Id create(Lead leadSObject) {
            // Simulate a DML Exception
            throw new DMLException('Simulated database error during insert.');
        }
    }
}