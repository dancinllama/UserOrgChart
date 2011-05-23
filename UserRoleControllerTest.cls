/**
 * @description - Test Class for UserRoleController
 * Class constructed for the Organization Chart / Google Visualization API CloudSpokes Challenge
 * @author - James Loghry (james.loghry@edlconsulting.com) Twitter: dancinllama
 */
@isTest
private class UserRoleControllerTest {

  static testMethod void testConstructor() {
    Test.startTest();
    insertUsers();
    UserRoleController controller = new UserRoleController();
    Test.stopTest();
      
    System.assertNotEquals(null,controller.roles);
    
    /* 
       Cannot delete existing users and add the new ones,
       So add the ones we know of to a temp list and check the tests
       against the temp list 
    */
    List<UserRole> roles = new List<UserRole>();
    for(UserRole role : controller.roles){
      if(role.Name != null && 
        (role.Name.equals('TESTCTO') ||
         role.Name.equals('TESTCFO') ||
         role.Name.equals('TESTCEO') ||
         role.Name.equals('TESTVP'))){
           roles.add(role);
         }
    }
    
    System.assertEquals(4,roles.size());
    for(UserRole role : roles){
      for(User user : role.Users){
        System.assertEquals(role.Name + ' last',user.Name);
      }
    }
  }

  private static List<UserRole> insertRoles(){
    List<UserRole> ans = new List<UserRole>();
    
    /* 
       Usually, these inserts are done in lists.
       However, the roles need 'ParentRoleId' to be populated,
       so they must be inserted in a cascading fashion 
    */
    UserRole ceo = new UserRole(Name='TESTCEO');
    insert ceo;
      
    UserRole vp = new UserRole(Name='TESTVP',ParentRoleId=ceo.Id);
    insert vp;
      
    UserRole cfo = new UserRole(Name='TESTCFO',ParentRoleId=vp.Id);
    UserRole cto = new UserRole(Name='TESTCTO',ParentRoleId=vp.Id);
    List<UserRole> roles = new List<UserRole>{cfo,cto};
    insert roles;
      
    ans.add(ceo);
    ans.add(vp);
    ans.addAll(roles);
    return ans;
  }
   
  /* Create a new user */
  private static User getUser(String name,UserRole role,Profile profile){
    User user = new User(
      FirstName=name,
      LastName='last',
      Username=name+'@'+name+'.com',
      Email=name+'@'+name+'.com',
      CommunityNickname=name,
      Alias=name,
      LocaleSidKey='en_US',
      LanguageLocaleKey='en_US',
      TimeZoneSidKey='America/Chicago',
      EmailEncodingKey='UTF-8',
      ProfileId = profile.Id,
      UserRoleId=(role!=null)? role.Id : null
    );
    return user;
  }
   
  /* DML to insert user and roles */
  private static void insertUsers(){
  	Profile profile = [Select Id from Profile Limit 1];
  	
    List<UserRole> roles = insertRoles();
    List<User> users = new List<User>();
    for(UserRole role : roles){
      users.add(getUser(role.Name,role,profile));
    }
     
    /* Add user with null role id to test specific condition in UserRoleController */
    users.add(getUser('nullrole',null,profile));   
    insert users;
  }
  
  
}