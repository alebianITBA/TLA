main (String[] args){
    playgame(args[0]);
}

playgame(String play){
    if(play === "Rock"){
        print("Paper");
        return;
    }
    if(play === "Paper"){
        print("Scissors");
        return;
    }
    if(play === "Scissors"){
        print("Rock");
        return;
    }
    else{
        print("Invalid");
    }
}
