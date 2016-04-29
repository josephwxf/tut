#include <stdio.h>
#include <stdlib.h>
#include <sys/time.h>
#include "addressbook.pb-c.h"

double epoch_double()
{
	struct timeval t; 
	gettimeofday(&t,  NULL); 
	return t.tv_sec + (t.tv_usec * 1.0) / 1000000.0; 
}

int main (int argc, const char * argv[]) 
{
	double t1, t2; 

	Tutorial__AddressBook msg = TUTORIAL__ADDRESS_BOOK__INIT; 
	Tutorial__Person person = TUTORIAL__PERSON__INIT;
	Tutorial__Person__PhoneNumber phone_number = 
				TUTORIAL__PERSON__PHONE_NUMBER__INIT; 
	Tutorial__Person *aperson[] = { &person }; 
	Tutorial__Person__PhoneNumber *aphone_number[] = { &phone_number }; 
    void *buf;                     
    unsigned len;                  
	int x = 1; 
	int i = 0; 

	if(argc >=  2 ) 
		x= atoi(argv[1]); 

	t1=epoch_double(); 

	for(i=0; i<x; i++) {

		msg.n_person = 1; 
		msg.person = aperson; 

		person.id = 123;
		person.name = "bill";
		person.email = "bill@gmail.com";
		person.n_phone = 1;
		person.phone = aphone_number;
			
		phone_number.number = "123456789" ;
		phone_number.has_type = 1; 
		phone_number.type = TUTORIAL__PERSON__PHONE_TYPE__MOBILE ;

		len = tutorial__address_book__get_packed_size(&msg);
			
		buf = malloc(len);
		tutorial__address_book__pack(&msg,buf);
		if(x == 1) fwrite( buf, len, 1, stdout); 

		free(buf); // Free the allocated serialized buffer

	}

	t2=epoch_double(); 
	fprintf( stderr, "%f\n", t2-t1); 

    return 0;
}
