class ContactInfo {
    private int phoneNumber;
    private String email;

    public ContactInfo(int pNumberIn, String emailIn){
        phoneNumber = pNumberIn;
        email = emailIn;
    }
    protected int getPhoneNumber() {
        return phoneNumber;
    }
    protected String getEmail() {
        return email;
    }
}
class StudentEntry {
    private String firstName;
    private String lastName;
    private String major;
    private int birthYear;
    private ContactInfo personalInfo;

    public StudentEntry(String fNameIn, String lNameIn, String majorIn,
                        int bYearIn, ContactInfo cInfoIn){
        firstName = fNameIn;
        lastName = lNameIn;
        major = majorIn;
        birthYear = bYearIn;
        personalInfo = cInfoIn;
    }
    public String key_1(){
        String k = lastName + birthYear + major + firstName + personalInfo.getPhoneNumber();
        return k;
    }
    public String  key_2(){
        String k = lastName + birthYear + personalInfo.getEmail();
        return k;
    }
    public String key_3(){
        String k = personalInfo.getEmail() + personalInfo.getPhoneNumber();
        return k;
    }
    public void print() throws NullPointerException{
        if(firstName == null){
            throw new NullPointerException("Entry is null...");
        }
        System.out.println(".....");
        System.out.println(firstName);
        System.out.println(lastName);
        System.out.println(major);
        System.out.println(birthYear);
        System.out.println(personalInfo.getPhoneNumber() + "," + personalInfo.getEmail());
        System.out.println(".....");
    }
}
