public class NeutralActors extends Actors{
    private String name = "Civilian";
    private int level = 1;

    public NeutralActors(){}

    public NeutralActors(String n){
        this.name = n;
    }

    public String getName(){
        return name;
    }

    public void levelUp(){
        this.levelUp();
    }

    public int getLevel() {
        return level;
    }

    public void myDescription(){
        System.out.println("Hi, I am " + this.name + ", a civilian.");
        System.out.println("Level: " + level);
    }

    public void chat(PlayerActors p) {
         System.out.println(this.name + ": May god bless you " + p.getName() + ".");
    }

    public void chat(NeutralActors c){
        System.out.println(this.name + ": Good day " + c.getName() + "!");
    }
}
