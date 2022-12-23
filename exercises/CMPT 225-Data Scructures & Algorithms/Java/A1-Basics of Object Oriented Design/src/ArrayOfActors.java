public class ArrayOfActors {
    Actors[] array = new Actors[1];

    public ArrayOfActors(){}

    public void addActor(Actors a){
        for(int i=0; i<array.length; i++){
            if(i == array.length){
                Actors[] newArray = new Actors[array.length+1];
                for(int j=0; j<newArray.length; j++){
                    newArray[i] = array[i];
                }
                array = newArray;
            }

            if(array[i] == a){
                System.out.println("Cast member already exists, use a different name.");
                return;
            }

            while(i == array.length-1){
                array[i] = a;
            }
            /*
            Actors current = a;
            int position = i-1;

            while(position >= 0 && (array[position]) > (current)){
                array[position+1] = array[position--];
            }
            array[position+1] = current;
            */
        }
    }

    public void removeActor(Actors a){
        for(int i=0; i<array.length; i++){
            if(array[i] == a){
                Actors[] newArray = new Actors[array.length-1];
                for(int j=0; j<newArray.length; j++){
                    if(array[i] != a) {
                        newArray[i] = array[i];
                    }
                }
                array = newArray;
            }
        }

    }

    public void printArray(){
        for(int i=0; i<array.length; i++) {
            System.out.println(array[i].toString());
        }
    }
}
