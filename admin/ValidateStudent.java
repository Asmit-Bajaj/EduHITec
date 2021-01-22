package admin;

public class ValidateStudent {
	
	// validate firstName
			// check for empty string or does it contain any digit or special character
			public boolean validateFirstName(String firstName) {
				if (firstName == null || firstName.length() > 40 || firstName.length() == 0)
					return false;

				return firstName.matches("[a-z A-Z]*");
			}

			// validate lastName
			// check for empty string or does it contain any digit or special character
			public boolean validateLastName(String lastName) {
				if (lastName == null || lastName.length() > 40 || lastName.length() == 0)
					return false;

				return lastName.matches("[a-z A-Z]*");

			}

			// validate email
			// check for empty string 
			//validate email type
			public boolean validateEmail(String email) {
				
				if (email == null || email.length() > 325 || email.length() == 0)
					return false;

				//^ is for start
				//$ is for end
				//@ in between for valid email
				return email.matches("^[a-zA-Z0-9.!#$%&’*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\\.[a-zA-Z0-9-]+)*$");
			}
			
			//validate password
			public boolean validatePwd(String pwd) {
				if(pwd == null || pwd.length() > 50 || pwd.length() < 8)
					return false;
				return true;
			}
			
			//validate address
			public boolean validateAddress(String address) {
				if(address == null || address.length() > 300 || address.length() == 0)
					return false;
				return true;
			}
			
			//check for real contact no length should be 10 and it should not start with 0
			public boolean validateContact(String contact_no) {
				if(contact_no == null || contact_no.length() < 10 || contact_no.length() > 10 )
					return false;
				
				return contact_no.matches("[1-9][0-9]*");
			}
			
			//check for valid city name it should not contain special character and length should not be zero
			public boolean validateCity(String city) {
				if(city == null || city.length() == 0 || city.length() > 100)
					return false;
				
				return city.matches("[A-Z a-z]*");
			}
			
			//check for valid state name it should not contain special character and length should not be zero
			public boolean validateState(String state) {
				if(state == null || state.length() == 0 || state.length() > 100)
					return false;
				
				return state.matches("[A-Z a-z]*");
			}
			
			//validate gender
			public boolean validateGender(String gender) {
				if(gender == null)
					return false;
				return true;
			}
			

//			public static void main(String[] args) {
//				//System.out.println(new Validation().validateCity("Bhopal"));
//			}
}
