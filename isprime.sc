main (String[] args){
	int aux = atoi(args[0]);
	print(isPrime(aux));
}

boolean isPrime(int n){
	int i = 3;
	if(n==1){
		return false;
	}
	if((n%2)==0){
		return (n==2);
	}
	while((i*i)<=n){
		if((n%i)==0){
		return false;
		}
		i = i + 2;
	}
	return true;
}