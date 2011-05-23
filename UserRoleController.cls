/**
 * @description - UserRoleController provides a list of users and role information.
 Used by OrganizationChart.component for listing an organizations chart via Google Visualization API
 * Class constructed for the Organization Chart / Google Visualization API CloudSpokes Challenge
 * @author - James Loghry (james.loghry@edlconsulting.com) Twitter: dancinllama
 */
public class UserRoleController {

  public List<UserRole> roles {get; set;}

  /**
   * @description Default Constructor
   * Initializes users member variable with User / Role information
   */
  public UserRoleController(){
  	/* 
  	   If needed, you can easily modify this query to only include certain roles or all users instead of
  	   just users with roles 
  	*/
  	roles = [Select Id,ParentRoleId,Name,(Select Id,Name,Email,SmallPhotoUrl From Users) From UserRole];
  }
  
  
}