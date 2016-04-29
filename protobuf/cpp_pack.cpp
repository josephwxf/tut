#include <iostream>
#include <fstream>
#include <string>
#include "addressbook.pb.h"
#include <sys/time.h>
using namespace std;

double epoch_double()
{
	struct timeval t; 
	gettimeofday(&t,  NULL); 
	return t.tv_sec + (t.tv_usec * 1.0) / 1000000.0; 
}

// Main function:  Reads the entire address book from a file,
//   adds one person based on user input, then writes it back out to the same
//   file.
int main(int argc, char* argv[]) {
  // Verify that the version of the library that we linked against is
  // compatible with the version of the headers we compiled against.
  GOOGLE_PROTOBUF_VERIFY_VERSION;

  tutorial::AddressBook address_book;
  string output; 
  int x=1;  
  int i; 
  double t1, t2; 

  if(argc >=  2) 
	  x=atoi(argv[1]); 

  t1=epoch_double(); 
  for(i=0; i<x; i++) {

	  tutorial::Person* person = address_book.add_person();

	  person->set_id(0);
	  person->set_name("bill");
	  person->set_email("bill@gmail.com");

	  tutorial::Person::PhoneNumber* phone_number = person->add_phone();

	  phone_number->set_number("123456789");
	  phone_number->set_type(tutorial::Person::MOBILE);

	  tutorial::Person::PhoneNumber* phone_number2 = person->add_phone();

	  phone_number2->set_number("987654321");
	  phone_number2->set_type(tutorial::Person::MOBILE);

	  // Write the new address book back to disk.
	  address_book.SerializeToString(&output); 
	  address_book.Clear(); 
  }
  t2=epoch_double(); 

  cerr  <<  t2-t1  <<  endl ; 

  if(x == 1) {
	  cout  <<  output ; 
  }

  // Optional:  Delete all global objects allocated by libprotobuf.
  google::protobuf::ShutdownProtobufLibrary();

  return 0;
}
