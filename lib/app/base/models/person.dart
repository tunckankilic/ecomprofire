class Person {
  final String? firstName;
  final String? lastName;
  final String? phoneNumber;
  final String? address;
  final String? email;
  final String? password;

  Person({
    this.firstName,
    this.lastName,
    this.phoneNumber,
    this.address,
    this.email,
    this.password,
  });

  // Factory constructor to create a Person object from a map (e.g., JSON)
  factory Person.fromMap(Map<String, dynamic> map) {
    return Person(
      firstName: map['firstName'],
      lastName: map['lastName'],
      phoneNumber: map['phoneNumber'],
      address: map['address'],
      email: map['email'],
      password: map['password'],
    );
  }

  // Method to convert Person object to a map
  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'phoneNumber': phoneNumber,
      'address': address,
      'email': email,
      'password': password,
    };
  }

  // Override toString for easy printing
  @override
  String toString() {
    return 'Person(firstName: $firstName, lastName: $lastName, phoneNumber: $phoneNumber, address: $address, email: $email, password: $password)';
  }
}
