Class PersonClass {
	int age = -1;

	setAge(int n){
		age = n;
	}

	int getAge(){
		return age;
	}
}

main (String[] args){
	int aux = atoi(args[0]);
	Object PersonClass testperson = new PersonClass;
	testperson.setAge(aux);
	print("LaEdadEs");
	print(testperson.getAge());
}
