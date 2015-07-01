main (String[] args){
	int aux = atoi(args[0]);
	print(factorial(aux));
}

int factorial(int n){
	int ans;
	ans = n;
	n = n - 1;
	while(n>0){
		ans = ans * n;
		n = n - 1;
	}
	return ans;
}
