public class LeadRepository implements LeadRepositoryInterface {
    public Id create(Lead leadSObject) {
        try {
            Database.SaveResult result = Database.insert(leadSObject, true); // Using Database.insert for error handling
            if (result.isSuccess()) {
                return result.getId();
            } else {
                // Convert DML Error to a more generic Exception (or custom Infrastructure Exception) if needed for higher layers.
                throw new InfrastructureException('Error creating Lead: ' + result.getErrors());
            }
        } catch (DMLException e) {
            throw new InfrastructureException('Database Exception creating Lead: ' + e.getMessage());
        }
    }
}