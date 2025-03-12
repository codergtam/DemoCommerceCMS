@IsTest
public class MockAnId {
    private static Integer fakeIdAutoNumber = 1;

    public static String forType(Schema.SObjectType objectType) {
        return forType(objectType, fakeIdAutoNumber++);
    }

    public static String forType(Schema.SObjectType objectType, Integer fakeId) {
        return objectType.getDescribe().getKeyPrefix() + String.valueOf(fakeId).leftPad(12, '0');
    }
}